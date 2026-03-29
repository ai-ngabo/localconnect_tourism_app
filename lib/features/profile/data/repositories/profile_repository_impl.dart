import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final fb_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProfileRepositoryImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.storage,
  });

  DocumentReference _userDoc(String uid) =>
      firestore.collection('users').doc(uid);

  @override
  Future<UserProfileEntity?> getProfile() async {
    final fbUser = firebaseAuth.currentUser;
    if (fbUser == null) return null;

    String name = fbUser.displayName ?? '';
    String phone = '';
    String bio = '';
    String photoUrl = fbUser.photoURL ?? '';

    try {
      final doc = await _userDoc(fbUser.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          if (name.isEmpty && data['name'] is String) {
            name = data['name'] as String;
          }
          phone = data['phone'] as String? ?? '';
          bio = data['bio'] as String? ?? '';
          if (photoUrl.isEmpty && data['photoUrl'] is String) {
            photoUrl = data['photoUrl'] as String;
          }
        }
      }
    } catch (_) {}

    return UserProfileEntity(
      uid: fbUser.uid,
      name: name.isNotEmpty ? name : (fbUser.email ?? 'User'),
      email: fbUser.email ?? '',
      phone: phone,
      bio: bio,
      photoUrl: photoUrl,
    );
  }

  @override
  Future<void> updateProfile({
    required String name,
    String? phone,
    String? bio,
  }) async {
    final fbUser = firebaseAuth.currentUser;
    if (fbUser == null) return;

    await fbUser.updateDisplayName(name);

    final updates = <String, dynamic>{'name': name};
    if (phone != null) updates['phone'] = phone;
    if (bio != null) updates['bio'] = bio;

    await _userDoc(fbUser.uid).set(updates, SetOptions(merge: true));
  }

  @override
  Future<String> uploadProfilePhoto(File imageFile) async {
    final fbUser = firebaseAuth.currentUser;
    if (fbUser == null) throw Exception('Not authenticated');

    final ref = storage.ref().child('profile_photos/${fbUser.uid}.jpg');
    await ref.putFile(imageFile);
    final downloadUrl = await ref.getDownloadURL();

    // Update Auth photoURL + Firestore
    await fbUser.updatePhotoURL(downloadUrl);
    await _userDoc(fbUser.uid)
        .set({'photoUrl': downloadUrl}, SetOptions(merge: true));

    return downloadUrl;
  }
}
