import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import 'package:intl/intl.dart';
import '../models/tour_model.dart';
import '../models/booking_store.dart';
import '../models/user_model.dart';

class BookingsListScreen extends StatelessWidget {
  const BookingsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserSession.currentUser;
    final userBookings = BookingStore.bookingsForUser(user);
    final upcomingBookings =
        userBookings.where((b) => b.status == 'Confirmed').toList();
    final pastBookings =
        userBookings.where((b) => b.status == 'Completed').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bookings),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming section
            const Text(
              AppStrings.upcoming,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
            if (upcomingBookings.isEmpty)
              _buildEmptyState(AppStrings.noUpcomingBookings)
            else
              ...upcomingBookings.map((booking) =>
                  _buildBookingCard(context, booking, isUpcoming: true)),
            const SizedBox(height: 28),
            // Past section
            const Text(
              AppStrings.past,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 14),
            if (pastBookings.isEmpty)
              _buildEmptyState(AppStrings.noPastBookings)
            else
              ...pastBookings.map((booking) =>
                  _buildBookingCard(context, booking, isUpcoming: false)),
          ],
        ),
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
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking,
      {required bool isUpcoming}) {
    final tourGradients = AppStyles.tourGradients;

    final Map<String, IconData> tourIcons = {
      '1': Icons.holiday_village,
      '2': Icons.eco,
      '3': Icons.terrain,
      '4': Icons.sailing,
    };

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.tourDetail,
            arguments: booking.tour);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
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
                  color: AppColors.white.withOpacity(0.5),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.tour.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        '${AppStrings.date} ${DateFormat('MMM dd, yyyy').format(booking.date)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isUpcoming ? AppColors.success : AppColors.danger,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      booking.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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
