import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/providers/notification_provider.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import 'profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final languageCode =
        context.watch<LanguageProvider>().languageCode;
    final isMobile = ResponsiveUtil.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.getText('settings', languageCode)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
            vertical: 16,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Section
                  _buildSectionTitle(context, 'account', languageCode),
                  _buildListTile(
                    context,
                    'profile',
                    languageCode,
                    Icons.person,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),

                  // Preferences Section
                  SizedBox(height: 24),
                  _buildSectionTitle(context, 'preferences', languageCode),

                  // Theme Toggle
                  _buildToggleTile(
                    context,
                    'dark_mode',
                    languageCode,
                    Icons.brightness_4,
                    isDark,
                    (value) {
                      context.read<ThemeProvider>().setTheme(value);
                    },
                  ),
                  _buildDivider(),

                  // Language Toggle
                  _buildLanguageTile(context, languageCode),
                  _buildDivider(),

                  // Notifications Toggle
                  _buildNotificationTile(context, languageCode),
                  _buildDivider(),

                  SizedBox(height: 24),

                  // About Section
                  _buildSectionTitle(context, 'about', languageCode),
                  _buildListTile(
                    context,
                    'privacy_policy',
                    languageCode,
                    Icons.privacy_tip,
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    'terms_conditions',
                    languageCode,
                    Icons.description,
                  ),
                  _buildDivider(),

                  SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () {
                        context.read<UserProvider>().logout();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/landing',
                          (route) => false,
                        );
                      },
                      child: Text(
                        AppStrings.getText('logout', languageCode),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
      BuildContext context, String titleKey, String languageCode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        AppStrings.getText(titleKey, languageCode).toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String titleKey,
    String languageCode,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(AppStrings.getText(titleKey, languageCode)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildToggleTile(
    BuildContext context,
    String titleKey,
    String languageCode,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(AppStrings.getText(titleKey, languageCode)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLanguageTile(
      BuildContext context, String languageCode) {
    final provider = context.read<LanguageProvider>();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(Icons.language, color: Theme.of(context).primaryColor),
      title: Text(AppStrings.getText('language', languageCode)),
      trailing: SegmentedButton<String>(
        segments: const [
          ButtonSegment(label: Text('EN'), value: 'en'),
          ButtonSegment(label: Text('RW'), value: 'rw'),
        ],
        selected: {languageCode},
        onSelectionChanged: (Set<String> newSelection) {
          if (newSelection.first == 'rw') {
            provider.changeLanguage(AppLanguage.kinyarwanda);
          } else {
            provider.changeLanguage(AppLanguage.english);
          }
        },
      ),
    );
  }

  Widget _buildNotificationTile(
      BuildContext context, String languageCode) {
    final notificationsEnabled =
        context.watch<NotificationProvider>().notificationsEnabled;
    final provider = context.read<NotificationProvider>();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading:
          Icon(Icons.notifications, color: Theme.of(context).primaryColor),
      title: Text(AppStrings.getText('notifications', languageCode)),
      trailing: Switch(
        value: notificationsEnabled,
        onChanged: (value) {
          provider.setNotifications(value);
        },
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1);
  }
}
