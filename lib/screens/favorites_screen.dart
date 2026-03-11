import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.favorites),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          AppStrings.favoritesComingSoon,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
