import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/utils/responsive.dart';

class EditProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhone;
  final String userLocation;
  final String userBio;
  final Function(String, String, String, String, String) onSave;

  const EditProfilePage({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.userLocation,
    required this.userBio,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userName);
    emailController = TextEditingController(text: widget.userEmail);
    phoneController = TextEditingController(text: widget.userPhone);
    locationController = TextEditingController(text: widget.userLocation);
    bioController = TextEditingController(text: widget.userBio);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode =
        context.watch<LanguageProvider>().languageCode;
    final isMobile = ResponsiveUtil.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.getText('edit_profile', languageCode)),
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
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    context,
                    nameController,
                    'name',
                    languageCode,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    context,
                    emailController,
                    'email',
                    languageCode,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    context,
                    phoneController,
                    'phone',
                    languageCode,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    context,
                    locationController,
                    'location',
                    languageCode,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    context,
                    bioController,
                    'bio',
                    languageCode,
                    maxLines: 3,
                  ),
                  SizedBox(height: 32),
                  _buildButtonRow(context, languageCode, isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String labelKey,
    String languageCode, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.getText(labelKey, languageCode),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: AppStrings.getText(labelKey, languageCode),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonRow(
      BuildContext context, String languageCode, bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.getText('cancel', languageCode)),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              widget.onSave(
                nameController.text,
                emailController.text,
                phoneController.text,
                locationController.text,
                bioController.text,
              );
            },
            child: Text(AppStrings.getText('save', languageCode)),
          ),
        ),
      ],
    );
  }
}
