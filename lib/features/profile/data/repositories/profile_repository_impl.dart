import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final fb_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  ProfileRepositoryImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserProfileEntity?> getProfile() async {
    final fbUser = firebaseAuth.currentUser;
    if (fbUser == null) return null;

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

    return UserProfileEntity(
      uid: fbUser.uid,
      name: name.isNotEmpty ? name : (fbUser.email ?? 'User'),
      email: fbUser.email ?? '',
      photoUrl: fbUser.photoURL,
    );
  }

  @override
  Future<void> updateProfile({required String name}) async {
    final fbUser = firebaseAuth.currentUser;
    if (fbUser == null) return;

    await fbUser.updateDisplayName(name);
    await firestore.collection('users').doc(fbUser.uid).update({'name': name});
  }
}
