import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/screen/view/signin_signup/signscreen.dart';
import 'package:projectmanagementstmiktime/screen/view/signin_signup/signupscreen.dart';
import 'package:projectmanagementstmiktime/screen/widget/button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF3853A4),
      body: Padding(
        padding: EdgeInsetsDirectional.only(
            top: size.height * 0.06, bottom: size.height * 0.06),
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/logostmik.svg"),
              SizedBox(
                height: size.height * 0.02,
              ),
              SvgPicture.asset(
                "assets/board.svg",
                width: size.width * 1,
                height: size.height * 0.4,
              ),
              const Text(
                "Kerja team lebih cepat",
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              const Text(
                "Buat dan kelola rencana Anda \ndengan sederhana",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              customButton(
                labelText: "Masuk",
                height: size.height * 0.065,
                width: size.width * 0.75,
                bgColor: const Color(0xFFE5E5E5),
                fntColor: const Color(0xFF3853A4),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
                text: "Masuk",
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              customButton(
                labelText: "Daftar",
                height: size.height * 0.065,
                width: size.width * 0.75,
                bgColor: const Color(0xFF3853A4),
                fntColor: const Color(0xFFFFFFFF),
                brdrColor: const Color(0xFFFFFFFF),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                text: "Daftar Sekarang",
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "dikelola oleh",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.01,
                  ),
                  const Text(
                    "STMIK TIME",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
