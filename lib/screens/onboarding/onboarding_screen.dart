import 'package:flutter/material.dart';

import '../../app/theme/extensions.dart';
import '../../data/command/app/app_command.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    AppCommand().completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildPage(
                    title: 'Welcome to ABCD',
                    description:
                        'Ship apps in days, not weeks. Fully scalable architecture out of the box.',
                    icon: Icons.rocket_launch_rounded,
                  ),
                  _buildPage(
                    title: 'Pluggable Backends',
                    description:
                        'Switch between Firebase, Supabase, HTTP, or Mock APIs with a single line of code.',
                    icon: Icons.api_rounded,
                  ),
                  _buildPage(
                    title: 'Monetization Ready',
                    description:
                        'Built-in support for Ads and In-App Purchases to start earning immediately.',
                    icon: Icons.monetization_on_rounded,
                  ),
                ],
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 120, color: context.colorScheme.primary),
          const SizedBox(height: 48),
          Text(
            title,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: _finishOnboarding, child: const Text('Skip')),
          Row(
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? context.colorScheme.primary
                      : context.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              if (_currentPage == 2) {
                _finishOnboarding();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(_currentPage == 2 ? 'Get Started' : 'Next'),
          ),
        ],
      ),
    );
  }
}
