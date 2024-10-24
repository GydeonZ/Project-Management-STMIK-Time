import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => SignInViewModel()),
    //     ChangeNotifierProvider(create: (_) => SignUpViewModel()),
    //     ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
    //     ChangeNotifierProvider(create: (_) => CountdownViewModel()),
    //   ],
    //   child: MaterialApp(
    //     theme: ThemeData(
    //       useMaterial3: false,
    //       brightness: Brightness.light,
    //       appBarTheme: const AppBarTheme(
    //         backgroundColor: Color(0xFF293066),
    //       ),
    //     ),
    //     debugShowCheckedModeBanner: false,
    //     home: const SignIn(),
    //   ),
    // );
  }
}
