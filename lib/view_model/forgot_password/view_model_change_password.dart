// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/services/service_reset_password.dart';

class ResetPasswordViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailUser = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cnfrmPassword = TextEditingController();
  bool isPasswordVisiblePasswordLama = false;
  bool isPasswordVisiblePasswordBaru = false;
  bool isGagalCheckPasswordLama = false;
  bool isGagalChangePassword = false;
  final service = ResetPasswordService();
  bool isLoading = false;
  String? errorMessages;
  String? successMessage;
  bool isResponseSuccess = false;

  Future<int> fetchNewPassword({
    required String token
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.resetPasswordUser(tokenLink: token, emailUser: emailUser.text, passwordUser: password.text, cnfrmpasswordUser: cnfrmPassword.text);
      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null; // Reset error jika sebelumnya ada
        emailUser.clear();
        password.clear();
        cnfrmPassword.clear();
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

  String? validatePasswordBaru(String value) {
    if (value.isEmpty) {
      notifyListeners();
      return 'Password tidak boleh kosong';
    } else if (value.length < 8) {
      notifyListeners();
      return 'Password harus memiliki setidaknya 8 karakter';
    } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$').hasMatch(value)) {
      notifyListeners();
      return 'Password harus berupa kombinasi huruf dan angka';
    }
    notifyListeners();
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

  // Future fetchOldPassword({
  //   required String accessToken,
  //   required String refreshToken,
  // }) async {
  //   try {
  //     await service.hitCheckPassword(
  //       token: accessToken,
  //       oldPassword: passwordLama.text,
  //     );
  //     isGagalCheckPasswordLama = true;
  //   } catch (e) {
  //     if (e is DioError) {
  //       try {
  //         await service.hitCheckPassword(
  //           token: refreshToken,
  //           oldPassword: passwordLama.text,
  //         );
  //         isGagalCheckPasswordLama = true;
  //       } catch (e) {
  //         if (e is DioError) {
  //           isGagalCheckPasswordLama = false;
  //           e.response!.statusCode;
  //         }
  //       }
  //     }
  //   }
  //   notifyListeners();
  // }
}
