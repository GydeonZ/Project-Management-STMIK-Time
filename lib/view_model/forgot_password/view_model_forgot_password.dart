import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/services/service_forgot_password.dart';

class ForgotPasswordViewModel with ChangeNotifier {
  final formKeyEmailForgetPassword = GlobalKey<FormState>();
  final formKeyUbahPassword = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController konfirmasiPassword = TextEditingController();
  final service = ForgotPasswordService();
  bool isResponseSuccess = false;
  bool heightContainer = false;
  bool isPasswordVisible = false;
  bool isPasswordVisible1 = false;
  bool isLoading = false;
  String? errorMessages;
  String? successMessage;

  void verifikasiSukses() async {
    isResponseSuccess = true;
    notifyListeners();
  }

  void verifikasiGagal() async {
    isResponseSuccess = false;
    notifyListeners();
  }

  Future<int> sendReqOtp() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.requestOTP(emailUser: email.text);
      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null; // Reset error jika sebelumnya ada
        email.clear();
        isResponseSuccess = true;
        notifyListeners();
        return 200;
      } else {
        isResponseSuccess = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email tidak boleh kosong';
    } else if (!EmailValidator.validate(value)) {
      return 'Format email salah';
    }
    return null;
  }

  String? validatePasswordBaru(String value) {
    if (value.isEmpty) {
      heightContainer = true;
      notifyListeners();
      return 'Password tidak boleh kosong';
    } else if (value.length < 8) {
      heightContainer = true;
      notifyListeners();
      return 'Password harus memiliki setidaknya 8 karakter';
    } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$').hasMatch(value)) {
      heightContainer = true;
      notifyListeners();
      return 'Password harus berupa kombinasi huruf dan angka';
    }
    heightContainer = false;
    notifyListeners();
    return null;
  }

  String? validateKonfirmasiPassword(String value) {
    if (value.isEmpty) {
      heightContainer = true;
      notifyListeners();
      return 'Konfirmasi password tidak boleh kosong';
    } else if (value != password.text) {
      heightContainer = true;
      notifyListeners();
      return 'Password tidak sama';
    }
    heightContainer = false;
    notifyListeners();
    return null;
  }

  void setUlang() {
    heightContainer = false;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void togglePasswordVisibility1() {
    isPasswordVisible1 = !isPasswordVisible1;
    notifyListeners();
  }
}
