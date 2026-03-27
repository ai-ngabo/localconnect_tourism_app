import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../utils/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationServicesEnabled = true;
  String _selectedLanguageCode = 'en';
  String _selectedTheme = 'System';

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = AppLocalizations.localeNotifier.value.languageCode;
    _selectedTheme = _getThemeString(AppLocalizations.themeNotifier.value);
  }

  String _getThemeString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
      default:
        return 'Light'; // Default to Light instead of System
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.settingsLabel),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.preferences,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchSetting(
              tr.pushNotifications,
              tr.pushNotificationsDesc,
              _notificationsEnabled,
              (value) => setState(() => _notificationsEnabled = value),
            ),
            const SizedBox(height: 12),
            _buildSwitchSetting(
              tr.locationServices,
              tr.locationServicesDesc,
              _locationServicesEnabled,
              (value) => setState(() => _locationServicesEnabled = value),
            ),
            const SizedBox(height: 24),
            Text(
              tr.appearance,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdownSetting(
              tr.language,
              tr.chooseLanguage,
              _selectedLanguageCode,
              ['en', 'rw', 'fr'],
              (value) {
                if (value == null) return;
                setState(() {
                  _selectedLanguageCode = value;
                });
                AppLocalizations.localeNotifier.value = Locale(value);
              },
              valueBuilder: (langCode) => tr.languageName(langCode),
            ),
            const SizedBox(height: 12),
            _buildDropdownSetting(
              tr.theme,
              tr.chooseTheme,
              _selectedTheme,
              ['Light', 'Dark'],
              (value) {
                if (value == null) return;
                setState(() => _selectedTheme = value);
                if (value == 'Light') {
                  AppLocalizations.themeNotifier.value = ThemeMode.light;
                } else if (value == 'Dark') {
                  AppLocalizations.themeNotifier.value = ThemeMode.dark;
                }
              },
            ),
            const SizedBox(height: 24),
            Text(
              tr.account,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              Icons.privacy_tip_outlined,
              tr.privacyPolicy,
              () => _showComingSoonDialog(
                  tr.privacyPolicy, tr.privacyPolicyContent),
            ),
            _buildMenuItem(
              Icons.description_outlined,
              tr.termsOfService,
              () => _showComingSoonDialog(
                  tr.termsOfService, tr.termsServiceContent),
            ),
            _buildMenuItem(
              Icons.info_outline,
              tr.about,
              () => _showAboutDialog(),
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
                child: const Text(
                  'Reset All Settings',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
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
    String Function(String)? valueBuilder,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: value,
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child:
                    Text(valueBuilder != null ? valueBuilder(option) : option),
              );
            }).toList(),
            onChanged: onChanged,
            underline: const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showComingSoonDialog(String feature, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(feature),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context).ok),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    final tr = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(tr.aboutTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr.version),
            const SizedBox(height: 8),
            Text(tr.aboutDetails),
            const SizedBox(height: 8),
            Text(tr.poweredBy),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr.ok),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    final tr = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(tr.resetSettings),
        content: Text(tr.resetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notificationsEnabled = true;
                _locationServicesEnabled = true;
                _selectedLanguageCode = 'rw';
                AppLocalizations.localeNotifier.value = const Locale('rw');
                _selectedTheme = 'System';
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(tr.settingsResetConfirmation)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
