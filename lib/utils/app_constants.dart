import 'package:flutter/material.dart';

/// Central place for all hardcoded values (strings, colors, routes, etc.)
/// so that screens and widgets remain clean and easily maintainable.

class AppColors {
  AppColors._();

  static const primary = Color(0xFF2E7D32);
  static const primaryDark = Color(0xFF1B5E20);
  static const primaryLight = Color(0xFF4CAF50);
  static const primaryLight2 = Color(0xFF66BB6A);
  static const primaryLight3 = Color(0xFF81C784);
  static const primaryAccent = Color(0xFF26A69A);
  static const secondaryDark = Color(0xFF00695C);
  static const secondary = primaryLight; // same as old secondary hex value

  // common colors
  static const black = Colors.black;
  static const white = Colors.white;
  static const grey = Colors.grey;
  static const menuItemBg = Color(0xFFF1F8E9);

  // guide/card colors
  static const guide1 = Color(0xFF5D4037);
  static const guide2 = Color(0xFF6D4C41);
  static const guide3 = Color(0xFF4E342E);

  static const backgroundGradient1 = primaryDark;
  static const backgroundGradient2 = primary;
  static const backgroundGradient3 = Color(0xFF1B3A1B);

  static const transparentWhite = Colors.white54;
  static const success = primary;
  static const danger = Colors.redAccent;
}

class AppStrings {
  AppStrings._();

  // app-wide
  static const appName = 'Community Touring Rwanda';
  static const discoverLocalExperiences = 'Discover\nLocal\nExperiences';
  static const exploreAuthenticTours =
      'Explore authentic community tours in Rwanda';
  static const hi = 'Hi';
  static const hello = 'Hello';
  static const nextAdventure = 'Find Your Next Adventure';
  static const or = 'or';

  // splash
  static const getStarted = 'Get Started';
  static const logIn = 'Log In';

  // auth
  static const signUp = 'Sign Up';
  static const accessAccount = 'Access Your Account to\nbook local tours';
  static const createAccount =
      'Create an account to\nexplore local experiences';
  static const fullName = 'Full Name';
  static const email = 'Email';
  static const password = 'Password';
  static const confirmPassword = 'Confirm Password';
  static const forgotPassword = 'Forgot Password?';
  static const backToHome = 'Back to Home';
  static const viewBookings = 'View Bookings';
  static const alreadyHaveAccount = 'Already have an account? ';
  static const dontHaveAccount = "Don't have an account? ";
  static const seeAll = 'see all >';
  static const searchToursActivities = 'Search tours or activities';
  static const searchToursGuidesActivities =
      'Search tours, guides, activities...';
  static const popularTours = 'Popular Tours';
  static const localGuides = 'Local Guides';
  static const explore = 'Explore';
  static const categories = 'Categories';
  static const allTours = 'All Tours';
  static const duration = 'Duration:';
  static const price = 'Price:';
  static const bookingConfirmed = 'Booking Confirmed!';
  static const selectDate = 'Select Date';
  static const bookYourTour = 'Book Your Tour';
  static const bookNow = 'Book Now';
  static const clients = 'Clients';
  static const settings = 'Settings';
  static const logout = 'Log Out';
  static const cancel = 'Cancel';
  static const logoutQuestion = 'Are you sure you want to log out?';
  static const editProfile = 'Edit Profile';
  static const myTours = 'My Tours';
  static const favorites = 'Favorites';
  static const supportFaq = 'Support & FAQ';
  static const bookings = 'Bookings';
  static const upcoming = 'Upcoming';
  static const past = 'Past';
  static const noUpcomingBookings = 'No upcoming bookings';
  static const noPastBookings = 'No past bookings';
  static const date = 'Date:';
  static const register = 'Register';
  static const save = 'Save';
  static const name = 'Name';
  static const googleContinue = 'Continue with Google';
  static const googleLetter = 'G';
  static const enterYourName = 'Please enter your name';
  static const enterYourEmail = 'Please enter your email';
  static const enterValidEmail = 'Please enter a valid email';
  static const enterPassword = 'Please enter a password';
  static const passwordMin6 = 'Password must be at least 6 characters';
  static const passwordsMismatch = 'Passwords do not match';
  static const userNotFound = 'No user found for that email';
  static const wrongPassword = 'Incorrect password. Please try again';
  static const genericError = 'Something went wrong. Please try again';
  static const googleSignInComingSoon =
      'Google Sign-In will be available soon';
  static const profileUpdated = 'Profile updated';
  static const editProfileComingSoon = 'Edit Profile coming soon';
  static const favoritesComingSoon = 'Favorites coming soon';
  static const settingsComingSoon = 'Settings coming soon';
  static const supportComingSoon = 'Support & FAQ coming soon';
  static const logInTitle = 'Log In';
  static const settingsLabel = 'Settings';
  static const totalCost = 'Total Cost';
  static const numberOfGuests = 'Number of Guests';
  static const profile = 'Profile';

  // booking
  static const guests = 'Guests:';
  static const total = 'Total:';

  // categories labels
  static const cultural = 'Cultural';
  static const nature = 'Nature';
  static const adventure = 'Adventure';
  static const food = 'Food';
}

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const signup = '/signup';
  static const login = '/login';
  static const home = '/home';
  static const tourDetail = '/tour-detail';
  static const booking = '/booking';
  static const bookingsList = '/bookings-list';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const allTours = '/all-tours';
  static const allGuides = '/all-guides';
  static const favorites = '/favorites';
  static const settings = '/settings';
  static const support = '/support';
}

/// Useful helper data structures used across multiple screens (like gradients,
/// icons mapped to tour/guide ids).
class AppStyles {
  AppStyles._();

  static Map<String, List<Color>> tourGradients = {
    '1': [AppColors.primaryLight, AppColors.primary],
    '2': [AppColors.primaryLight2, AppColors.primaryDark],
    '3': [AppColors.primaryLight3, AppColors.primaryDark],
    '4': [AppColors.primaryAccent, AppColors.secondaryDark],
  };

  static Map<String, IconData> tourIcons = {
    '1': Icons.holiday_village,
    '2': Icons.eco,
    '3': Icons.terrain,
    '4': Icons.sailing,
  };

  static Map<String, Color> guideColors = {
    '1': AppColors.guide1,
    '2': AppColors.guide2,
    '3': AppColors.guide3,
  };

  static Map<String, IconData> guideIcons = {
    '1': Icons.terrain,
    '2': Icons.museum,
    '3': Icons.park,
  };
}
