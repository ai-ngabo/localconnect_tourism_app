import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../features/booking/presentation/cubit/bookings_list_cubit.dart';
import '../features/tourism/domain/entities/guide_entity.dart';
import '../features/tourism/domain/entities/tour_entity.dart';
import '../features/tourism/presentation/cubit/tourism_cubit.dart';
import '../features/tourism/presentation/cubit/tourism_state.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TourismCubit>().loadTours();
    final email = UserSession.currentUser?.email ?? '';
    context.read<BookingsListCubit>().watchBookings(email);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openNotifications() {
    final bookingsState = context.read<BookingsListCubit>().state;
    final bookings = bookingsState is BookingsListLoaded ? bookingsState.bookings : [];
    final upcoming = bookingsState is BookingsListLoaded ? bookingsState.upcoming : [];
    final reminders = upcoming
        .where((b) => b.date.difference(DateTime.now()).inDays <= 7)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Notifications',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('You have ${bookings.length} booking(s).',
                  style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              if (reminders.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Reminders',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    ...reminders.map((booking) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.alarm, color: AppColors.primary),
                          title: Text('${booking.tour.title} on ${DateFormat('MMM dd, yyyy').format(booking.date)}'),
                          subtitle: Text('In ${booking.date.difference(DateTime.now()).inDays} day(s)'),
                        )),
                    const SizedBox(height: 10),
                  ],
                )
              else
                const Text('No reminders for the next 7 days.',
                    style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              const Divider(),
              if (bookings.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No bookings yet. Book a tour to get reminders!',
                      style: TextStyle(color: Colors.grey)),
                )
              else
                ...bookings.map((b) => ListTile(
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: Text(b.tour.title),
                      subtitle: Text(
                          '${DateFormat('MMM dd, yyyy').format(b.date)} • ${b.status}'),
                    )),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!UserSession.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
      });
      return const Scaffold();
    }

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TourismCubit, TourismState>(
          builder: (context, state) {
            if (state is TourismLoading || state is TourismInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TourismError) {
              return Center(child: Text(state.message));
            }
            final loaded = state as TourismLoaded;
            return _currentIndex == 0
                ? _buildHomeContent(loaded)
                : _buildExploreContent(loaded);
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 2) {
              Navigator.pushNamed(context, AppRoutes.bookingsList);
            } else if (index == 3) {
              Navigator.pushNamed(context, AppRoutes.profile);
            } else {
              setState(() => _currentIndex = index);
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: AppStrings.appName,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: AppStrings.explore,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: AppStrings.bookings,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: AppStrings.profile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent(TourismLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppStrings.hi} ${UserSession.currentUser?.name.split(' ').first ?? ''}!',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.nextAdventure,
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Builder(builder: (context) {
                      final bookingState = context.read<BookingsListCubit>().state;
                      final upcomingCount = bookingState is BookingsListLoaded
                          ? bookingState.upcoming.length
                          : 0;
                      return Stack(
                        children: [
                          IconButton(
                            onPressed: _openNotifications,
                            icon: const Icon(Icons.notifications_outlined),
                          ),
                          if (upcomingCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: CircleAvatar(
                                radius: 7,
                                backgroundColor: Colors.red,
                                child: Text(
                                  '$upcomingCount',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.profile),
                      icon: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          UserSession.currentUser != null
                              ? UserSession.currentUser!.name
                                  .split(' ')
                                  .map((s) => s.isNotEmpty ? s[0] : '')
                                  .join()
                                  .toUpperCase()
                              : '',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Search bar — updates TourismCubit, no setState
            TextField(
              controller: _searchController,
              onChanged: (q) => context.read<TourismCubit>().search(q),
              decoration: InputDecoration(
                hintText: AppStrings.searchToursActivities,
                hintStyle:
                    TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon:
                    Icon(Icons.search, color: Colors.grey.shade400, size: 22),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(AppStrings.popularTours,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.allTours),
                  child: const Text(AppStrings.seeAll,
                      style:
                          TextStyle(color: AppColors.primary, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 195,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.filteredTours.length,
                itemBuilder: (context, index) =>
                    _buildTourCard(state.filteredTours[index]),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(AppStrings.localGuides,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.allGuides),
                  child: const Text(AppStrings.seeAll,
                      style:
                          TextStyle(color: AppColors.primary, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.filteredGuides.length,
                itemBuilder: (context, index) =>
                    _buildGuideCard(state.filteredGuides[index]),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTourCard(TourEntity tour) {
    final tourGradients = AppStyles.tourGradients;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.tourDetail,
          arguments: tour),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.15),
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
              Container(
                height: 120,
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
                          size: 44,
                          color: AppColors.white.withValues(alpha: 0.8),
                        ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tour.title,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(tour.rating.toString(),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                        const Spacer(),
                        Text('${tour.priceRwf} Rwf',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideCard(GuideEntity guide) {
    final guideColors = AppStyles.guideColors;
    final guideIcons = AppStyles.guideIcons;

    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: guideColors[guide.id] ?? Colors.brown,
            child: AppStyles.guideImages[guide.id] != null
                ? ClipOval(
                    child: Image.asset(
                      AppStyles.guideImages[guide.id]!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(guideIcons[guide.id] ?? Icons.person,
                    size: 28, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(guide.name,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          const SizedBox(height: 2),
          Text(guide.specialty,
              style:
                  TextStyle(fontSize: 11, color: Colors.grey.shade500),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildExploreContent(TourismLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppStrings.explore,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            onChanged: (q) => context.read<TourismCubit>().search(q),
            decoration: InputDecoration(
              hintText: AppStrings.searchToursGuidesActivities,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryChip('Cultural', Icons.museum, true),
              _buildCategoryChip('Nature', Icons.park, false),
              _buildCategoryChip('Adventure', Icons.terrain, false),
              _buildCategoryChip('Food', Icons.restaurant, false),
            ],
          ),
          const SizedBox(height: 24),
          const Text('All Tours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...state.filteredTours.map(_buildExploreTourItem),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, bool selected) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon,
              color: selected ? Colors.white : Colors.grey.shade600, size: 26),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: selected ? AppColors.primary : Colors.grey.shade600,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }

  Widget _buildExploreTourItem(TourEntity tour) {
    final tourIcons = AppStyles.tourIcons;
    final tourGradients = AppStyles.tourGradients;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.tourDetail,
          arguments: tour),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: tourGradients[tour.id] ?? [AppColors.primaryLight, AppColors.primary]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppStyles.tourImages[tour.id] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        AppStyles.tourImages[tour.id]!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : Icon(tourIcons[tour.id] ?? Icons.tour,
                      color: AppColors.white.withValues(alpha: 0.8), size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tour.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('${tour.duration} · ${tour.category}',
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      Text(' ${tour.rating}',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600)),
                      const Spacer(),
                      Text('${tour.priceRwf} Rwf',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
