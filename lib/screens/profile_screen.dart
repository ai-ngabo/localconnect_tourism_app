import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/profile/presentation/cubit/profile_cubit.dart';
import '../utils/app_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.splash, (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.profile),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final name = state is ProfileLoaded
                ? state.profile.name
                : state is ProfileUpdateSuccess
                    ? state.profile.name
                    : '';
            final email = state is ProfileLoaded
                ? state.profile.email
                : state is ProfileUpdateSuccess
                    ? state.profile.email
                    : '';

            final initials = name
                .split(' ')
                .map((s) => s.isNotEmpty ? s[0] : '')
                .join()
                .toUpperCase();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: state is ProfileLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(initials,
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                  ),
                  const SizedBox(height: 14),
                  Text(name,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(email,
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade500)),
                  const SizedBox(height: 32),
                  _buildMenuItem(context,
                      icon: Icons.person_outline,
                      title: AppStrings.editProfile,
                      onTap: () async {
                        await Navigator.pushNamed(
                            context, AppRoutes.editProfile);
                        // Refresh profile after returning from edit screen
                        if (context.mounted) {
                          context.read<ProfileCubit>().loadProfile();
                        }
                      }),
                  _buildMenuItem(context,
                      icon: Icons.calendar_today_outlined,
                      title: AppStrings.myTours,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.bookingsList)),
                  _buildMenuItem(context,
                      icon: Icons.favorite_outline,
                      title: AppStrings.favorites,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.favorites)),
                  _buildMenuItem(context,
                      icon: Icons.settings_outlined,
                      title: AppStrings.settingsLabel,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.settings)),
                  _buildMenuItem(context,
                      icon: Icons.help_outline,
                      title: AppStrings.supportFaq,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.support)),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showLogoutDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(AppStrings.logout,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Dispatch sign-out via AuthBloc — listener above navigates to splash
              context.read<AuthBloc>().add(const SignOutRequested());
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.menuItemBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(title,
            style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
