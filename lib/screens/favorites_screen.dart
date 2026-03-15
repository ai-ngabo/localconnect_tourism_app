import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../models/tour_model.dart';
import '../models/favorites_store.dart';
import '../models/user_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!UserSession.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      });
      return const Scaffold();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.favorites),
        centerTitle: true,
      ),
      body: StreamBuilder<Set<String>>(
        stream: FavoritesStore.favoritesForCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final favoriteIds = snapshot.data ?? <String>{};
          final favoriteTours = Tour.sampleTours
              .where((t) => favoriteIds.contains(t.id))
              .toList();

          if (favoriteTours.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'You have no favorite tours yet.\nTap the heart icon on a tour to save it here.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final tourGradients = AppStyles.tourGradients;
          final tourIcons = AppStyles.tourIcons;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: favoriteTours.length,
            itemBuilder: (context, index) {
              final tour = favoriteTours[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.tourDetail,
                    arguments: tour,
                  );
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
          );
        },
      ),
    );
  }
}

