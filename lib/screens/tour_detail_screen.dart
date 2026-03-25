import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/settings/presentation/cubit/favorites_cubit.dart';
import '../features/tourism/domain/entities/tour_entity.dart';
import '../utils/app_constants.dart';
import '../models/user_model.dart';

class TourDetailScreen extends StatefulWidget {
  const TourDetailScreen({super.key});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Start watching favorites for the favorite button
    context.read<FavoritesCubit>().watchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final tour = ModalRoute.of(context)?.settings.arguments as TourEntity?;

    if (tour == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Tour not found.')),
      );
    }

    final tourGradients = AppStyles.tourGradients;

    return Scaffold(
      body: Column(
        children: [
          // Hero image area
          Stack(
            children: [
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: tourGradients[tour.id] ??
                        [AppColors.primaryLight, AppColors.primary],
                  ),
                ),
                child: Center(
                  child: AppStyles.tourImages[tour.id] != null
                      ? Image.asset(
                          AppStyles.tourImages[tour.id]!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Icon(
                          AppStyles.tourIcons[tour.id] ?? Icons.tour,
                          size: 80,
                          color: AppColors.white.withValues(alpha: 0.5),
                        ),
                ),
              ),
              // Back button
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 12,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              // Favorite button
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 12,
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, favState) {
                    final favoriteIds = favState is FavoritesLoaded
                        ? favState.favoriteIds
                        : <String>{};
                    final isFavorite = favoriteIds.contains(tour.id);

                    return GestureDetector(
                      onTap: () {
                        if (!UserSession.isLoggedIn) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please log in to save tours to favorites.'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                          Navigator.pushNamed(context, AppRoutes.login);
                          return;
                        }
                        context
                            .read<FavoritesCubit>()
                            .toggleFavorite(tour.id,
                                shouldFavorite: !isFavorite);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      tour.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Rating row
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${tour.rating}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' (128 reviews)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Description
                    Text(
                      tour.description.split('\n\n').first,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Duration
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text(
                          AppStrings.duration,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Text(
                        '${tour.duration}  |  Hours',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Price
                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${AppStrings.price} ${tour.priceRwf} Rwf',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Full description
                    if (tour.description.contains('\n\n'))
                      Text(
                        tour.description.split('\n\n').last,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          // Book Now button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.booking,
                      arguments: tour);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  AppStrings.bookNow,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
