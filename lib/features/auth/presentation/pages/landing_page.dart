import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1542332213-9b5a5a3fab35?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_outlined, color: Colors.white, size: 32),
                      SizedBox(width: 8),
                      Text(
                        'Community Touring Rwanda',
                        style: AppTextStyles.landingHeader,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Discover\nLocal Experiences',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.landingTitle,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Explore Authentic Community Tours in Rwanda',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.landingSubtitle,
                  ),
                  const SizedBox(height: 48),
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
            ),
          ),
        ],
      ),
    );
  }
}
