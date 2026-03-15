import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  bool _isLoggedIn = false;

  String get name => _name;
  String get email => _email;
  bool get isLoggedIn => _isLoggedIn;

  String get initials {
    final parts = _name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  void login({required String name, required String email}) {
    _name = name;
    _email = email;
    _isLoggedIn = true;
    notifyListeners();
  }

  void updateProfile({required String name, required String email}) {
    _name = name;
    _email = email;
    notifyListeners();
  }

  void logout() {
    _name = '';
    _email = '';
    _isLoggedIn = false;
    notifyListeners();
  }
}
