import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/services/service_sign_up.dart';

class SignUpViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cnfrmPassword = TextEditingController();
  final TextEditingController nim = TextEditingController();
  final TextEditingController nidn = TextEditingController();

  bool isSukses = false;
  bool isLoading = false;
  final signUpService = SignUpService();

  final List<String> roleList = [
    'Pilih Role Antara Dosen Atau Mahasiswa',
    'Mahasiswa',
    'Dosen',
  ];
  String selectedRole = 'Pilih Role Antara Dosen Atau Mahasiswa';
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  Map<String, String> errorMessages = {};

  /// 📌 Fungsi untuk menangani proses registrasi
  Future<int> signUp() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await signUpService.signUpAccount(
        nameUser: fullname.text,
        emailUser: email.text,
        passwordUser: password.text,
        passwordConfirmationUser: cnfrmPassword.text,
        roleUser: selectedRole,
        nimUser: nim.text,
        nidnUser: nidn.text,
      );

      isLoading = false;

      if (response != null) {
        isSukses = true;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 400;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.toString().contains("422")) {
        // ✅ Parsing error validasi
        errorMessages.clear();
        final errors = (e as Exception).toString().split("\n");
        for (var err in errors) {
          if (err.contains("Email:")) {
            errorMessages["email"] = err.replaceAll("• Email: ", "");
          } else if (err.contains("NIM:")) {
            errorMessages["nim"] = err.replaceAll("• NIM: ", "");
          } else if (err.contains("NIDN:")) {
            errorMessages["nidn"] = err.replaceAll("• NIDN: ", "");
          }
        }
        return 422;
      }

      return 500;
    }
  }

  /// 🔑 Toggle visibilitas password
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  /// 🔑 Toggle visibilitas konfirmasi password
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  /// 📌 Fungsi untuk mengatur ulang role
  void onRoleChanged(String? value) {
    if (value != null && value != "Select Role") {
      selectedRole = value;
      notifyListeners();
    }
  }

  /// 📌 Validasi Input
  String? validateName(String value) {
    if (value.isEmpty) {
      return 'Nama tidak boleh kosong';
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

  String? validateNIDN(String value) {
    if (value.isEmpty) {
      return 'NIDN tidak boleh kosong';
    } else if (value.length < 10) {
      return 'NIDN harus memiliki 10 karakter';
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

  /// 🔄 Mengatur ulang semua input form
  void clearSignUpForm() {
    fullname.clear();
    email.clear();
    password.clear();
    cnfrmPassword.clear();
    selectedRole = 'Pilih Role Antara Dosen Atau Mahasiswa';
    nim.clear();
    nidn.clear();
  }

  void setUlangRole() {
    selectedRole = 'Pilih Role Antara Dosen Atau Mahasiswa';
  }

  String? validateRole(String value) {
    if (value.isEmpty || value == 'Pilih Role Antara Dosen Atau Mahasiswa') {
      return 'Role tidak boleh kosong';
    }
    return null;
  }
}
