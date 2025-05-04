import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/screen/view/splashscreen/splashscreen.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_addboard.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_anggota_list_board.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_board.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_anggota_list.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_comment.dart';
import 'package:projectmanagementstmiktime/view_model/forgot_password/view_model_reset_password.dart';
import 'package:projectmanagementstmiktime/view_model/forgot_password/view_model_forgot_password.dart';
import 'package:projectmanagementstmiktime/view_model/navigation/view_model_navigation.dart';
import 'package:projectmanagementstmiktime/view_model/profile/view_model_ganti_password.dart';
import 'package:projectmanagementstmiktime/view_model/profile/view_model_profile.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signup.dart';
import 'package:provider/provider.dart';

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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SignInViewModel()),
          ChangeNotifierProvider(create: (_) => SignUpViewModel()),
          ChangeNotifierProvider(create: (_) => BoardViewModel()),
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(create: (_) => AddBoardViewModel()),
          ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
          ChangeNotifierProvider(create: (_) => ResetPasswordViewModel()),
          ChangeNotifierProvider(create: (_) => ProfileViewModel()),
          ChangeNotifierProvider(create: (_) => GantiPasswordViewModel()),
          ChangeNotifierProvider(create: (_) => CardTugasViewModel()),
          ChangeNotifierProvider(create: (_) => AnggotaListViewModel()),
          ChangeNotifierProvider(create: (_) => CommentViewModel()),
          ChangeNotifierProvider(create: (_) => BoardAnggotaListViewModel()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
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
