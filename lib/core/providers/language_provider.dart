import 'package:flutter/material.dart';

enum AppLanguage { english, kinyarwanda }

class LanguageProvider extends ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.english;

  AppLanguage get currentLanguage => _currentLanguage;

  String get languageCode {
    return _currentLanguage == AppLanguage.english ? 'en' : 'rw';
  }

  void changeLanguage(AppLanguage language) {
    _currentLanguage = language;
    notifyListeners();
  }

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == AppLanguage.english
        ? AppLanguage.kinyarwanda
        : AppLanguage.english;
    notifyListeners();
  }
}
