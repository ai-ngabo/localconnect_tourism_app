import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class User {
  String name;
  String email;

  User({required this.name, required this.email});
}

/// App-level user session backed by Firebase Auth + Firestore.
class UserSession {
  static User? currentUser;

  /// Whether there is a Firebase-authenticated user.
  static bool get isLoggedIn =>
      fb_auth.FirebaseAuth.instance.currentUser != null;

  /// Load the current user from FirebaseAuth/Firestore into [currentUser].
  static Future<void> loadFromFirebase() async {
    final fbUser = fb_auth.FirebaseAuth.instance.currentUser;
    if (fbUser == null) {
      currentUser = null;
      return;
    }

    String name = fbUser.displayName ?? '';

    if (name.isEmpty) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(fbUser.uid)
            .get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null && data['name'] is String) {
            name = data['name'] as String;
          }
        }
      } catch (_) {
        // Ignore and fall back to email-based name
      }
    }

    currentUser = User(
      name: name.isNotEmpty ? name : (fbUser.email ?? 'User'),
      email: fbUser.email ?? '',
    );
  }

  /// Set the in-memory session from an already-known app [User].
  static void login(User user) {
    currentUser = user;
  }

  /// Sign out from Firebase and clear local session.
  static Future<void> logout() async {
    await fb_auth.FirebaseAuth.instance.signOut();
    currentUser = null;
  }
}
