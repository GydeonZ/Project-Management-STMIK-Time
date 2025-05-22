import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:projectmanagementstmiktime/firebase_options.dart';
import 'package:projectmanagementstmiktime/screen/view/splashscreen/splashscreen.dart';
import 'package:projectmanagementstmiktime/services/service_notification.dart';
import 'package:projectmanagementstmiktime/view_model/notification/view_model_notification.dart';
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
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Awesome Notifications
  await AwesomeNotifications().initialize(
      null, // Replace with app icon path if desired
      [
        NotificationChannel(
            channelKey: 'high_importance_channel',
            channelName: 'High Importance Notifications',
            channelDescription: 'Channel for important notifications',
            defaultColor: const Color(0xFF484F88),
            ledColor: const Color(0xFF484F88),
            importance: NotificationImportance.High,
            vibrationPattern: highVibrationPattern,
            defaultRingtoneType: DefaultRingtoneType.Notification),
      ],
      debug: true);

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initNotifications();

  // Request notification permissions
  if (await Permission.notification.request().isGranted) {
    await notificationService.getToken();
  }

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

// Create a static method to be the handler for notification actions
@pragma('vm:entry-point')
 Future<void> onNotificationAction(ReceivedAction receivedAction) async {
  // Add your notification handling logic here
  print('Notification action received: ${receivedAction.payload}');
  // You can navigate to specific screens based on notification data
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Initialize NotificationHandler
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onNotificationAction,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          ChangeNotifierProvider(create: (_) => NotificationViewModel()),
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
