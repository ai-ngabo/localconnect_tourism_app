import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/booking/presentation/cubit/booking_form_cubit.dart';
import 'features/booking/presentation/cubit/bookings_list_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/settings/presentation/cubit/favorites_cubit.dart';
import 'features/tourism/presentation/cubit/tourism_cubit.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';
import 'screens/all_guides_screen.dart';
import 'screens/all_tours_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/bookings_list_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/support_screen.dart';
import 'screens/tour_detail_screen.dart';
import 'utils/app_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialise GetIt service locator
  await di.initDependencies();

  // Keep legacy UserSession in sync for screens that still reference it
  await UserSession.loadFromFirebase();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const CommunityTouringRwandaApp());
}

class CommunityTouringRwandaApp extends StatelessWidget {
  const CommunityTouringRwandaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC — lives for the entire app lifetime
        BlocProvider<AuthBloc>(create: (_) => di.sl<AuthBloc>()),

        // Tourism Cubit — provides tours/guides data globally
        BlocProvider<TourismCubit>(create: (_) => di.sl<TourismCubit>()),

        // Booking form Cubit — manages date/guest selection on the booking screen
        BlocProvider<BookingFormCubit>(
            create: (_) => di.sl<BookingFormCubit>()),

        // Bookings list Cubit — streams user bookings from Firestore
        BlocProvider<BookingsListCubit>(
            create: (_) => di.sl<BookingsListCubit>()),

        // Favorites Cubit — streams favorite tour IDs from Firestore
        BlocProvider<FavoritesCubit>(create: (_) => di.sl<FavoritesCubit>()),

        // Profile Cubit — loads and updates user profile data
        BlocProvider<ProfileCubit>(create: (_) => di.sl<ProfileCubit>()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          useMaterial3: true,
        ),
        initialRoute:
            UserSession.isLoggedIn ? AppRoutes.home : AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.signup: (context) => const SignupScreen(),
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.tourDetail: (context) => const TourDetailScreen(),
          AppRoutes.booking: (context) => const BookingScreen(),
          AppRoutes.bookingsList: (context) => const BookingsListScreen(),
          AppRoutes.profile: (context) => const ProfileScreen(),
          AppRoutes.editProfile: (context) => const EditProfileScreen(),
          AppRoutes.allTours: (context) => const AllToursScreen(),
          AppRoutes.allGuides: (context) => const AllGuidesScreen(),
          AppRoutes.favorites: (context) => const FavoritesScreen(),
          AppRoutes.settings: (context) => const SettingsScreen(),
          AppRoutes.support: (context) => const SupportScreen(),
        },
      ),
    );
  }
}
