import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(SignInRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Sync legacy UserSession so existing screens still work
          UserSession.login(
            User(name: state.user.name, email: state.user.email),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          );
        } else if (state is AuthEmailNotVerified) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Please verify your email address first. '
              'We have (re)sent a verification link to ${state.email}.',
            ),
            backgroundColor: AppColors.primary,
          ));
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
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                AppStrings.logInTitle,
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppStrings.accessAccount,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    height: 1.4),
                              ),
                              const SizedBox(height: 36),
                              // Email
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: AppStrings.email,
                                  prefixIcon: Icon(Icons.email_outlined,
                                      color: Colors.grey.shade600),
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
                              const SizedBox(height: 16),
                              // Password — uses StatefulBuilder to toggle
                              // visibility without a full-screen setState
                              StatefulBuilder(
                                builder: (ctx, setLocal) => TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.password,
                                    prefixIcon: Icon(Icons.lock_outline,
                                        color: Colors.grey.shade600),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.grey.shade600,
                                      ),
                                      onPressed: () => setLocal(() =>
                                          _obscurePassword = !_obscurePassword),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return AppStrings.enterPassword;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text(AppStrings.forgotPassword),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    AppStrings.forgotPassword,
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Login button — responds to AuthBloc loading state
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final isLoading = state is AuthLoading;
                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: isLoading
                                          ? null
                                          : () => _handleLogin(context),
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
                                          : const Text(AppStrings.logInTitle),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppStrings.dontHaveAccount,
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14)),
                                  GestureDetector(
                                    onTap: () => Navigator.pushReplacementNamed(
                                        context, AppRoutes.signup),
                                    child: const Text(AppStrings.signUp,
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              Row(children: [
                                Expanded(
                                    child: Divider(color: Colors.grey.shade300)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(AppStrings.or,
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
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
                                    context
                                        .read<AuthBloc>()
                                        .add(const GoogleSignInRequested());
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
