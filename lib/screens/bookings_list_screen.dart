import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../features/booking/domain/entities/booking_entity.dart';
import '../features/booking/presentation/cubit/bookings_list_cubit.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

class BookingsListScreen extends StatefulWidget {
  const BookingsListScreen({super.key});

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> {
  @override
  void initState() {
    super.initState();
    final email = UserSession.currentUser?.email ?? '';
    context.read<BookingsListCubit>().watchBookings(email);
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
        title: const Text(AppStrings.bookings),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<BookingsListCubit, BookingsListState>(
        builder: (context, state) {
          if (state is BookingsListLoading || state is BookingsListInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BookingsListError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Could not load your bookings. Please try again.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final loaded = state as BookingsListLoaded;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(AppStrings.upcoming,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 14),
                if (loaded.upcoming.isEmpty)
                  _buildEmptyState(AppStrings.noUpcomingBookings)
                else
                  ...loaded.upcoming.map(
                      (b) => _buildBookingCard(context, b, isUpcoming: true)),
                const SizedBox(height: 28),
                const Text(AppStrings.past,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 14),
                if (loaded.past.isEmpty)
                  _buildEmptyState(AppStrings.noPastBookings)
                else
                  ...loaded.past.map(
                      (b) => _buildBookingCard(context, b, isUpcoming: false)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_today, size: 36, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(message,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingEntity booking,
      {required bool isUpcoming}) {
    final tourGradients = AppStyles.tourGradients;
    final tourIcons = AppStyles.tourIcons;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.tourDetail,
          arguments: booking.tour),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: tourGradients[booking.tour.id] ??
                      [AppColors.primaryLight, AppColors.primary],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  tourIcons[booking.tour.id] ?? Icons.tour,
                  size: 50,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.tour.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        '${AppStrings.date} ${DateFormat('MMM dd, yyyy').format(booking.date)}',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          isUpcoming ? AppColors.success : AppColors.danger,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking.status,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
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
