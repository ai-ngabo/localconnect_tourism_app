import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../features/booking/presentation/cubit/bookings_list_cubit.dart';
import '../features/guide_appointment/domain/entities/guide_appointment_entity.dart';
import '../features/guide_appointment/presentation/cubit/guide_appointment_cubit.dart';
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
    context.read<GuideAppointmentCubit>().watchAppointments(email);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openNotifications() {
    // Track dismissed IDs locally so items vanish instantly on swipe,
    // without waiting for the Firestore stream to update.
    final dismissed = <String>{};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          maxChildSize: 0.85,
          minChildSize: 0.3,
          builder: (_, scrollController) {
            return StatefulBuilder(
              builder: (stfCtx, setSheet) {
                return BlocBuilder<BookingsListCubit, BookingsListState>(
                  builder: (context, bookingsState) {
                    return BlocBuilder<GuideAppointmentCubit,
                        GuideAppointmentState>(
                      builder: (context, guideState) {
                        final tourBookings =
                            bookingsState is BookingsListLoaded
                                ? List.of(bookingsState.bookings)
                                : <dynamic>[];
                        final guideAppointments =
                            guideState is GuideAppointmentLoaded
                                ? List.of(guideState.appointments)
                                : <GuideAppointmentEntity>[];

                        // Build unified notification list
                        final List<_NotifItem> allItems = [];

                        for (final b in tourBookings) {
                          final key = 'tour_${b.id}';
                          if (dismissed.contains(key)) continue;
                          allItems.add(_NotifItem(
                            id: b.id,
                            type: _NotifType.tour,
                            title: b.tour.title,
                            date: b.date,
                            status: b.status,
                            detail: '${b.guests} guest(s)',
                          ));
                        }
                        for (final a in guideAppointments) {
                          final key = 'guide_${a.id}';
                          if (dismissed.contains(key)) continue;
                          allItems.add(_NotifItem(
                            id: a.id,
                            type: _NotifType.guide,
                            title: 'Guide: ${a.guideName}',
                            date: a.date,
                            status: a.status,
                            detail: a.timeSlot,
                          ));
                        }

                        // Sort newest first
                        allItems.sort((a, b) => b.date.compareTo(a.date));

                        final totalCount = allItems.length;

                        // Reminders: confirmed items within 7 days
                        final reminders = allItems
                            .where((n) =>
                                n.status == 'Confirmed' &&
                                n.date
                                        .difference(DateTime.now())
                                        .inDays <=
                                    7 &&
                                !n.date.isBefore(DateTime.now()))
                            .toList();

                        void onDelete(_NotifItem item) {
                          final key = '${item.type.name}_${item.id}';
                          dismissed.add(key);
                          setSheet(() {}); // rebuild immediately
                          // Fire Firestore delete in background
                          if (item.type == _NotifType.tour) {
                            this
                                .context
                                .read<BookingsListCubit>()
                                .deleteBooking(item.id);
                          } else {
                            this
                                .context
                                .read<GuideAppointmentCubit>()
                                .deleteAppointment(item.id);
                          }
                        }

                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              const SizedBox(height: 8),
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
                                  const Icon(Icons.notifications,
                                      color: AppColors.primary, size: 24),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text('Notifications',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Text('$totalCount',
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Upcoming reminders
                              if (reminders.isNotEmpty) ...[
                                _notifSectionHeader(Icons.alarm,
                                    'Upcoming Reminders', Colors.orange),
                                const SizedBox(height: 8),
                                ...reminders.map((n) {
                                  final daysLeft = n.date
                                      .difference(DateTime.now())
                                      .inDays;
                                  return _notifCard(
                                    item: n,
                                    iconOverride: Icons.event_available,
                                    colorOverride: Colors.orange,
                                    trailingText: daysLeft == 0
                                        ? 'Today'
                                        : daysLeft == 1
                                            ? 'Tomorrow'
                                            : 'In $daysLeft days',
                                    trailingColor: daysLeft <= 1
                                        ? Colors.red
                                        : Colors.orange,
                                    onDismissed: () => onDelete(n),
                                  );
                                }),
                                const SizedBox(height: 16),
                              ],

                              // All notifications
                              if (allItems.isNotEmpty) ...[
                                _notifSectionHeader(
                                    Icons.calendar_month,
                                    'All Notifications',
                                    AppColors.primary),
                                const SizedBox(height: 8),
                                ...allItems.map((n) {
                                  final isCancelled =
                                      n.status == 'Cancelled';
                                  final isCompleted =
                                      n.status == 'Completed';
                                  final color = isCancelled
                                      ? Colors.red
                                      : isCompleted
                                          ? Colors.grey
                                          : n.type == _NotifType.guide
                                              ? Colors.deepPurple
                                              : AppColors.primary;
                                  final icon = isCancelled
                                      ? Icons.cancel_outlined
                                      : isCompleted
                                          ? Icons.history
                                          : n.type == _NotifType.guide
                                              ? Icons.person_pin
                                              : Icons.check_circle_outline;
                                  return _notifCard(
                                    item: n,
                                    iconOverride: icon,
                                    colorOverride: color,
                                    trailingText: n.status,
                                    trailingColor: color,
                                    onDismissed: () => onDelete(n),
                                  );
                                }),
                              ] else ...[
                                const SizedBox(height: 40),
                                Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.inbox_outlined,
                                          size: 48,
                                          color: Colors.grey.shade300),
                                      const SizedBox(height: 12),
                                      Text(
                                        'No notifications yet.\nBook a tour or guide to get started!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _notifSectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(title,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }

  Widget _notifCard({
    required _NotifItem item,
    required IconData iconOverride,
    required Color colorOverride,
    required String trailingText,
    required Color trailingColor,
    required VoidCallback onDismissed,
  }) {
    return Dismissible(
      key: ValueKey('${item.type.name}_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      confirmDismiss: (_) async {
        onDismissed();
        return true;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorOverride.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconOverride, color: colorOverride, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('EEE, MMM dd, yyyy').format(item.date),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(item.detail,
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: trailingColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(trailingText,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: trailingColor)),
            ),
          ],
        ),
      ),
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
              label: 'Community',
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
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
                    TextStyle(color: Colors.grey.shade600, fontSize: 14),
                prefixIcon:
                    Icon(Icons.search, color: Colors.grey.shade600, size: 22),
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
            _sectionHeader(
              AppStrings.popularTours,
              onTap: () => Navigator.pushNamed(context, AppRoutes.allTours),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 195,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.searchFilteredTours.length,
                itemBuilder: (context, index) =>
                    _buildTourCard(state.searchFilteredTours[index]),
              ),
            ),
            const SizedBox(height: 28),
            _sectionHeader(
              AppStrings.localGuides,
              onTap: () => Navigator.pushNamed(context, AppRoutes.allGuides),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 178,
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
    ),
      ),
    );
  }

  // ── Section header with styled "See all" button ───────────────────────────
  Widget _sectionHeader(String title, {required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('See all',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios,
                    size: 11, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Guide appointment booking sheet ──────────────────────────────────────
  void _showGuideBookingSheet(GuideEntity guide) {
    DateTime? selectedDate;
    String? selectedSlot;
    final slots = ['Morning (8–12)', 'Afternoon (12–17)', 'Evening (17–20)'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Guide info
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppStyles.guideColors[guide.id] ?? Colors.brown,
                    child: AppStyles.guideImages[guide.id] != null
                        ? ClipOval(
                            child: Image.asset(AppStyles.guideImages[guide.id]!,
                                width: 52, height: 52, fit: BoxFit.cover))
                        : const Icon(Icons.person, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Book ${guide.name}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(guide.specialty,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text('${guide.rating}',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Date picker
              const Text('Select Date',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primary,
                          onPrimary: Colors.white,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) setSheet(() => selectedDate = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: selectedDate != null
                        ? AppColors.primary : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 18,
                          color: selectedDate != null
                              ? AppColors.primary : Colors.grey.shade600),
                      const SizedBox(width: 10),
                      Text(
                        selectedDate != null
                            ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                            : 'Choose a date',
                        style: TextStyle(
                          fontSize: 14,
                          color: selectedDate != null
                              ? Colors.black87 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Time slots
              const Text('Select Time Slot',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: slots.map((slot) {
                  final isSelected = selectedSlot == slot;
                  return GestureDetector(
                    onTap: () => setSheet(() => selectedSlot = slot),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(slot,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black87,
                          )),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (selectedDate != null && selectedSlot != null)
                      ? () {
                          final appointment = GuideAppointmentEntity(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            guideName: guide.name,
                            guideSpecialty: guide.specialty,
                            guideId: guide.id,
                            date: selectedDate!,
                            timeSlot: selectedSlot!,
                            status: 'Confirmed',
                            userEmail: UserSession.currentUser?.email,
                            createdAt: DateTime.now(),
                          );
                          context.read<GuideAppointmentCubit>().addAppointment(appointment);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Appointment booked with ${guide.name} on ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} · $selectedSlot'),
                              backgroundColor: AppColors.primary,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Confirm Appointment',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
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
              Hero(
                tag: 'tour_image_${tour.id}',
                child: Container(
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
                        Text(AppFormat.price(tour.priceRwf),
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
    return GestureDetector(
      onTap: () => _showGuideBookingSheet(guide),
      child: Container(
        width: 120,
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
            const SizedBox(height: 14),
            CircleAvatar(
              radius: 34,
              backgroundColor: AppStyles.guideColors[guide.id] ?? Colors.brown,
              child: AppStyles.guideImages[guide.id] != null
                  ? ClipOval(
                      child: Image.asset(
                        AppStyles.guideImages[guide.id]!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(AppStyles.guideIcons[guide.id] ?? Icons.person,
                      size: 28, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(guide.name,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(guide.specialty,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Book',
                  style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreContent(TourismLoaded state) {
    final selectedCategory = state.selectedCategory;
    final screenWidth = MediaQuery.of(context).size.width;
    final hPad = (screenWidth * 0.05).clamp(12.0, 24.0);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.explore,
                style: TextStyle(
                  fontSize: (screenWidth * 0.06).clamp(18.0, 26.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: (screenWidth * 0.045).clamp(14.0, 20.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('All', Icons.apps,
                        selectedCategory == null, const Color(0xFF455A64)),
                    const SizedBox(width: 10),
                    _buildCategoryChip('Cultural', Icons.account_balance,
                        selectedCategory == 'Cultural',
                        const Color(0xFF7B61FF)),
                    const SizedBox(width: 10),
                    _buildCategoryChip('Nature', Icons.forest,
                        selectedCategory == 'Nature', const Color(0xFF2E7D32)),
                    const SizedBox(width: 10),
                    _buildCategoryChip('Adventure', Icons.hiking,
                        selectedCategory == 'Adventure',
                        const Color(0xFFE65100)),
                    const SizedBox(width: 10),
                    _buildCategoryChip('Food', Icons.restaurant_menu,
                        selectedCategory == 'Food', const Color(0xFFD32F2F)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                selectedCategory != null
                    ? '$selectedCategory Tours'
                    : 'All Tours',
                style: TextStyle(
                  fontSize: (screenWidth * 0.045).clamp(14.0, 20.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (state.filteredTours.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off,
                            size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'No tours found in this category',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...state.filteredTours.map(_buildExploreTourItem),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
      String label, IconData icon, bool selected, Color color) {
    final chipPad = (MediaQuery.of(context).size.width * 0.03).clamp(10.0, 16.0);
    final iconSize = (MediaQuery.of(context).size.width * 0.065).clamp(20.0, 28.0);
    return GestureDetector(
      onTap: () => context
          .read<TourismCubit>()
          .filterByCategory(label == 'All' ? null : label),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(chipPad),
            decoration: BoxDecoration(
              color: selected ? color : color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? color : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(icon,
                color: selected ? Colors.white : color, size: iconSize),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? color : Colors.grey.shade600,
              fontWeight:
                  selected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
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
            Hero(
              tag: 'tour_image_${tour.id}',
              child: Container(
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
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tour.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${tour.duration} · ${tour.category}',
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      Flexible(
                        child: Text(' ${tour.rating}',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(AppFormat.price(tour.priceRwf),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary),
                            overflow: TextOverflow.ellipsis),
                      ),
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

// ── Notification helpers ──────────────────────────────────────────────────

enum _NotifType { tour, guide }

class _NotifItem {
  final String id;
  final _NotifType type;
  final String title;
  final DateTime date;
  final String status;
  final String detail;

  const _NotifItem({
    required this.id,
    required this.type,
    required this.title,
    required this.date,
    required this.status,
    required this.detail,
  });
}
