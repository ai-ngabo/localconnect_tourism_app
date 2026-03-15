import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    context.read<UserProvider>().login(name: name, email: email);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image covering whole screen
          Positioned.fill(
            child: Image.network(
              'https://picsum.photos/id/10/1000/1500',
              fit: BoxFit.cover,
              color: Colors.black26,
              colorBlendMode: BlendMode.darken,
              errorBuilder: (context, error, stackTrace) => Container(color: AppColors.primary),
            ),
          ),
          
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Back Button Row
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                          
                          // Centered Form
                          Expanded(
                            child: Center(
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Sign Up',
                                      style: AppTextStyles.cardTitle,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Create an account to\nexplore local experiences',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.cardSubtitle,
                                    ),
                                    const SizedBox(height: 32),
                                    TextField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        hintText: 'Full Name',
                                        prefixIcon: Icon(Icons.person_outline),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                        prefixIcon: Icon(Icons.email_outlined),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        prefixIcon: Icon(Icons.lock_outline),
                                        suffixIcon: Icon(Icons.more_horiz),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: _confirmPasswordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: 'Confirm Password',
                                        prefixIcon: Icon(Icons.lock_outline),
                                        suffixIcon: Icon(Icons.more_horiz),
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    ElevatedButton(
                                      onPressed: _handleSignUp,
                                      child: const Text('Sign Up'),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text("Already have an account? "),
                                        GestureDetector(
                                          onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                                          child: const Text(
                                            'Log In',
                                            style: AppTextStyles.linkText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.g_mobiledata, size: 30),
                                      label: const Text('Continue with Google'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Extra space at bottom to match back button row
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
