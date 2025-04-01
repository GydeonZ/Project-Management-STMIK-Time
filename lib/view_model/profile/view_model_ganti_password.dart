// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/services/service_ganti_password_profile.dart';

class GantiPasswordViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordLama = TextEditingController();
  final TextEditingController passwordBaru = TextEditingController();
  final TextEditingController cnfrmPassword = TextEditingController();
  bool isPasswordVisiblePasswordLama = false;
  bool isPasswordVisiblePasswordBaru = false;
  bool isPasswordVisibleCnfrmPassword = false;
  bool isGagalCheckPasswordLama = false;
  bool isGagalChangePassword = false;
  final service = GantiPasswordProfileService();
  bool isResponseSuccess = false;
  bool isLoading = false;
  String? errorMessages;
  String? successMessage;

  Future<int> changeNewPasswordProfile({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.hitGantiPasswordProfile(
        token: token,
        pwdSekarang: passwordLama.text,
        password: passwordBaru.text,
        pwdConfirm: cnfrmPassword.text,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null; // ✅ Reset error jika sebelumnya ada
        clearGantiPasswordFrom();
        isResponseSuccess = true;
        notifyListeners();
        return 200; // ✅ Ambil pesan sukses dari API
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

  void verifikasiSukses() async {
    isResponseSuccess = true;
    notifyListeners();
  }

  void verifikasiGagal() async {
    isResponseSuccess = false;
    notifyListeners();
  }

  String? validatePasswordBaru(String value) {
    if (value.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (value.length < 8) {
      return 'Password harus memiliki setidaknya 8 karakter';
    } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$').hasMatch(value)) {
      return 'Password harus berupa kombinasi huruf dan angka';
    } else if (value != passwordBaru.text) {
      return 'Password tidak sama';
    }
    return null;
  }

  String? validatePasswordLama(String value) {
    if (value.isEmpty) {
      notifyListeners();
      return 'Password tidak boleh kosong';
    }
    notifyListeners();
    return null;
  }

  void togglePasswordVisibilityPasswordLama() {
    isPasswordVisiblePasswordLama = !isPasswordVisiblePasswordLama;
    notifyListeners();
  }

  void togglePasswordVisibilityPasswordBaru() {
    isPasswordVisiblePasswordBaru = !isPasswordVisiblePasswordBaru;
    notifyListeners();
  }

  void togglePasswordVisibilityCnfrmPassword() {
    isPasswordVisibleCnfrmPassword = !isPasswordVisibleCnfrmPassword;
    notifyListeners();
  }

  void clearGantiPasswordFrom() {
    passwordLama.clear();
    passwordBaru.clear();
    cnfrmPassword.clear();
    isPasswordVisiblePasswordLama = false;
    isPasswordVisiblePasswordBaru = false;
    isPasswordVisibleCnfrmPassword = false;
    notifyListeners();
  }
}
