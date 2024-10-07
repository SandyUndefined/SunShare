import 'package:flutter/material.dart';
import 'package:animated_introduction/animated_introduction.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedIntroduction(
        slides: const [
          SingleIntroScreen(
            title: 'Welcome to SunShare',
            description: 'The place where you can share or rent energy!',
            imageAsset: '',
          ),
          SingleIntroScreen(
            title: 'Create Listings',
            description: 'Create listings for your unused energy sources.',
            imageAsset: '',
          ),
          SingleIntroScreen(
            title: 'Rent Energy',
            description: 'Rent energy from available sources.',
            imageAsset: '',
          ),
        ],
        onDone: () {
          Navigator.pushReplacementNamed(context, '/login');
        });
  }
}
