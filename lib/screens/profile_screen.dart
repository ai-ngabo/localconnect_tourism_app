import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Profile avatar
            CircleAvatar(
              radius: 50,
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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Name
            Text(
              UserSession.currentUser?.name ?? '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              UserSession.currentUser?.email ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 32),
            // Menu items
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              title: AppStrings.editProfile,
              onTap: () async {
                final result =
                    await Navigator.pushNamed(context, AppRoutes.editProfile);
                if (result == true) {
                  setState(() {});
                }
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.calendar_today_outlined,
              title: AppStrings.myTours,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.bookingsList);
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.favorite_outline,
              title: AppStrings.favorites,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.favorites);
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings_outlined,
              title: AppStrings.settingsLabel,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              title: AppStrings.supportFaq,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.support);
              },
            ),
            const SizedBox(height: 32),
            // Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
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
                            UserSession.logout();
                            Navigator.pushNamedAndRemoveUntil(
                                context, AppRoutes.splash, (route) => false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                          ),
                          child: const Text(AppStrings.logout),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  AppStrings.logout,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
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
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey.shade400,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
