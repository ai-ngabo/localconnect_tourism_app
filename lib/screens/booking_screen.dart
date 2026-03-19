import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../features/booking/domain/entities/booking_entity.dart';
import '../features/booking/presentation/cubit/booking_form_cubit.dart';
import '../features/booking/presentation/cubit/booking_form_state.dart';
import '../features/tourism/domain/entities/tour_entity.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _requestsController = TextEditingController();

  @override
  void dispose() {
    _requestsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    if (picked != null && context.mounted) {
      context.read<BookingFormCubit>().selectDate(picked);
    }
  }

  void _confirmBooking(BuildContext context, TourEntity tour, BookingFormInitial formState) {
    final totalCost = tour.priceRwf * formState.guests;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.primary, size: 28),
            SizedBox(width: 10),
            Text(AppStrings.bookingConfirmed),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tour: ${tour.title}'),
            const SizedBox(height: 6),
            Text(
              '${AppStrings.date} ${formState.selectedDate != null ? DateFormat('MMM dd, yyyy').format(formState.selectedDate!) : 'Not selected'}',
            ),
            const SizedBox(height: 6),
            Text('${AppStrings.guests} ${formState.guests}'),
            const SizedBox(height: 6),
            Text(
              '${AppStrings.total} ${totalCost}00 Rwf',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.home, (route) => false);
            },
            child: const Text(AppStrings.backToHome),
          ),
          BlocBuilder<BookingFormCubit, BookingFormState>(
            builder: (context, state) {
              final isSubmitting = state is BookingFormSubmitting;
              return ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        if (!UserSession.isLoggedIn) {
                          Navigator.pop(ctx);
                          Navigator.pushNamed(context, AppRoutes.login);
                          return;
                        }
                        final user = UserSession.currentUser;
                        if (user == null) return;

                        final booking = BookingEntity(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          tour: tour,
                          date: formState.selectedDate ??
                              DateTime.now().add(const Duration(days: 1)),
                          guests: formState.guests,
                          totalCost: totalCost,
                          status: 'Confirmed',
                          userEmail: user.email,
                        );

                        await context
                            .read<BookingFormCubit>()
                            .confirmBooking(booking);
                      },
                child: isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text(AppStrings.viewBookings),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tour = ModalRoute.of(context)?.settings.arguments as TourEntity?;
    // Fallback: if Tour (old model) was passed, wrap it. This keeps backward
    // compatibility while navigating from screens not yet migrated.
    if (tour == null) {
      return const Scaffold(
        body: Center(child: Text('No tour selected.')),
      );
    }

    final tourGradients = AppStyles.tourGradients;
    final tourIcons = AppStyles.tourIcons;

    return BlocListener<BookingFormCubit, BookingFormState>(
      listener: (context, state) {
        if (state is BookingFormSuccess) {
          Navigator.of(context)
            ..pop() // close dialog
            ..pushNamed(AppRoutes.bookingsList);
        } else if (state is BookingFormError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.primary,
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.bookYourTour),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<BookingFormCubit, BookingFormState>(
          builder: (context, state) {
            final formState = state is BookingFormInitial
                ? state
                : const BookingFormInitial();
            final totalCost = tour.priceRwf * formState.guests;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tour header
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: tourGradients[tour.id] ??
                                [AppColors.primaryLight, AppColors.primary],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(tourIcons[tour.id] ?? Icons.tour,
                            color: AppColors.white.withOpacity(0.7), size: 36),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tour.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${tour.duration} · ${tour.priceRwf} Rwf/person',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Date Picker
                  const Text(AppStrings.selectDate,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectDate(context),
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
                            formState.selectedDate != null
                                ? DateFormat('MMM dd, yyyy')
                                    .format(formState.selectedDate!)
                                : AppStrings.selectDate,
                            style: TextStyle(
                              fontSize: 15,
                              color: formState.selectedDate != null
                                  ? Colors.black87
                                  : Colors.grey.shade400,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_drop_down,
                              color: Colors.grey.shade500),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Guests
                  const Text(AppStrings.numberOfGuests,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  const SizedBox(height: 10),
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
                        Text('${formState.guests}',
                            style: const TextStyle(fontSize: 16)),
                        const Spacer(),
                        IconButton(
                          onPressed: formState.guests > 1
                              ? () => context
                                  .read<BookingFormCubit>()
                                  .decrementGuests()
                              : null,
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.remove, size: 18),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              context.read<BookingFormCubit>().incrementGuests(),
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
                  const SizedBox(height: 24),
                  // Total cost
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.menuItemBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(AppStrings.totalCost,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        Text('${totalCost}00 Rwf',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Special Requests',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _requestsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Any special requests or notes...',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          _confirmBooking(context, tour, formState),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Confirm Booking',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
