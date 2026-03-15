import 'package:flutter/material.dart';
import '../models/tour_model.dart';
import '../utils/app_constants.dart';

class AllToursScreen extends StatelessWidget {
  const AllToursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tourGradients = AppStyles.tourGradients;
    final tourIcons = AppStyles.tourIcons;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.allTours),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: Tour.sampleTours.length,
        itemBuilder: (context, index) {
          final tour = Tour.sampleTours[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.tourDetail,
                  arguments: tour);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: tourGradients[tour.id] ??
                            [AppColors.primaryLight, AppColors.primary],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        tourIcons[tour.id] ?? Icons.tour,
                        size: 40,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tour.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${tour.duration} · ${tour.category}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${tour.priceRwf} Rwf',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
