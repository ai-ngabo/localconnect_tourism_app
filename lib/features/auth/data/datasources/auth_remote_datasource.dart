import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> signIn({required String email, required String password});
  Future<void> signUp({required String name, required String email, required String password});
  Future<void> signOut();
  Future<UserEntity> signInWithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserEntity> signIn({required String email, required String password}) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final fbUser = credential.user;
    if (fbUser == null) throw Exception('Authentication failed');

    if (!fbUser.emailVerified) {
      try {
        await fbUser.sendEmailVerification();
      } catch (_) {}
      await firebaseAuth.signOut();
      // Encode the email into the exception message for the bloc to extract
      throw Exception('email_not_verified:${fbUser.email}');
    }

    String name = fbUser.displayName ?? '';
    if (name.isEmpty) {
      try {
        final doc = await firestore.collection('users').doc(fbUser.uid).get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null && data['name'] is String) {
            name = data['name'] as String;
          }
        }
      } catch (_) {}
    }

    return UserEntity(
      uid: fbUser.uid,
      name: name.isNotEmpty ? name : (fbUser.email ?? 'User'),
      email: fbUser.email ?? email,
    );
  }

  @override
  Future<void> signUp({required String name, required String email, required String password}) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final fbUser = credential.user;
    if (fbUser == null) throw Exception('Registration failed');

    await fbUser.updateDisplayName(name);
    await firestore.collection('users').doc(fbUser.uid).set({
      'name': name,
      'email': fbUser.email,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await fbUser.sendEmailVerification();
    await firebaseAuth.signOut();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
    } catch (_) {
      // best effort, ignore any extra signout errors
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final googleAuth = await googleUser.authentication;
    if (googleAuth.accessToken == null || googleAuth.idToken == null) {
      throw Exception('Google authentication tokens missing');
    }
    final credential = fb_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await firebaseAuth.signInWithCredential(credential);
    final fbUser = userCredential.user;
    if (fbUser == null) throw Exception('Authentication failed');

    // Persist user profile to Firestore (merge so existing data is kept)
    await firestore.collection('users').doc(fbUser.uid).set({
      'name': fbUser.displayName ?? googleUser.displayName ?? '',
      'email': fbUser.email ?? '',
    }, SetOptions(merge: true));

    return UserEntity(
      uid: fbUser.uid,
      name: fbUser.displayName ?? googleUser.displayName ?? fbUser.email ?? 'User',
      email: fbUser.email ?? '',
    );
  }
}
