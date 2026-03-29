import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/tourism/domain/entities/tour_entity.dart';
import '../features/tourism/presentation/cubit/tourism_cubit.dart';
import '../features/tourism/presentation/cubit/tourism_state.dart';
import '../utils/app_constants.dart';

class AllToursScreen extends StatefulWidget {
  const AllToursScreen({super.key});

  @override
  State<AllToursScreen> createState() => _AllToursScreenState();
}

class _AllToursScreenState extends State<AllToursScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    final tourismState = context.read<TourismCubit>().state;
    if (tourismState is TourismInitial) {
      context.read<TourismCubit>().loadTours();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.allTours),
        centerTitle: true,
      ),
      body: BlocBuilder<TourismCubit, TourismState>(
        builder: (context, state) {
          if (state is TourismLoading || state is TourismInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TourismError) {
            return Center(child: Text(state.message));
          }

          final tours = state is TourismLoaded ? state.allTours : <TourEntity>[];

          return FadeTransition(
            opacity: _animController,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 2 columns on small screens, 3 on large
                final crossCount = constraints.maxWidth >= 600 ? 3 : 2;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossCount,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: tours.length,
                  itemBuilder: (context, index) => _buildGridCard(tours[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridCard(TourEntity tour) {
    final tourGradients = AppStyles.tourGradients;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.tourDetail,
          arguments: tour),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Hero(
                  tag: 'tour_image_${tour.id}',
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: tourGradients[tour.id] ??
                            [AppColors.primaryLight, AppColors.primary],
                      ),
                    ),
                    child: AppStyles.tourImages[tour.id] != null
                        ? Image.asset(
                            AppStyles.tourImages[tour.id]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Icon(
                            AppStyles.tourIcons[tour.id] ?? Icons.tour,
                            size: 40,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tour.title,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF212121)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('${tour.duration} · ${tour.category}',
                          style: const TextStyle(
                              color: Color(0xFF757575), fontSize: 11)),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 14, color: Colors.amber),
                          const SizedBox(width: 3),
                          Text('${tour.rating}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF616161))),
                          const Spacer(),
                          Text(AppFormat.price(tour.priceRwf),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
