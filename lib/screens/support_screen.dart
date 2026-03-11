import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.supportFaq),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          AppStrings.supportComingSoon,
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
