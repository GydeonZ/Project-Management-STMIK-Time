// import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_raih_peduli/model/model_otp.dart';
// import '../../services/service_sign_up.dart';

class SignUpViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController nim = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cnfrmPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  bool showErrorMessage = false;
  bool isResponseSuccess = false;
  String kodeOtp = "";
  // final service = SignUpService();
  // ModelOtp? otp;
  bool isPasswordVisible = false;
  bool heightContainer = false;

  void toggleError(bool value) {
    showErrorMessage = value;
    notifyListeners();
  }

  // Future<void> signUp() async {
  //   final nameUser = fullname.text;
  //   final emailUser = email.text;
  //   final passwordUser = password.text;
  //   final addressUser = address.text;
  //   final phoneUser = phone.text;
  //   final genderUser = selectedGender;
  // //   service.signUpAccount(
  // //       nameUser, emailUser, passwordUser, addressUser, phoneUser, genderUser);
  // // }

  // Future verifikasi({
  //   required String kodeOtp,
  // }) async {
  //   try {
  //     otp = await service.verifikasiOtp(
  //       otp: kodeOtp,
  //     );

  //     isResponseSuccess = true;
  //     fullname.clear();
  //     email.clear();
  //     selectedGender = 'Select Gender';
  //     address.clear();
  //     phone.clear();
  //     password.clear();
  //     notifyListeners();
  //   } catch (e) {
  //     // ignore: deprecated_member_use
  //     if (e is DioError) {
  //       isResponseSuccess = false;
  //       e.response!.statusCode;
  //     }
  //   }
  // }

  // Future<void> reSendOtp() async {
  //   service.fecthNewOtp(email.text);
  // }

  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  String? validateUsename(String value) {
    if (value.isEmpty) {
      return 'Username tidak boleh kosong';
    }
    return null;
  }

  String? validateNIM(String value) {
    if (value.isEmpty) {
      return 'NIM tidak boleh kosong';
    } else if (value.length < 7) {
      return 'NIM harus memiliki 7 karakter';
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email tidak boleh kosong';
    } else if (!EmailValidator.validate(value)) {
      return 'Format email salah';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (value.length < 8) {
      return 'Password harus memiliki setidaknya 8 karakter';
    } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$').hasMatch(value)) {
      return 'Password harus berupa kombinasi huruf dan angka';
    } else if (value != password.text) {
      return 'Password tidak sama';
    }
    return null;
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }
}
