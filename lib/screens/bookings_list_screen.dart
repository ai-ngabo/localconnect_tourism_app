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
                if (loaded.cancelled.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  const Text('Cancelled',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                  const SizedBox(height: 14),
                  ...loaded.cancelled.map(
                      (b) => _buildBookingCard(context, b, isUpcoming: false)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Cancel Dialog ──────────────────────────────────────────────────────────

  void _showCancelDialog(BuildContext parentContext, String bookingId) {
    final cubit = parentContext.read<BookingsListCubit>();
    showDialog(
      context: parentContext,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
            SizedBox(width: 10),
            Text('Cancel Booking'),
          ],
        ),
        content: const Text(
            'Are you sure you want to cancel this booking? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await cubit.cancelBooking(bookingId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking cancelled'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Cancel Booking',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ── Edit Bottom Sheet ──────────────────────────────────────────────────────

  void _showEditSheet(BuildContext parentContext, BookingEntity booking) {
    final cubit = parentContext.read<BookingsListCubit>();
    DateTime selectedDate = booking.date;
    int guestCount = booking.guests;

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final totalCost = booking.tour.priceRwf * guestCount;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header
                  Row(
                    children: [
                      const Icon(Icons.edit_calendar, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Edit: ${booking.tour.title}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Date picker
                  const Text('Date',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.primary,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        setSheetState(() => selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 20, color: Colors.grey.shade500),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('EEE, MMM dd, yyyy')
                                .format(selectedDate),
                            style: const TextStyle(fontSize: 15),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_drop_down,
                              color: Colors.grey.shade500),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Guest counter
                  const Text('Guests',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade50,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.people_outline,
                            size: 20, color: Colors.grey.shade500),
                        const SizedBox(width: 12),
                        Text('$guestCount',
                            style: const TextStyle(fontSize: 16)),
                        const Spacer(),
                        IconButton(
                          onPressed: guestCount > 1
                              ? () =>
                                  setSheetState(() => guestCount--)
                              : null,
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.remove, size: 18),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setSheetState(() => guestCount++),
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Total cost
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.menuItemBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Cost',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                        Text(AppFormat.price(totalCost),
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        cubit.updateBooking(
                              bookingId: booking.id,
                              date: selectedDate,
                              guests: guestCount,
                              totalCost: totalCost,
                            );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking updated successfully'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Changes',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Empty State ────────────────────────────────────────────────────────────

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

  // ── Booking Card ───────────────────────────────────────────────────────────

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
          color: Theme.of(context).cardTheme.color ?? Colors.white,
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
                image: AppStyles.tourImages[booking.tour.id] != null
                    ? DecorationImage(
                        image:
                            AssetImage(AppStyles.tourImages[booking.tour.id]!),
                        fit: BoxFit.cover,
                      )
                    : null,
                gradient: AppStyles.tourImages[booking.tour.id] == null
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: tourGradients[booking.tour.id] ??
                            [AppColors.primaryLight, AppColors.primary],
                      )
                    : null,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: AppStyles.tourImages[booking.tour.id] == null
                  ? Center(
                      child: Icon(
                        tourIcons[booking.tour.id] ?? Icons.tour,
                        size: 50,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    )
                  : null,
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
                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        '${AppStrings.date} ${DateFormat('EEE, MMM dd, yyyy').format(booking.date)}',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Guests & Cost
                  Row(
                    children: [
                      Icon(Icons.people_outline,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        '${booking.guests} guest(s)  •  ${AppFormat.price(booking.totalCost)}',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Status + Actions
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isUpcoming
                              ? AppColors.success
                              : AppColors.danger,
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
                      if (isUpcoming) ...[
                        const Spacer(),
                        // Edit button
                        TextButton.icon(
                          onPressed: () =>
                              _showEditSheet(context, booking),
                          icon: const Icon(Icons.edit_outlined,
                              size: 16, color: AppColors.primary),
                          label: const Text('Edit',
                              style: TextStyle(
                                  color: AppColors.primary, fontSize: 13)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                          ),
                        ),
                        // Cancel button
                        TextButton.icon(
                          onPressed: () =>
                              _showCancelDialog(context, booking.id),
                          icon: const Icon(Icons.cancel_outlined,
                              size: 16, color: Colors.red),
                          label: const Text('Cancel',
                              style: TextStyle(
                                  color: Colors.red, fontSize: 13)),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                          ),
                        ),
                      ],
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
