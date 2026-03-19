import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../../domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FirebaseFirestore firestore;
  final fb_auth.FirebaseAuth firebaseAuth;

  FavoritesRepositoryImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  DocumentReference get _docRef {
    final uid = firebaseAuth.currentUser?.uid;
    return firestore.collection('favorites').doc(uid);
  }

  @override
  Stream<Set<String>> favoritesStream() {
    final user = firebaseAuth.currentUser;
    if (user == null) return const Stream.empty();

    return _docRef.snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return <String>{};
      final ids = (data['tourIds'] as List?)?.cast<String>() ?? const <String>[];
      return ids.toSet();
    });
  }

  @override
  Future<void> toggleFavorite(String tourId, {required bool shouldFavorite}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception('User not logged in');

    if (shouldFavorite) {
      await _docRef.set(
        {'tourIds': FieldValue.arrayUnion([tourId])},
        SetOptions(merge: true),
      );
    } else {
      await _docRef.set(
        {'tourIds': FieldValue.arrayRemove([tourId])},
        SetOptions(merge: true),
      );
    }
  }
}
