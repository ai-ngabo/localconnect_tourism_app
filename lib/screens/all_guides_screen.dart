import 'package:flutter/material.dart';
import '../models/tour_model.dart'; // guides are also in this file
import '../utils/app_constants.dart';

class AllGuidesScreen extends StatelessWidget {
  const AllGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final guideColors = AppStyles.guideColors;
    final guideIcons = AppStyles.guideIcons;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.localGuides),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: Guide.sampleGuides.length,
        itemBuilder: (context, index) {
          final guide = Guide.sampleGuides[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: guideColors[guide.id] ?? AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AppStyles.guideImages[guide.id] != null
                      ? Image.asset(
                          AppStyles.guideImages[guide.id]!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          guideIcons[guide.id] ?? Icons.person,
                          color: AppColors.white,
                        ),
                ),
              ),
              title: Text(
                guide.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(guide.specialty),
            ),
          );
        },
      ),
    );
  }
}
