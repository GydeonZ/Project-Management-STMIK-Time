// ignore_for_file: use_build_context_synchronously


import 'dart:io';

import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/model/model_sign_in.dart';
import 'package:projectmanagementstmiktime/screen/view/navigation/navigation_screen.dart';
import 'package:projectmanagementstmiktime/screen/view/onboarding/onboarding.dart';
import 'package:projectmanagementstmiktime/services/service_send_fcm.dart';
import 'package:projectmanagementstmiktime/services/services_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInViewModel with ChangeNotifier {
  late GlobalKey<FormState> formKeySignin;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool showErrorMessage = false;
  bool isSukses = false;
  final service = SignInService();
  final serviceFCM = SendFCMTokenService();
  bool rememberMe = false;
  bool heightContainer = false;
  ModelSignIn? dataLogin;
  late SharedPreferences logindata;
  late bool newUser;
  int idSharedPreference = 0;
  String nameSharedPreference = '';
  String emailSharedPreference = '';
  String roleSharedPreference = '';
  String nimSharedPreference = '';
  String nidnSharedPreference = '';
  String tokenSharedPreference = '';
  String fcm = "";
  String? errorMessages;
  bool isPasswordVisible = false;
  bool isSudahLogin = false;
  bool isSuksesLogin = false;
  bool isLoading = false;

  SignInViewModel() {
    checkSharedPreferences();
  }

  void updateUserName(String newName) async {
    nameSharedPreference = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', newName);
    notifyListeners(); // Memberitahu UI untuk memperbarui tampilan
  }

  Future<int> signIn() async {
    try {
      isLoading = true;
      notifyListeners();

      dataLogin = await service.signInAccount(
        email: email.text,
        password: password.text,
      );

      isLoading = false;

      if (dataLogin != null) {
        // ✅ Simpan data ke SharedPreferences
        idSharedPreference = dataLogin!.user.id;
        nameSharedPreference = dataLogin!.user.name;
        emailSharedPreference = dataLogin!.user.email;
        roleSharedPreference = dataLogin!.user.role;
        nimSharedPreference = dataLogin!.user.nim ?? "";
        nidnSharedPreference = dataLogin!.user.nidn ?? "";
        tokenSharedPreference = dataLogin!.token;
        isSuksesLogin = true;

        await saveDataSharedPreferences();

        isLoading = false;
        notifyListeners();
        return 200; // ✅ Sukses login
      } else {
        isSuksesLogin = false;
        isLoading = false;
        notifyListeners();
        return 400; // ❌ Gagal login
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();

      // ✅ Tangani error berdasarkan pesan exception
      if (e.toString().contains("401")) {
        print("❌ Password salah");
        return 401;
      } else if (e.toString().contains("403")) {
        print("❌ Email belum diverifikasi");
        return 403;
      } else {
        print("⚠️ Error tidak terduga: $e");
        return 500; // ❌ Kesalahan server atau lainnya
      }
    }
  }

  Future<String?> getTokenFcm() async {
    String? token = await FirebaseMessaging.instance.getToken(
        vapidKey:
            'BNKkaUWxyP_yC_lki1kYazgca0TNhuzt2drsOrL6WrgGbqnMnr8ZMLzg_rSPDm6HKphABS0KzjPfSqCXHXEd06Y');
    fcm = token!;
    return token;
  }

  /// Mendapatkan tipe perangkat (platform) yang digunakan
  Future<String> getDeviceType() async {
    try {
      String deviceType = 'unknown';

      // Deteksi platform menggunakan dart:io
      if (Platform.isAndroid) {
        deviceType = 'android';
      } else if (Platform.isIOS) {
        deviceType = 'ios';
      } else if (Platform.isWindows) {
        deviceType = 'windows';
      } else if (Platform.isMacOS) {
        deviceType = 'macos';
      } else if (Platform.isLinux) {
        deviceType = 'linux';
      } else if (Platform.isFuchsia) {
        deviceType = 'fuchsia';
      }
      return deviceType;
    } catch (e) {
      print("Error mendapatkan tipe perangkat: $e");
      return 'unknown';
    }
  }

  Future<int> sendFCMDevice({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // Dapatkan FCM token
      final fcmToken = await getTokenFcm();

      // Dapatkan informasi device type
      final deviceType = await getDeviceType();

      final response = await serviceFCM.sendFCMTokenDevice(
        token: token,
        deviceToken: fcmToken!,
        deviceType: deviceType,
      );

      isLoading = false;

      if (response != null) {
        isSukses = true;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message;
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<void> saveDataSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', idSharedPreference);
    await prefs.setString('name', nameSharedPreference);
    await prefs.setString('email', emailSharedPreference);
    await prefs.setString('role', roleSharedPreference);
    await prefs.setString('nim', nimSharedPreference);
    await prefs.setString('nidn', nidnSharedPreference);
    await prefs.setString('token', tokenSharedPreference);
    await prefs.setBool('rememberMe', rememberMe); // ✅ Simpan RememberMe
    notifyListeners();
  }


  Future<void> checkSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    idSharedPreference = prefs.getInt('id') ?? 0;
    nameSharedPreference = prefs.getString('name') ?? "";
    emailSharedPreference = prefs.getString('email') ?? "";
    roleSharedPreference = prefs.getString('role') ?? "";
    nimSharedPreference = prefs.getString('nim') ?? "";
    nidnSharedPreference = prefs.getString('nidn') ?? "";
    tokenSharedPreference = prefs.getString('token') ?? "";
    rememberMe = prefs.getBool('rememberMe') ?? false; // ✅ Cek RememberMe
    notifyListeners();
  }


  void toggleError(bool value) {
    showErrorMessage = value;
    notifyListeners();
  }

  void setRememberMe(bool value) async {
    rememberMe = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value); // ✅ Simpan "Ingat Saya"
    notifyListeners();
  }

  void setSudahLogin() {
    if (tokenSharedPreference != '') {
      isSudahLogin = true;
    } else {
      isSudahLogin = false;
    }
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      heightContainer = true;
      notifyListeners();
      return 'Email tidak boleh kosong';
    } else if (!EmailValidator.validate(value)) {
      heightContainer = true;
      notifyListeners();
      return 'Format email salah';
    }
    heightContainer = false;
    notifyListeners();
    return null;
  }

  String? validatePassword(String value) {
    heightContainer = true;
    notifyListeners();
    if (value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    heightContainer = false;
    notifyListeners();
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void clearSignInForm() {
    email.clear();
    password.clear();
  }

  void checkLogin(BuildContext context) async {
    logindata = await SharedPreferences.getInstance();
    bool isRemembered = logindata.getBool('rememberMe') ?? false;
    String? token = logindata.getString('token'); // ✅ Cek token login

    if (isRemembered && token != null && token.isNotEmpty) {
      // ✅ Jika Remember Me aktif & token ada, langsung ke BoardScreen
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NavigationScreen()),
          (route) => false,
        );
      });
    } else {
      // ❌ Jika Remember Me tidak aktif atau token kosong, arahkan ke SignInScreen
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          (route) => false,
        );
      });
    }
  }

  // Future<void> checkLogin(BuildContext context) async {
  //   try {
  //     // Periksa data dari SharedPreferences
  //     await checkSharedPreferences();

  //     // Set status login
  //     setSudahLogin();

  //     print("Token: $tokenSharedPreference");
  //     print("Remember Me: $rememberMe");
  //     print("Is Sudah Login: $isSudahLogin");

  //     // Delay untuk menampilkan splash screen
  //     await Future.delayed(const Duration(seconds: 2));

  //     if (context.mounted) {
  //       if (tokenSharedPreference.isNotEmpty && rememberMe) {
  //         // Navigasi ke NavigationScreen (bottom navbar)
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => const NavigationScreen()),
  //           (route) => false,
  //         );
  //       } else {
  //         // Navigasi ke Onboarding
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => const OnboardingScreen()),
  //           (route) => false,
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     print("Error checking login status: $e");
  //   }
  // }


  /// ✅ **Fungsi logout: Hapus data login**
  Future<void> keluar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // ❌ Hapus semua data login
    rememberMe = false; // ❌ Reset Remember Me
    notifyListeners();
  }
}
