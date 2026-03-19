import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../utils/app_constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(SignUpRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'A verification link has been sent to ${state.email}. '
              'Please verify your email before logging in.',
            ),
            backgroundColor: AppColors.primary,
          ));
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.login, (route) => false);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.primary,
          ));
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(AppStrings.signUp,
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                              const SizedBox(height: 8),
                              Text(AppStrings.createAccount,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      height: 1.4)),
                              const SizedBox(height: 28),
                              // Full Name
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: AppStrings.fullName,
                                  prefixIcon: Icon(Icons.person_outline,
                                      color: Colors.grey.shade500),
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? AppStrings.enterYourName
                                    : null,
                              ),
                              const SizedBox(height: 14),
                              // Email
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: AppStrings.email,
                                  prefixIcon: Icon(Icons.email_outlined,
                                      color: Colors.grey.shade500),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return AppStrings.enterYourEmail;
                                  }
                                  if (!v.contains('@')) {
                                    return AppStrings.enterValidEmail;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              // Password
                              StatefulBuilder(
                                builder: (ctx, setLocal) => TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.password,
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: Colors.grey.shade500),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.grey.shade500,
                                      ),
                                      onPressed: () => setLocal(() =>
                                          _obscurePassword = !_obscurePassword),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return AppStrings.enterPassword;
                                    }
                                    if (v.length < 6) {
                                      return AppStrings.passwordMin6;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 14),
                              // Confirm Password
                              StatefulBuilder(
                                builder: (ctx, setLocal) => TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.confirmPassword,
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: Colors.grey.shade500),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.grey.shade500,
                                      ),
                                      onPressed: () => setLocal(() =>
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword),
                                    ),
                                  ),
                                  validator: (v) =>
                                      v != _passwordController.text
                                          ? AppStrings.passwordsMismatch
                                          : null,
                                ),
                              ),
                              const SizedBox(height: 28),
                              // Sign Up button — responds to AuthBloc loading state
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final isLoading = state is AuthLoading;
                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: isLoading
                                          ? null
                                          : () => _handleSignup(context),
                                      child: isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.white),
                                              ),
                                            )
                                          : const Text(AppStrings.signUp),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppStrings.alreadyHaveAccount,
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14)),
                                  GestureDetector(
                                    onTap: () => Navigator.pushReplacementNamed(
                                        context, AppRoutes.login),
                                    child: const Text(AppStrings.logIn,
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(children: [
                                Expanded(
                                    child: Divider(color: Colors.grey.shade300)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(AppStrings.or,
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 14)),
                                ),
                                Expanded(
                                    child: Divider(color: Colors.grey.shade300)),
                              ]),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            AppStrings.googleSignInComingSoon),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    );
                                  },
                                  icon: const Text(AppStrings.googleLetter,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                  label: const Text(AppStrings.googleContinue,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500)),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    side: BorderSide(
                                        color: Colors.grey.shade300),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
