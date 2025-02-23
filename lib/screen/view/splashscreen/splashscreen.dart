import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/screen/view/onboarding/onboarding.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                const OnboardingScreen()), // Replace with your main screen widget
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF3853A4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/onboarding.svg",
              width: size.width * 1,
              height: size.height * 0.4,
            ),
          ],
        ),
      ),
    );
  }
}
