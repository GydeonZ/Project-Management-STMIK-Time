// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/services/service_reset_password.dart';

class ResetPasswordViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController tokenLink = TextEditingController();
  final TextEditingController emailLink = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cnfrmPassword = TextEditingController();
  final resetService = ResetPasswordService();
  bool isPasswordVisiblePasswordLama = false;
  bool isPasswordVisiblePasswordBaru = false;
  bool isGagalCheckPasswordLama = false;
  bool isGagalChangePassword = false;
  final service = ResetPasswordService();
  bool isLoading = false;
  String? errorMessages;
  String? successMessage;
  bool isResponseSuccess = false;
  bool heightContainer = false;

  Future<int> fetchNewPassword({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await resetService.resetPasswordUser(
        tokenLink: tokenLink.text, // ✅ Gunakan token dari deep link
        emailLink: emailLink.text, // ✅ Gunakan email dari deep link
        passwordUser: password.text,
        cnfrmpasswordUser: cnfrmPassword.text,
      );
      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        notifyListeners();
        return 200;
      }
      return 500;
    } catch (e) {
      errorMessages = "Terjadi kesalahan Silahkan Coba lagi nanti";
      notifyListeners();
      return 500;
    }
  }

  void setUlang() {
    heightContainer = false;
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
