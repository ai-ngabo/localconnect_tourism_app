class AppStrings {
  // English
  static const Map<String, String> en = {
    'settings': 'Settings',
    'profile': 'Profile',
    'edit_profile': 'Edit Profile',
    'theme': 'Theme',
    'dark_mode': 'Dark Mode',
    'language': 'Language',
    'notifications': 'Notifications',
    'enable_notifications': 'Enable Notifications',
    'save': 'Save',
    'cancel': 'Cancel',
    'name': 'Name',
    'email': 'Email',
    'phone': 'Phone',
    'location': 'Location',
    'bio': 'Bio',
    'change_password': 'Change Password',
    'logout': 'Logout',
    'account': 'Account',
    'preferences': 'Preferences',
    'about': 'About',
    'help': 'Help',
    'privacy_policy': 'Privacy Policy',
    'terms_conditions': 'Terms & Conditions',
  };

  // Kinyarwanda
  static const Map<String, String> rw = {
    'settings': 'Ibisabwa',
    'profile': 'Umwirondoro',
    'edit_profile': 'Menya Umwirondoro',
    'theme': 'Imiterere',
    'dark_mode': 'Ijoro',
    'language': 'Ururimi',
    'notifications': 'Iyifatazo',
    'enable_notifications': 'Shyiramo Iyifatazo',
    'save': 'Kwandika',
    'cancel': 'Guhagarika',
    'name': 'Izina',
    'email': 'Email',
    'phone': 'Terefoni',
    'location': 'Aho Ubicukira',
    'bio': 'Biyografiya',
    'change_password': 'Shinzagumasoko',
    'logout': 'Gusohoka',
    'account': 'Konti',
    'preferences': 'Ibyifuzo',
    'about': 'Kubyerekeye',
    'help': 'Ubufasha',
    'privacy_policy': 'Politiki y\'Ubwiyunge',
    'terms_conditions': 'Ihame n\'Amashyirahamwe',
  };

  static String getText(String key, String languageCode) {
    if (languageCode == 'rw') {
      return rw[key] ?? en[key] ?? key;
    }
    return en[key] ?? key;
  }
}
