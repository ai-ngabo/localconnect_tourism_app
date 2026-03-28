import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const delegate = _AppLocalizationsDelegate();

  String _t(String en, String fr, String rw) {
    switch (locale.languageCode) {
      case 'fr':
        return fr;
      case 'rw':
        return rw;
      default:
        return en;
    }
  }

  // ── App ────────────────────────────────────────────────────────────────────
  String get appName => 'Community Touring Rwanda';

  // ── Splash ─────────────────────────────────────────────────────────────────
  String get discoverLocalExperiences => _t(
        'Discover\nLocal\nExperiences',
        'Découvrez\nles Expériences\nLocales',
        'Menya\nIbirori\nby\'Akarere',
      );
  String get exploreAuthenticTours => _t(
        'Explore authentic community tours in Rwanda',
        'Explorez des circuits communautaires authentiques au Rwanda',
        'Shakisha ingendo z\'ukuri mu Rwanda',
      );
  String get getStarted => _t('Get Started', 'Commencer', 'Tangira');

  // ── Auth ───────────────────────────────────────────────────────────────────
  String get logIn => _t('Log In', 'Se connecter', 'Injira');
  String get logInTitle => _t('Log In', 'Connexion', 'Injira');
  String get signUp => _t('Sign Up', "S'inscrire", 'Iyandikishe');
  String get accessAccount => _t(
        'Access Your Account to\nbook local tours',
        'Accédez à votre compte\npour réserver des circuits',
        'Injira konti yawe\nkugira ngo uteranye',
      );
  String get createAccount => _t(
        'Create an account to\nexplore local experiences',
        'Créez un compte pour\nexplorer les expériences locales',
        'Fungura konti kugira ngo ushakishe ibirori by\'akarere',
      );
  String get fullName => _t('Full Name', 'Nom complet', 'Amazina yose');
  String get email => _t('Email', 'Email', 'Imeyili');
  String get password => _t('Password', 'Mot de passe', 'Ijambo banga');
  String get confirmPassword =>
      _t('Confirm Password', 'Confirmer le mot de passe', 'Emeza ijambo banga');
  String get forgotPassword =>
      _t('Forgot Password?', 'Mot de passe oublié?', 'Wibagiwe ijambo banga?');
  String get alreadyHaveAccount => _t(
        'Already have an account? ',
        'Vous avez déjà un compte? ',
        'Usanzwe ufite konti? ',
      );
  String get dontHaveAccount => _t(
        "Don't have an account? ",
        "Vous n'avez pas de compte? ",
        "Nta konti ufite? ",
      );
  String get or => _t('or', 'ou', 'cyangwa');
  String get googleContinue =>
      _t('Continue with Google', 'Continuer avec Google', 'Komeza na Google');

  // Validation
  String get enterYourName =>
      _t('Please enter your name', 'Veuillez saisir votre nom', 'Andika amazina yawe');
  String get enterYourEmail =>
      _t('Please enter your email', 'Veuillez saisir votre email', 'Andika imeyili yawe');
  String get enterValidEmail => _t(
        'Please enter a valid email',
        'Veuillez saisir un email valide',
        'Andika imeyili ikwiye',
      );
  String get enterPassword => _t(
        'Please enter a password',
        'Veuillez saisir un mot de passe',
        'Andika ijambo banga',
      );
  String get passwordMin6 => _t(
        'Password must be at least 6 characters',
        'Le mot de passe doit comporter au moins 6 caractères',
        'Ijambo banga rigomba kuba nibura inyuguti 6',
      );
  String get passwordsMismatch =>
      _t('Passwords do not match', 'Les mots de passe ne correspondent pas',
          'Amagambo banga ntahuye');
  String get userNotFound =>
      _t('No user found for that email', 'Aucun utilisateur trouvé pour cet email',
          'Nta muntu wabonetse kuri iyo meyili');
  String get wrongPassword =>
      _t('Incorrect password. Please try again', 'Mot de passe incorrect. Veuillez réessayer',
          'Ijambo banga si ryo. Ongera ugerageze');
  String get genericError =>
      _t('Something went wrong. Please try again', 'Quelque chose a mal tourné. Veuillez réessayer',
          'Habaye ikibazo. Ongera ugerageze');

  // ── Home ───────────────────────────────────────────────────────────────────
  String get hi => _t('Hi', 'Salut', 'Mwiriwe');
  String get hello => _t('Hello', 'Bonjour', 'Muraho');
  String get nextAdventure =>
      _t('Find Your Next Adventure', 'Trouvez votre prochaine aventure',
          'Shakisha urugendo rwawe rushya');
  String get searchToursActivities =>
      _t('Search tours or activities', 'Rechercher des circuits ou activités',
          'Shakisha ingendo cyangwa ibikorwa');
  String get searchToursGuidesActivities => _t(
        'Search tours, guides, activities...',
        'Rechercher circuits, guides, activités...',
        'Shakisha ingendo, abayobozi, ibikorwa...',
      );
  String get popularTours =>
      _t('Popular Tours', 'Circuits Populaires', 'Ingendo Zikunzwe');
  String get localGuides => _t('Local Guides', 'Guides Locaux', 'Abayobozi b\'Akarere');
  String get seeAll => _t('see all >', 'voir tout >', 'reba byose >');
  String get explore => _t('Explore', 'Explorer', 'Shakisha');
  String get notifications => _t('Notifications', 'Notifications', 'Amakuru');
  String get reminders => _t('Reminders', 'Rappels', 'Ibibutsa');
  String get close => _t('Close', 'Fermer', 'Funga');
  String get noReminders =>
      _t('No reminders for the next 7 days.', 'Aucun rappel pour les 7 prochains jours.',
          'Nta bibutsa mu minsi 7 iri imbere.');
  String get noBookingsYet =>
      _t('No bookings yet. Book a tour to get reminders!',
          'Aucune réservation encore. Réservez un circuit pour des rappels!',
          'Nta nderane urafite. Tererana ingendo!');
  String youHaveBookings(int count) => _t(
        'You have $count booking(s).',
        'Vous avez $count réservation(s).',
        'Ufite inderane $count.',
      );
  String inDays(int days) => _t('In $days day(s)', 'Dans $days jour(s)', 'Mu minsi $days');

  // ── Tours ──────────────────────────────────────────────────────────────────
  String get allTours => _t('All Tours', 'Tous les circuits', 'Ingendo Zose');
  String get duration => _t('Duration:', 'Durée:', 'Igihe:');
  String get price => _t('Price:', 'Prix:', 'Igiciro:');
  String get bookNow => _t('Book Now', 'Réserver maintenant', 'Tererana ubu');
  String get tourNotFound => _t('Tour not found.', 'Circuit introuvable.', 'Ingendo ntibonetse.');
  String get hours => _t('Hours', 'Heures', 'Amasaha');
  String get reviews => _t('(128 reviews)', '(128 avis)', '(128 ibitekerezo)');
  String get loginToSaveFavorites => _t(
        'Please log in to save tours to favorites.',
        'Veuillez vous connecter pour sauvegarder les circuits.',
        'Injira kugira ngo ubike ingendo mu z\'ingenzi.',
      );

  // ── Booking ────────────────────────────────────────────────────────────────
  String get bookYourTour => _t('Book Your Tour', 'Réservez votre circuit', 'Tererana ingendo yawe');
  String get bookingConfirmed => _t('Booking Confirmed!', 'Réservation confirmée!', 'Inderane yemejwe!');
  String get date => _t('Date:', 'Date:', 'Itariki:');
  String get guests => _t('Guests:', 'Invités:', 'Abashyitsi:');
  String get total => _t('Total:', 'Total:', 'Igiteranyo:');
  String get selectDate => _t('Select Date', 'Choisir une date', 'Hitamo itariki');
  String get numberOfGuests =>
      _t('Number of Guests', 'Nombre d\'invités', 'Umubare w\'abashyitsi');
  String get totalCost => _t('Total Cost', 'Coût total', 'Igiteranyo cyose');
  String get specialRequests =>
      _t('Special Requests', 'Demandes spéciales', 'Ibyifuzo bidasanzwe');
  String get specialRequestsHint => _t(
        'Any special requests or notes...',
        'Toute demande spéciale ou note...',
        'Ibyifuzo cyangwa ibisobanuro...',
      );
  String get confirmBooking =>
      _t('Confirm Booking', 'Confirmer la réservation', 'Emeza inderane');
  String get notSelected => _t('Not selected', 'Non sélectionné', 'Ntihiswemo');
  String get backToHome => _t('Back to Home', "Retour à l'accueil", 'Garuka ku rugo');
  String get viewBookings =>
      _t('View Bookings', 'Voir les réservations', 'Reba inderane');
  String tourBookingLabel(String title) =>
      _t('Tour: $title', 'Circuit: $title', 'Ingendo: $title');

  // ── Bookings List ──────────────────────────────────────────────────────────
  String get bookings => _t('Bookings', 'Réservations', 'Inderane');
  String get upcoming => _t('Upcoming', 'À venir', 'Ezituri imbere');
  String get past => _t('Past', 'Passées', 'Zarangiye');
  String get noUpcomingBookings =>
      _t('No upcoming bookings', 'Aucune réservation à venir', 'Nta nderane iri imbere');
  String get noPastBookings =>
      _t('No past bookings', 'Aucune réservation passée', 'Nta nderane yarangiye');
  String get cancelBooking =>
      _t('Cancel Booking', 'Annuler la réservation', 'Kureka inderane');
  String get cancelBookingConfirm => _t(
        'Are you sure you want to cancel this booking? This cannot be undone.',
        'Êtes-vous sûr de vouloir annuler cette réservation? Cela est irréversible.',
        'Urizera ko ushaka kureka iyi nderane? Ntishobora gusubizwa.',
      );
  String get keepBooking => _t('Keep', 'Garder', 'Bika');
  String get couldNotLoad => _t(
        'Could not load your bookings. Please try again.',
        'Impossible de charger vos réservations. Veuillez réessayer.',
        'Byanze gufungura inderane zawe. Ongera ugerageze.',
      );
  String get cancel => _t('Cancel', 'Annuler', 'Reka');

  // ── Profile ────────────────────────────────────────────────────────────────
  String get profile => _t('Profile', 'Profil', 'Umwirondoro');
  String get editProfile => _t('Edit Profile', 'Modifier le profil', 'Hindura umwirondoro');
  String get myTours => _t('My Tours', 'Mes circuits', 'Ingendo zanjye');
  String get favorites => _t('Favorites', 'Favoris', "Iz'ingenzi");
  String get settingsLabel => _t('Settings', 'Paramètres', 'Igenamiterere');
  String get supportFaq => _t('Support & FAQ', 'Support & FAQ', 'Ubufasha & Ibibazo');
  String get logout => _t('Log Out', 'Se déconnecter', 'Sohoka');
  String get logoutQuestion => _t(
        'Are you sure you want to log out?',
        'Êtes-vous sûr de vouloir vous déconnecter?',
        'Urizera ko ushaka gusohoka?',
      );
  String get profileUpdated =>
      _t('Profile updated', 'Profil mis à jour', 'Umwirondoro wahindutse');
  String get name => _t('Name', 'Nom', 'Izina');
  String get save => _t('Save', 'Sauvegarder', 'Bika');
  String get emailCannotChange =>
      _t('Email cannot be changed here', "L'email ne peut pas être changé ici",
          'Imeyili ntishobora guhindurwa hano');

  // ── Settings ───────────────────────────────────────────────────────────────
  String get settings => _t('Settings', 'Paramètres', 'Igenamiterere');
  String get preferences => _t('Preferences', 'Préférences', 'Amahitamo');
  String get pushNotifications =>
      _t('Push Notifications', 'Notifications push', 'Amatangazo');
  String get pushNotificationsSubtitle => _t(
        'Receive notifications about bookings and updates',
        'Recevoir des notifications sur les réservations et mises à jour',
        'Akira amatangazo ku nderane n\'amakuru mashya',
      );
  String get locationServices =>
      _t('Location Services', 'Services de localisation', 'Serivisi z\'aho uherereye');
  String get locationServicesSubtitle => _t(
        'Allow access to location for better recommendations',
        'Autoriser l\'accès à la localisation pour de meilleures recommandations',
        'Emera kugaragaza aho uri kugira ngo ubone inama nziza',
      );
  String get appearance => _t('Appearance', 'Apparence', 'Isura');
  String get language => _t('Language', 'Langue', 'Ururimi');
  String get chooseLanguage =>
      _t('Choose your preferred language', 'Choisissez votre langue préférée',
          'Hitamo ururimi rukunda');
  String get theme => _t('Theme', 'Thème', 'Isura y\'ubururu');
  String get chooseTheme =>
      _t('Choose app theme', 'Choisissez le thème de l\'application', 'Hitamo isura y\'porogaramu');
  String get themeLight => _t('Light', 'Clair', 'Urumuri');
  String get themeDark => _t('Dark', 'Sombre', 'Umwijima');
  String get themeSystem => _t('System', 'Système', 'Sisitemu');
  String get account => _t('Account', 'Compte', 'Konti');
  String get privacyPolicy =>
      _t('Privacy Policy', 'Politique de confidentialité', 'Amategeko y\'ubuzima bwite');
  String get termsOfService =>
      _t('Terms of Service', 'Conditions d\'utilisation', 'Amategeko y\'Serivisi');
  String get about => _t('About', 'À propos', 'Ibyerekeye');
  String get resetAllSettings =>
      _t('Reset All Settings', 'Réinitialiser tous les paramètres',
          'Subiza igenamiterere ryose');
  String get aboutTitle =>
      _t('About LocalConnect Tourism', 'À propos de LocalConnect Tourisme',
          'Ibyerekeye LocalConnect Tourism');
  String get aboutVersion => _t('Version: 1.0.0', 'Version: 1.0.0', 'Verisiyo: 1.0.0');
  String get aboutDescription => _t(
        'LocalConnect Tourism helps you discover amazing tours and connect with local guides in Rwanda.',
        'LocalConnect Tourisme vous aide à découvrir des circuits incroyables et à entrer en contact avec des guides locaux au Rwanda.',
        'LocalConnect Tourism ikureba ingendo idasanzwe no guhuza n\'abayobozi b\'akarere mu Rwanda.',
      );
  String get aboutCopyright =>
      _t('© 2024 LocalConnect Tourism', '© 2024 LocalConnect Tourisme',
          '© 2024 LocalConnect Tourism');
  String get resetSettings =>
      _t('Reset Settings', 'Réinitialiser les paramètres', 'Subiza igenamiterere');
  String get resetSettingsConfirm => _t(
        'Are you sure you want to reset all settings to their default values?',
        'Êtes-vous sûr de vouloir réinitialiser tous les paramètres à leurs valeurs par défaut?',
        'Urizera ko ushaka gusubiza igenamiterere ryose ku makuru ya mbere?',
      );
  String get settingsReset =>
      _t('Settings reset to defaults', 'Paramètres réinitialisés aux valeurs par défaut',
          'Igenamiterere ryasubijwe ku makuru ya mbere');
  String get ok => _t('OK', 'OK', 'Sawa');
  String featureComingSoon(String feature) => _t(
        '$feature content will be available soon.',
        'Le contenu $feature sera bientôt disponible.',
        'Ibya $feature bizobonerwa vuba.',
      );

  // ── Support ────────────────────────────────────────────────────────────────
  String get faq => _t('Frequently Asked Questions', 'Questions fréquemment posées',
      'Ibibazo bikunzwe');
  String get contactSupport => _t('Contact Support', 'Contacter le support', 'Vugana n\'ubufasha');
  String get emailSupport => _t('Email Support', 'Support par email', 'Ubufasha bwa imeyili');
  String get phoneSupport => _t('Phone Support', 'Support téléphonique', 'Ubufasha kuri terefone');
  String get liveChat => _t('Live Chat', 'Chat en direct', 'Ikiganiro kihoraho');
  String get liveChatAvailability =>
      _t('Available 9 AM - 6 PM EAT', 'Disponible 9h - 18h EAT', 'Ahari 9 - 18 EAT');
  String get needHelp => _t('Need immediate help?', 'Besoin d\'aide immédiate?',
      'Ukeneye ubufasha bwihuse?');
  String get helpDescription => _t(
        'Our support team is here to help you with any questions or issues you might have.',
        'Notre équipe de support est là pour vous aider avec toutes vos questions ou problèmes.',
        'Itsinda ryacu ry\'ubufasha riri hano kugufasha ibibazo byose ushobora kugira.',
      );

  // FAQ entries
  String get faq1Q => _t('How do I book a tour?', 'Comment réserver un circuit?',
      'Naterana ingendo gute?');
  String get faq1A => _t(
        "Browse available tours, select your preferred date and number of guests, then confirm your booking. You'll receive a confirmation email.",
        "Parcourez les circuits disponibles, sélectionnez votre date et le nombre d'invités, puis confirmez votre réservation. Vous recevrez un email de confirmation.",
        "Reba ingendo zihari, hitamo itariki n'umubare w'abashyitsi, hanyuma emeza inderane. Uzakiria imeyili y'inyemeza.",
      );
  String get faq2Q => _t('Can I cancel or modify my booking?',
      'Puis-je annuler ou modifier ma réservation?',
      'Nashobora kureka cyangwa guhindura inderane yanjye?');
  String get faq2A => _t(
        'Yes, you can cancel or modify your booking up to 24 hours before the tour starts. Contact our support team for assistance.',
        'Oui, vous pouvez annuler ou modifier votre réservation jusqu\'à 24 heures avant le début du circuit. Contactez notre équipe de support.',
        'Yego, ushobora kureka cyangwa guhindura inderane kugeza amasaha 24 mbere y\'ingendo. Vugana n\'itsinda ryacu ry\'ubufasha.',
      );
  String get faq3Q =>
      _t('Are the tours safe?', 'Les circuits sont-ils sûrs?', 'Ingendo ni zikingiye?');
  String get faq3A => _t(
        'All our tours are led by certified local guides and follow strict safety protocols. We prioritize your safety and comfort.',
        'Tous nos circuits sont dirigés par des guides locaux certifiés et suivent des protocoles de sécurité stricts. Nous privilégions votre sécurité et votre confort.',
        'Ingendo zacu zose ziyoborwa n\'abayobozi b\'akarere bemewe kandi bakurikiza amabwiriza y\'umutekano. Dushyira imbere umutekano wawe n\'uburyohe bwawe.',
      );
  String get faq4Q => _t('What should I bring on a tour?', 'Que dois-je apporter en circuit?',
      'Ntwara iki mu ngendo?');
  String get faq4A => _t(
        'Comfortable clothing, walking shoes, sunscreen, hat, water bottle, and any personal medications. Specific requirements will be mentioned in tour details.',
        'Des vêtements confortables, des chaussures de marche, de la crème solaire, un chapeau, une bouteille d\'eau et tout médicament personnel. Les exigences spécifiques seront mentionnées dans les détails du circuit.',
        'Imyambaro ihuye, inkweto zo kugenda, uduhu, igitambaro cy\'umutwe, agacupa k\'amazi, n\'imiti ya buri wese. Ibisabwa biby\'umwihariko bizavugwa mu makuru y\'ingendo.',
      );
  String get faq5Q =>
      _t('Do you offer group discounts?', 'Offrez-vous des remises de groupe?',
          'Mufite amahirwe y\'itsinda?');
  String get faq5A => _t(
        'Yes! We offer special rates for groups of 5 or more. Contact us for a custom quote.',
        'Oui! Nous offrons des tarifs spéciaux pour les groupes de 5 personnes ou plus. Contactez-nous pour un devis personnalisé.',
        'Yego! Duha ibiciro byihariye ku matsinda y\'abantu 5 cyangwa barenga. Twandikire kugira ngo tuguhe igiciro cyihariye.',
      );
  String get faq6Q => _t('What languages do guides speak?',
      'Quelles langues parlent les guides?', 'Abayobozi bavuga ururimi uruhe?');
  String get faq6A => _t(
        'Our guides are fluent in English, French, and Kinyarwanda. Some guides also speak additional languages.',
        'Nos guides parlent couramment l\'anglais, le français et le kinyarwanda. Certains guides parlent également d\'autres langues.',
        'Abayobozi bacu bavuga neza Icyongereza, Igifaransa, na Kinyarwanda. Bamwe mu bayobozi banavuga izindi ndimi.',
      );

  // ── Favorites ──────────────────────────────────────────────────────────────
  String get noFavorites => _t(
        'You have no favorite tours yet.\nTap the heart icon on a tour to save it here.',
        'Vous n\'avez pas encore de circuits favoris.\nAppuyez sur le cœur d\'un circuit pour le sauvegarder ici.',
        'Nta ngendo z\'ingenzi ufite ubu.\nKanda umutima ku ngendo kugira ngo ubike hano.',
      );

  // ── Categories ─────────────────────────────────────────────────────────────
  String get cultural => _t('Cultural', 'Culturel', 'Umuco');
  String get nature => _t('Nature', 'Nature', 'Kamere');
  String get adventure => _t('Adventure', 'Aventure', 'Inzigamugani');
  String get food => _t('Food', 'Gastronomie', 'Ibiryo');
}

extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'fr', 'rw'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
