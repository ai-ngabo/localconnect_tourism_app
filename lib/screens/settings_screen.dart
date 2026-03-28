import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/l10n/app_localizations.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import '../utils/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationServicesEnabled = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        final cubit = context.read<SettingsCubit>();

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.settings),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(l10n.preferences),
                const SizedBox(height: 16),
                _buildSwitchSetting(
                  l10n.pushNotifications,
                  l10n.pushNotificationsSubtitle,
                  _notificationsEnabled,
                  (value) => setState(() => _notificationsEnabled = value),
                  cardColor: cardColor,
                  subtitleColor: subtitleColor,
                ),
                const SizedBox(height: 12),
                _buildSwitchSetting(
                  l10n.locationServices,
                  l10n.locationServicesSubtitle,
                  _locationServicesEnabled,
                  (value) => setState(() => _locationServicesEnabled = value),
                  cardColor: cardColor,
                  subtitleColor: subtitleColor,
                ),
                const SizedBox(height: 24),
                _sectionTitle(l10n.appearance),
                const SizedBox(height: 16),
                _buildDropdownSetting(
                  l10n.language,
                  l10n.chooseLanguage,
                  cubit.localeLabel,
                  SettingsCubit.locales.keys.toList(),
                  (value) {
                    if (value != null) {
                      cubit.setLocale(SettingsCubit.locales[value]!);
                    }
                  },
                  cardColor: cardColor,
                  subtitleColor: subtitleColor,
                ),
                const SizedBox(height: 12),
                _buildDropdownSetting(
                  l10n.theme,
                  l10n.chooseTheme,
                  cubit.themeLabel,
                  SettingsCubit.themeModes.keys.toList(),
                  (value) {
                    if (value != null) {
                      cubit.setThemeMode(SettingsCubit.themeModes[value]!);
                    }
                  },
                  cardColor: cardColor,
                  subtitleColor: subtitleColor,
                ),
                const SizedBox(height: 24),
                _sectionTitle(l10n.account),
                const SizedBox(height: 16),
                _buildMenuItem(
                  Icons.privacy_tip_outlined,
                  l10n.privacyPolicy,
                  () => _showComingSoonDialog(l10n.privacyPolicy),
                  cardColor: cardColor,
                ),
                _buildMenuItem(
                  Icons.description_outlined,
                  l10n.termsOfService,
                  () => _showComingSoonDialog(l10n.termsOfService),
                  cardColor: cardColor,
                ),
                _buildMenuItem(
                  Icons.info_outline,
                  l10n.about,
                  () => _showAboutDialogCustom(),
                  cardColor: cardColor,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _showResetDialog(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: Text(
                      l10n.resetAllSettings,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    required Color cardColor,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: subtitleColor),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String subtitle,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged, {
    required Color cardColor,
    required Color subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: subtitleColor),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: value,
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: onChanged,
            underline: const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    required Color cardColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(feature),
        content: Text(l10n.featureComingSoon(feature)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showAboutDialogCustom() {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.aboutTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.aboutVersion),
            const SizedBox(height: 8),
            Text(l10n.aboutDescription),
            const SizedBox(height: 8),
            Text(l10n.aboutCopyright),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.resetSettings),
        content: Text(l10n.resetSettingsConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SettingsCubit>().resetSettings();
              setState(() {
                _notificationsEnabled = true;
                _locationServicesEnabled = true;
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.settingsReset)),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.resetAllSettings),
          ),
        ],
      ),
    );
  }
}
