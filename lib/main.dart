import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/notification_provider.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/landing_page.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/auth/presentation/pages/forgot_password_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'LocalConnect Rwanda',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/landing': (context) => const LandingPage(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/forgot-password': (context) => const ForgotPasswordPage(),
              '/settings': (context) => const SettingsPage(),
              '/home': (context) => const HomePage(),
            },
          );
        },
      ),
    );
  }
}
