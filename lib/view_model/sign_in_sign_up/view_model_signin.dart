// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/model/model_sign_in.dart';
import 'package:projectmanagementstmiktime/screen/view/navigation/navigation.dart';
import 'package:projectmanagementstmiktime/screen/view/onboarding/onboarding.dart';
import 'package:projectmanagementstmiktime/services/services_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInViewModel with ChangeNotifier {
  late GlobalKey<FormState> formKeySignin;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool showErrorMessage = false;
  final service = SignInService();
  bool rememberMe = false;
  bool heightContainer = false;
  ModelSignIn? dataLogin;
  late SharedPreferences logindata;
  late bool newUser;
  String nameSharedPreference = '';
  String emailSharedPreference = '';
  String nimSharedPreference = '';
  String nidnSharedPreference = '';
  bool isPasswordVisible = false;
  bool isSudahLogin = false;
  bool isSuksesLogin = false;
  String fcm = "";

  SignInViewModel() {
    checkSharedPreferences();
  }

Future signIn() async {
    try {
      dataLogin = await service.signInAccount(
        email: email.text,
        password: password.text,
      );
      // Pastikan dataLogin tidak null sebelum mengambil nilainya
      if (dataLogin != null) {
        nameSharedPreference = dataLogin!.user.name;
        emailSharedPreference = dataLogin!.user.email;
        nimSharedPreference = dataLogin!.user.nim ?? "";
        nidnSharedPreference = dataLogin!.user.nidn ?? "";

        isSuksesLogin = true;
        debugPrint('Login berhasil, isSuksesLogin: $isSuksesLogin');
      } else {
        isSuksesLogin = false;
        debugPrint('Login gagal: dataLogin null');
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("Login gagal dengan error: ${e.response?.data}");
        isSuksesLogin = false;
      } else {
        debugPrint("Error tidak terduga: $e");
        isSuksesLogin = false;
      }
    }

    notifyListeners();
  }


  void toggleError(bool value) {
    showErrorMessage = value;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  Future<void> saveDataSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameSharedPreference);
    await prefs.setString('email', emailSharedPreference);
    notifyListeners();
  }

  Future<void> checkSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFullName = prefs.getString('name');
    final storedEmail = prefs.getString('email');

    nameSharedPreference = storedFullName!;
    emailSharedPreference = storedEmail!;
    notifyListeners();
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
    newUser = logindata.getBool('login') ?? true;

    if (newUser == false) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavgationBarWidget(),
          ),
          (route) => false);
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const OnboardingScreen(),
            ),
            (route) => false);
      });
    }
  }

  Future<void> keluar() async {
    nameSharedPreference = '';
    emailSharedPreference = '';
    isSuksesLogin = false;
    // saveDataSharedPreferences();
    notifyListeners();
  }

  void updateFoto({required String updateEmail, required String updateName}) {
    emailSharedPreference = updateEmail;
    nameSharedPreference = updateName;
  }
}
