import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

/// Simple favorites storage backed by Firestore.
class FavoritesStore {
  FavoritesStore._();

  static final _favoritesRef =
      FirebaseFirestore.instance.collection('favorites');

  /// Stream of favorite tour ids for the currently signed-in user.
  static Stream<Set<String>> favoritesForCurrentUser() {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _favoritesRef.doc(user.uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return <String>{};
      final ids = (data['tourIds'] as List?)?.cast<String>() ?? const <String>[];
      return ids.toSet();
    });
  }

  /// Add or remove a favorite tour id for the current user.
  static Future<void> toggleFavorite(String tourId,
      {required bool shouldFavorite}) async {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final docRef = _favoritesRef.doc(user.uid);

    if (shouldFavorite) {
      await docRef.set(
        {
          'tourIds': FieldValue.arrayUnion([tourId]),
        },
        SetOptions(merge: true),
      );
    } else {
      await docRef.set(
        {
          'tourIds': FieldValue.arrayRemove([tourId]),
        },
        SetOptions(merge: true),
      );
    }
  }
}

