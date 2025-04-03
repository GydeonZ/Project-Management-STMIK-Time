import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/model/model_verifikasi_otp.dart';
import 'package:projectmanagementstmiktime/services/service_forgot_password.dart';

class ForgotPasswordViewModel with ChangeNotifier {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController konfirmasiPassword = TextEditingController();
  final service = ForgotPasswordService();
  ModelVerifikasiOtp? dataOtp;
  String kodeOtp = "";
  String savedEmail = "";
  String? savedToken;
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
        savedEmail = email.text;
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
      } else if (e.response != null && e.response!.statusCode == 429) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 429;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> resendReqOTP() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.requestOTP(emailUser: savedEmail);
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

  Future<int> checkVerifikasiOTP({
    required String kodeOtp,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.hitVerifikasiOTP(
          emailUser: savedEmail, kodeOTP: kodeOtp);
      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null; // Reset error jika sebelumnya ada
        savedToken = response.token; // Simpan token di ViewModel
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

      if (e.response != null && e.response!.statusCode == 422) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 422;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> ubahPassword() async {
    final newPassword = password.text;
    final confirmPassword = konfirmasiPassword.text;
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.hitUbahPassword(
          emailUser: savedEmail,
          password: newPassword,
          cnfrmPassword: confirmPassword,
          token: savedToken!);
      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null; // Reset error jika sebelumnya ada
        savedEmail = '';
        savedToken = '';
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
      heightContainer = true; // Jika ada error, tinggi container bertambah
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
    heightContainer = false; // Jika tidak ada error, tinggi kembali normal
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
