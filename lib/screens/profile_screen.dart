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
        backgroundColor: Colors.grey.shade50,
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final profile = state is ProfileLoaded
                ? state.profile
                : state is ProfileUpdateSuccess
                    ? state.profile
                    : null;

            final name = profile?.name ?? '';
            final email = profile?.email ?? '';
            final phone = profile?.phone ?? '';
            final bio = profile?.bio ?? '';
            final photoUrl = profile?.photoUrl ?? '';

            final initials = name
                .split(' ')
                .map((s) => s.isNotEmpty ? s[0] : '')
                .join()
                .toUpperCase();

            return CustomScrollView(
              slivers: [
                // ── Header ─────────────────────────────────────
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          // App bar row
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                const Expanded(
                                  child: Text(
                                    AppStrings.profile,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 48),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Avatar
                          if (state is ProfileLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            )
                          else ...[
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withValues(alpha:0.4),
                                    width: 3),
                              ),
                              child: CircleAvatar(
                                radius: 48,
                                backgroundColor:
                                    Colors.white.withValues(alpha:0.2),
                                backgroundImage: photoUrl.isNotEmpty
                                    ? NetworkImage(photoUrl)
                                    : null,
                                child: photoUrl.isEmpty
                                    ? Text(initials,
                                        style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(name,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 4),
                            Text(email,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha:0.8))),
                          ],
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Contact / Bio Info Cards ────────────────────
                if (phone.isNotEmpty || bio.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha:0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            if (phone.isNotEmpty)
                              _infoTile(
                                icon: Icons.phone_outlined,
                                label: 'Phone',
                                value: phone,
                                showDivider: bio.isNotEmpty,
                              ),
                            if (bio.isNotEmpty)
                              _infoTile(
                                icon: Icons.info_outline,
                                label: 'About',
                                value: bio,
                                showDivider: false,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ── Menu Items ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _menuItem(
                            icon: Icons.person_outline,
                            title: AppStrings.editProfile,
                            onTap: () async {
                              await Navigator.pushNamed(
                                  context, AppRoutes.editProfile);
                              if (context.mounted) {
                                context.read<ProfileCubit>().loadProfile();
                              }
                            },
                            showDivider: true,
                          ),
                          _menuItem(
                            icon: Icons.calendar_today_outlined,
                            title: AppStrings.myTours,
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.bookingsList),
                            showDivider: true,
                          ),
                          _menuItem(
                            icon: Icons.favorite_outline,
                            title: AppStrings.favorites,
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.favorites),
                            showDivider: true,
                          ),
                          _menuItem(
                            icon: Icons.settings_outlined,
                            title: AppStrings.settingsLabel,
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.settings),
                            showDivider: true,
                          ),
                          _menuItem(
                            icon: Icons.help_outline,
                            title: AppStrings.supportFaq,
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.support),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Logout Button ────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () => _showLogoutDialog(context),
                        icon:
                            Icon(Icons.logout, color: Colors.red.shade600, size: 20),
                        label: Text(
                          AppStrings.logout,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.shade200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.menuItemBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 2),
                    Text(value,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
              height: 1,
              indent: 58,
              color: Colors.grey.shade200),
      ],
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: showDivider
              ? null
              : const BorderRadius.vertical(bottom: Radius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.menuItemBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500)),
                ),
                Icon(Icons.chevron_right,
                    color: Colors.grey.shade400, size: 22),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
              height: 1,
              indent: 58,
              color: Colors.grey.shade200),
      ],
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
}
