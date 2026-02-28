import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://picsum.photos/id/10/1000/1500',
              fit: BoxFit.cover,
              color: Colors.black45,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.home_outlined, color: Colors.white, size: 32),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Community Touring Rwanda',
                                  style: AppTextStyles.landingHeader,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 100),
                              const Text(
                                'Discover\nLocal Experiences',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.landingTitle,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Explore authentic community tours in Rwanda',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.landingSubtitle,
                              ),
                              const SizedBox(height: 60),
                              ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, '/register'),
                                child: const Text('Get Started'),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () => Navigator.pushNamed(context, '/login'),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide.none,
                                ),
                                child: const Text(
                                  'Log In',
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
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
