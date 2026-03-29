import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/settings/presentation/cubit/favorites_cubit.dart';
import '../features/tourism/domain/entities/tour_entity.dart';
import '../features/tourism/presentation/cubit/tourism_cubit.dart';
import '../features/tourism/presentation/cubit/tourism_state.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().watchFavorites();
    // Ensure tours are loaded so we can show favorite tour details
    final tourismState = context.read<TourismCubit>().state;
    if (tourismState is TourismInitial) {
      context.read<TourismCubit>().loadTours();
    }
  }

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
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, favState) {
          if (favState is FavoritesLoading || favState is FavoritesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favState is FavoritesError) {
            return Center(
              child: Text(favState.message,
                  style: TextStyle(color: Colors.grey.shade600)),
            );
          }

          final favoriteIds =
              favState is FavoritesLoaded ? favState.favoriteIds : <String>{};

          return BlocBuilder<TourismCubit, TourismState>(
            builder: (context, tourismState) {
              List<TourEntity> allTours = [];
              if (tourismState is TourismLoaded) {
                allTours = tourismState.allTours;
              }

              final favoriteTours =
                  allTours.where((t) => favoriteIds.contains(t.id)).toList();

              if (favoriteTours.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'You have no favorite tours yet.\nTap the heart icon on a tour to save it here.',
                      style:
                          TextStyle(fontSize: 15, color: Colors.grey.shade600),
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
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.tourDetail,
                        arguments: tour),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.12),
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
                              child: AppStyles.tourImages[tour.id] != null
                                  ? Image.asset(
                                      AppStyles.tourImages[tour.id]!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      tourIcons[tour.id] ?? Icons.tour,
                                      size: 40,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tour.title,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text('${tour.duration} · ${tour.category}',
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13)),
                                const SizedBox(height: 4),
                                Text(AppFormat.price(tour.priceRwf),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary)),
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
          );
        },
      ),
    );
  }
}
