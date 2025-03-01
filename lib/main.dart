import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/screen/view/splashscreen/splashscreen.dart';
import 'package:projectmanagementstmiktime/screen/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:projectmanagementstmiktime/screen/view_model/sign_in_sign_up/view_model_signup.dart';
import 'package:provider/provider.dart';
// import 'package:projectmanagementstmiktime/screen/view/splashscreen/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SignInViewModel()),
          ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: false,
            brightness: Brightness.light,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF293066),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ));
  }
}
