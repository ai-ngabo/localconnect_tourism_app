import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/profile/presentation/cubit/profile_cubit.dart';
import '../utils/app_constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    final profile = state is ProfileLoaded ? state.profile : null;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ProfileCubit>().updateProfile(
          name: _nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.profileUpdated),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.editProfile),
          centerTitle: true,
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final isUpdating = state is ProfileUpdating;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(hintText: AppStrings.name),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? AppStrings.enterYourName
                              : null,
                    ),
                    const SizedBox(height: 16),
                    // Email is read-only — Firebase Auth requires special flow to change it
                    TextFormField(
                      controller: _emailController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: AppStrings.email,
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        suffixIcon: const Tooltip(
                          message: 'Email cannot be changed here',
                          child: Icon(Icons.lock_outline, size: 18),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isUpdating ? null : () => _save(context),
                        child: isUpdating
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.white),
                                ),
                              )
                            : const Text(AppStrings.save),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
