import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SignInViewModel autoLogin;
  @override
  void initState() {
    autoLogin = Provider.of<SignInViewModel>(context, listen: false);
    super.initState();
    autoLogin.checkLogin(context);
  }

  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
