import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static final ValueNotifier<Locale> localeNotifier =
      ValueNotifier(const Locale('en'));

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  // For framework widgets we keep only English to avoid unsupported
  // Material/Cupertino localization warnings for RW/FR.
  static const supportedLocales = [Locale('en')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    // Use the singleton localeNotifier selected by settings, instead of
    // framework locale, so we can display en/rw/fr app strings.
    return AppLocalizations(localeNotifier.value);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'rw': {
      'appName': 'Community Touring Rwanda',
      'settingsLabel': 'Imiterere',
      'preferences': 'Ibyihitamo',
      'pushNotifications': 'Itumanaho rya Push',
      'pushNotificationsDesc':
          'Bona itumanaho ku makuru yo kubika no kuvugurura',
      'locationServices': 'Serivisi z’Aho Uri',
      'locationServicesDesc': 'Reka kubona aho uri kugirango ubone inama nziza',
      'appearance': 'Imiterere',
      'language': 'Ururimi',
      'chooseLanguage': 'Hitamo ururimi ukeneye',
      'theme': 'Insanganyamatsiko',
      'chooseTheme': 'Hitamo insanganyamatsiko y’ikoranabuhanga',
      'account': 'Konti',
      'privacyPolicy': 'Politiki y’Ubuzima bw’Iganga',
      'termsOfService': 'Amategeko y’Serivisi',
      'about': 'Ibyerekeye',
      'resetAllSettings': 'Ohereza Ibyose ku Byimbitse',
      'resetSettings': 'Gusubiza Amabwiriza',
      'resetConfirm': 'Urabyemera ko usubiza gahunda zose ku gaciro k’imbere?',
      'cancel': 'Hagarika',
      'reset': 'Subiza',
      'ok': 'Oya',
      'language_rw': 'Ikinyarwanda',
      'language_fr': 'Igifaransa',
      'comingSoon': 'ibiri muri iki gice bizagera vuba',
      'privacyPolicyContent': 'Politiki y’Ubuzima bw’Iganga izaboneka vuba.',
      'termsServiceContent': 'Amategeko y’Serivisi azaboneka vuba.',
      'aboutTitle': 'Ibyerekeye LocalConnect Tourism',
      'aboutDetails':
          'LocalConnect Tourism igufasha kubona ingendo nziza no guhura n’abayobozi b’aho muri Rwanda.',
      'version': 'Verisiyo: 1.0.0',
      'poweredBy': '© 2024 LocalConnect Tourism',
      'settingsResetConfirmation': 'Amabwiriza yasubijwe ku byimbitse',
      'logInTitle': 'Injira',
      'accessAccount': 'Fungura konti yawe kugirango ubike ingendo',
      'email': 'Imeyili',
      'password': 'Ijambo ry ibanga',
      'forgotPassword': 'Wibagiwe ijambo ry ibanga?',
      'dontHaveAccount': 'Nta konti ufite? ',
      'signUp': 'Iyandikishe',
      'or': 'cyangwa',
      'googleLetter': 'G',
      'googleContinue': 'Komeza na Google',
      'enterYourEmail': 'Injiza email yawe',
      'enterValidEmail': 'Injiza email ikwiriye',
      'enterPassword': 'Injiza ijambo ry ibanga',
    },
    'en': {
      'appName': 'Community Touring Rwanda',
      'settingsLabel': 'Settings',
      'preferences': 'Preferences',
      'pushNotifications': 'Push Notifications',
      'pushNotificationsDesc':
          'Receive notifications about bookings and updates',
      'locationServices': 'Location Services',
      'locationServicesDesc':
          'Allow access to location for better recommendations',
      'appearance': 'Appearance',
      'language': 'Language',
      'chooseLanguage': 'Choose your preferred language',
      'theme': 'Theme',
      'chooseTheme': 'Choose app theme',
      'account': 'Account',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'about': 'About',
      'resetAllSettings': 'Reset All Settings',
      'resetSettings': 'Reset Settings',
      'resetConfirm':
          'Are you sure you want to reset all settings to their default values?',
      'cancel': 'Cancel',
      'reset': 'Reset',
      'ok': 'OK',
      'language_rw': 'Kinyarwanda',
      'language_fr': 'French',
      'comingSoon': 'content will be available soon',
      'privacyPolicyContent': 'Privacy Policy content will be available soon.',
      'termsServiceContent': 'Terms of Service content will be available soon.',
      'aboutTitle': 'About LocalConnect Tourism',
      'aboutDetails':
          'LocalConnect Tourism helps you discover amazing tours and connect with local guides in Rwanda.',
      'version': 'Version: 1.0.0',
      'poweredBy': '© 2024 LocalConnect Tourism',
      'settingsResetConfirmation': 'Settings reset to defaults',
      'logInTitle': 'Log In',
      'accessAccount': 'Access Your Account to\nbook local tours',
      'email': 'Email',
      'password': 'Password',
      'forgotPassword': 'Forgot Password?',
      'dontHaveAccount': "Don't have an account? ",
      'signUp': 'Sign Up',
      'or': 'or',
      'googleLetter': 'G',
      'googleContinue': 'Continue with Google',
      'enterYourEmail': 'Please enter your email',
      'enterValidEmail': 'Please enter a valid email',
      'enterPassword': 'Please enter a password',
    },
    'fr': {
      'appName': 'Community Touring Rwanda',
      'settingsLabel': 'Paramètres',
      'preferences': 'Préférences',
      'pushNotifications': 'Notifications Push',
      'pushNotificationsDesc':
          'Recevoir des notifications sur les réservations et mises à jour',
      'locationServices': 'Services de Localisation',
      'locationServicesDesc':
          'Autoriser l\'accès à la localisation pour de meilleures recommandations',
      'appearance': 'Apparence',
      'language': 'Langue',
      'chooseLanguage': 'Choisissez votre langue préférée',
      'theme': 'Thème',
      'chooseTheme': 'Choisissez le thème de l\'application',
      'account': 'Compte',
      'privacyPolicy': 'Politique de Confidentialité',
      'termsOfService': 'Conditions de Service',
      'about': 'À Propos',
      'resetAllSettings': 'Réinitialiser Tous les Paramètres',
      'resetSettings': 'Réinitialiser les Paramètres',
      'resetConfirm':
          'Êtes-vous sûr de vouloir réinitialiser tous les paramètres à leurs valeurs par défaut ?',
      'cancel': 'Annuler',
      'reset': 'Réinitialiser',
      'ok': 'OK',
      'language_rw': 'Kinyarwanda',
      'language_fr': 'Français',
      'comingSoon': 'le contenu sera disponible bientôt',
      'privacyPolicyContent':
          'Le contenu de la Politique de Confidentialité sera disponible bientôt.',
      'termsServiceContent':
          'Le contenu des Conditions de Service sera disponible bientôt.',
      'aboutTitle': 'À Propos de LocalConnect Tourism',
      'aboutDetails':
          'LocalConnect Tourism vous aide à découvrir des visites incroyables et à vous connecter avec des guides locaux au Rwanda.',
      'version': 'Version : 1.0.0',
      'poweredBy': '© 2024 LocalConnect Tourism',
      'settingsResetConfirmation':
          'Paramètres réinitialisés aux valeurs par défaut',
      'logInTitle': 'Se Connecter',
      'accessAccount':
          'Accédez à Votre Compte pour réserver des visites locales',
      'email': 'Email',
      'password': 'Mot de Passe',
      'forgotPassword': 'Mot de Passe Oublié ?',
      'dontHaveAccount': 'Vous n\'avez pas de compte ? ',
      'signUp': 'S\'inscrire',
      'or': 'ou',
      'googleLetter': 'G',
      'googleContinue': 'Continuer avec Google',
      'enterYourEmail': 'Veuillez saisir votre email',
      'enterValidEmail': 'Veuillez saisir un email valide',
      'enterPassword': 'Veuillez saisir un mot de passe',
    },
  };

  String _translate(String key) {
    final code = locale.languageCode;
    final localized = _localizedValues[code]?[key];
    if (localized != null) return localized;
    return _localizedValues['en']?[key] ?? key;
  }

  String get appName => _translate('appName');
  String get settingsLabel => _translate('settingsLabel');
  String get preferences => _translate('preferences');
  String get pushNotifications => _translate('pushNotifications');
  String get locationServices => _translate('locationServices');
  String get appearance => _translate('appearance');
  String get language => _translate('language');
  String get chooseLanguage => _translate('chooseLanguage');
  String get theme => _translate('theme');
  String get chooseTheme => _translate('chooseTheme');
  String get account => _translate('account');
  String get privacyPolicy => _translate('privacyPolicy');
  String get termsOfService => _translate('termsOfService');
  String get about => _translate('about');
  String get resetAllSettings => _translate('resetAllSettings');
  String get resetSettings => _translate('resetSettings');
  String get resetConfirm => _translate('resetConfirm');
  String get cancel => _translate('cancel');
  String get reset => _translate('reset');
  String get ok => _translate('ok');
  String get languageRw => _translate('language_rw');
  String get languageFr => _translate('language_fr');
  String get comingSoon => _translate('comingSoon');
  String get privacyPolicyContent => _translate('privacyPolicyContent');
  String get termsServiceContent => _translate('termsServiceContent');
  String get aboutTitle => _translate('aboutTitle');
  String get aboutDetails => _translate('aboutDetails');
  String get version => _translate('version');
  String get poweredBy => _translate('poweredBy');
  String get settingsResetConfirmation =>
      _translate('settingsResetConfirmation');
  String get logInTitle => _translate('logInTitle');
  String get accessAccount => _translate('accessAccount');
  String get email => _translate('email');
  String get password => _translate('password');
  String get forgotPassword => _translate('forgotPassword');
  String get dontHaveAccount => _translate('dontHaveAccount');
  String get signUp => _translate('signUp');
  String get or => _translate('or');
  String get googleLetter => _translate('googleLetter');
  String get googleContinue => _translate('googleContinue');
  String get enterYourEmail => _translate('enterYourEmail');
  String get enterValidEmail => _translate('enterValidEmail');
  String get enterPassword => _translate('enterPassword');

  String get pushNotificationsDesc => _translate('pushNotificationsDesc');
  String get locationServicesDesc => _translate('locationServicesDesc');

  String languageName(String languageCode) {
    if (languageCode == 'en') return 'English';
    if (languageCode == 'rw') return languageRw;
    if (languageCode == 'fr') return languageFr;
    return languageCode;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .map((loc) => loc.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
