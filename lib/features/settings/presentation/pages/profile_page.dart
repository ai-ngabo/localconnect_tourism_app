import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userPhone = '+250 798 123 456';
  String userLocation = 'Kigali, Rwanda';
  String userBio = 'Tourism enthusiast exploring Rwanda';

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final user = context.watch<UserProvider>();
    final userName = user.name.isNotEmpty ? user.name : 'User';
    final userEmail = user.email.isNotEmpty ? user.email : 'No email';
    final userInitials = user.initials;
    final languageCode =
        context.watch<LanguageProvider>().languageCode;
    final isMobile = ResponsiveUtil.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.getText('profile', languageCode)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Avatar
                  CircleAvatar(
                    radius: isMobile ? 50 : 60,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      userInitials,
                      style: TextStyle(
                        fontSize: isMobile ? 32 : 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // User Name
                  Text(
                    userName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: isMobile ? 20 : 24,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),

                  // User Email
                  Text(
                    userEmail,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),

                  // Profile Info Card
                  _buildInfoCard(context, isMobile, isDark),
                  SizedBox(height: 24),

                  // Edit Profile Button
                  SizedBox(
                    width: isMobile ? double.infinity : 300,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              userName: userName,
                              userEmail: userEmail,
                              userPhone: userPhone,
                              userLocation: userLocation,
                              userBio: userBio,
                              onSave: (name, email, phone, location, bio) {
                                setState(() {
                                  userPhone = phone;
                                  userLocation = location;
                                  userBio = bio;
                                });
                                context.read<UserProvider>().updateProfile(
                                      name: name,
                                      email: email,
                                    );
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(
                        AppStrings.getText('edit_profile', languageCode),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, bool isMobile, bool isDark) {
    final languageCode =
        context.read<LanguageProvider>().languageCode;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(context, 'phone', userPhone, isMobile, languageCode),
            SizedBox(height: 16),
            _buildInfoRow(
                context, 'location', userLocation, isMobile, languageCode),
            SizedBox(height: 16),
            _buildInfoRow(context, 'bio', userBio, isMobile, languageCode),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String key, String value,
      bool isMobile, String languageCode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.getText(key, languageCode),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
