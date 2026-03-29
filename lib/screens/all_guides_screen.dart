import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/guide_appointment/domain/entities/guide_appointment_entity.dart';
import '../features/guide_appointment/presentation/cubit/guide_appointment_cubit.dart';
import '../models/tour_model.dart'; // guides are also in this file
import '../models/user_model.dart';
import '../utils/app_constants.dart';

class AllGuidesScreen extends StatefulWidget {
  const AllGuidesScreen({super.key});

  @override
  State<AllGuidesScreen> createState() => _AllGuidesScreenState();
}

class _AllGuidesScreenState extends State<AllGuidesScreen> {
  void _showGuideBookingSheet(Guide guide) {
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
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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
              // Guide info
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor:
                        AppStyles.guideColors[guide.id] ?? Colors.brown,
                    child: AppStyles.guideImages[guide.id] != null
                        ? ClipOval(
                            child: Image.asset(
                              AppStyles.guideImages[guide.id]!,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.person,
                            color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book ${guide.name}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          guide.specialty,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Date picker
              const Text('Select Date',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: selectedDate != null
                            ? AppColors.primary
                            : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 18,
                          color: selectedDate != null
                              ? AppColors.primary
                              : Colors.grey.shade600),
                      const SizedBox(width: 10),
                      Text(
                        selectedDate != null
                            ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                            : 'Choose a date',
                        style: TextStyle(
                          fontSize: 14,
                          color: selectedDate != null
                              ? Colors.black87
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Time slots
              const Text('Select Time Slot',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
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
                            ? AppColors.primary
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        slot,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
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
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            guideName: guide.name,
                            guideSpecialty: guide.specialty,
                            guideId: guide.id,
                            date: selectedDate!,
                            timeSlot: selectedSlot!,
                            status: 'Confirmed',
                            userEmail: UserSession.currentUser?.email,
                            createdAt: DateTime.now(),
                          );
                          context
                              .read<GuideAppointmentCubit>()
                              .addAppointment(appointment);
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

  @override
  Widget build(BuildContext context) {
    final guideColors = AppStyles.guideColors;
    final guideIcons = AppStyles.guideIcons;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.localGuides),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: Guide.sampleGuides.length,
        itemBuilder: (context, index) {
          final guide = Guide.sampleGuides[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: guideColors[guide.id] ?? AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AppStyles.guideImages[guide.id] != null
                          ? Image.asset(
                              AppStyles.guideImages[guide.id]!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              guideIcons[guide.id] ?? Icons.person,
                              color: AppColors.white,
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Name + specialty
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guide.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          guide.specialty,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  // Book button
                  ElevatedButton(
                    onPressed: () => _showGuideBookingSheet(guide),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Book',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
