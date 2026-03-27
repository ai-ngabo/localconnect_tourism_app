import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:community_touring_rwanda/localization/app_localizations.dart';

void main() {
  group('AppLocalizations', () {
    test('supportedLocales contains only English', () {
      expect(AppLocalizations.supportedLocales, [const Locale('en')]);
    });

    test('localeNotifier is initialized correctly', () {
      expect(AppLocalizations.localeNotifier.value, const Locale('en'));
    });

    test('themeNotifier is initialized correctly', () {
      expect(AppLocalizations.themeNotifier.value, ThemeMode.light);
    });

    test('AppLocalizations constructor creates instance', () {
      final localizations = AppLocalizations(const Locale('en'));
      expect(localizations.locale, const Locale('en'));
    });
  });
}
