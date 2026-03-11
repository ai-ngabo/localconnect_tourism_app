import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsLabel),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          AppStrings.settingsComingSoon,
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
