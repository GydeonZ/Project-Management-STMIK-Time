// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/services/service_update_profile.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';

class ProfileViewModel with ChangeNotifier {
  // ModelProfile? modelProfile;
  // final service = ProfileService();
  bool isLoading = false;
  final TextEditingController fullNameController = TextEditingController();
  bool isCheckNik = true;
  bool isEdit = false;
  File? imageFile = File('');
  String? imagePath;
  bool fotoLebihLimaMB = false;
  final service = UpdateProfileService();
  String? errorMessages;
  String? successMessage;
  bool isResponseSuccess = false;

  Future<int> changeProfile({
    required String token,
    required SignInViewModel
        signInViewModel, // Tambahkan parameter SignInViewModel
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.hitUpdateProfile(
        token: token,
        nameUser: fullNameController.text,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isResponseSuccess = true;

        // ✅ Update nameSharedPreference di SignInViewModel
        signInViewModel.updateUserName(fullNameController.text);

        fullNameController.clear();
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
        errorMessages = e.message;
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }


  // void setSudahLogin() {
  //   if (modelProfile!.data.nik == '') {
  //     isCheckNik = false;
  //   } else {
  //     isCheckNik = true;
  //   }
  // }

  void enable() {
    isEdit = !isEdit;
    notifyListeners();
  }

  void awal() {
    isEdit = false;
  }

  String? validateNik(String value) {
    if (value.isNotEmpty && value.length != 16) {
      return 'Jumlah NIK wajib 16 digit';
    }
    return null;
  }
}
