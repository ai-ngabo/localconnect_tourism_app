class User {
  String name;
  String email;

  User({required this.name, required this.email});
}

/// Simple in-memory session tracking. In a real app this would be backed by
/// secure storage / auth.
class UserSession {
  static User? currentUser;

  static bool get isLoggedIn => currentUser != null;

  static void login(User user) {
    currentUser = user;
  }

  static void logout() {
    currentUser = null;
  }
}
