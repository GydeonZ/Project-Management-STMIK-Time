// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/screen/view/signin_signup/signscreen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/button.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/forgot_password/view_model_forgot_password.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class UbahPasswordScreen extends StatefulWidget {
  const UbahPasswordScreen({super.key});

  @override
  State<UbahPasswordScreen> createState() => _UbahPasswordScreenState();
}

class _UbahPasswordScreenState extends State<UbahPasswordScreen> {
  late ForgotPasswordViewModel viewModel;
  final GlobalKey<FormState> formKeyUbahPassword = GlobalKey<FormState>();
  bool _isFirstRun = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstRun) {
      viewModel = Provider.of<ForgotPasswordViewModel>(context, listen: false);
      viewModel.setUlang();
      _isFirstRun = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthMediaQuery = MediaQuery.of(context).size.width;
    final heightMediaQuery = MediaQuery.of(context).size.height;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: widthMediaQuery,
            height: heightMediaQuery - (heightMediaQuery * 0.05),
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    height: heightMediaQuery / 2.5,
                    width: widthMediaQuery,
                    decoration: const BoxDecoration(
                        color: Color(0xFF293066),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                    child: Column(
                      children: [
                        Container(
                          height: heightMediaQuery * 0.075,
                          color: const Color(0xFF293066),
                        ),
                        Center(
                          child: SvgPicture.asset(
                            "assets/logo_no_title.svg",
                            width: size.width * 0.3,
                            height: size.width * 0.3,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kata Sandi Baru',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Kata Sandi Baru harus berbeda dari kata sandi sebelumnya.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: heightMediaQuery / 3,
                  left: widthMediaQuery / 15,
                  right: widthMediaQuery / 15,
                  child: Consumer<ForgotPasswordViewModel>(
                    builder: (context, viewModel, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: viewModel.heightContainer
                            ? heightMediaQuery / 2.5
                            : heightMediaQuery / 3.25,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE5E9F4),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Form(
                                  key: formKeyUbahPassword,
                                  child: Column(
                                    children: [
                                      customTextFormField(
                                        titleText: "Password Baru",
                                        controller: viewModel.password,
                                        labelText: "Password",
                                        obscureText:
                                            !viewModel.isPasswordVisible1,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            viewModel.isPasswordVisible1
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: const Color(0xFF484F88),
                                          ),
                                          onPressed: () {
                                            viewModel
                                                .togglePasswordVisibility1();
                                          },
                                        ),
                                        validator: (value) => viewModel
                                            .validatePasswordBaru(value!),
                                      ),
                                      const SizedBox(height: 5),
                                      customTextFormField(
                                        titleText: "Konfirmasi Password",
                                        controller:
                                            viewModel.konfirmasiPassword,
                                        labelText: "Password",
                                        obscureText:
                                            !viewModel.isPasswordVisible,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            viewModel.isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: const Color(0xFF484F88),
                                          ),
                                          onPressed: () {
                                            viewModel
                                                .togglePasswordVisibility();
                                          },
                                        ),
                                        validator: (value) => viewModel
                                            .validateKonfirmasiPassword(value!),
                                      ),
                                    ],
                                  ),
                                ),
                                customButton(
                                  text: "Simpan",
                                  bgColor: const Color(0xFF484F88),
                                  onPressed: () async {
                                    if (formKeyUbahPassword.currentState!
                                        .validate()) {
                                      customAlert(
                                          alertType: QuickAlertType.loading,
                                          text: 'Mohon Tunggu...');
                                      try {
                                        final statusCode =
                                            await viewModel.ubahPassword();
                                        Navigator.pop(
                                            context); // Menutup loading alert

                                        if (statusCode == 200) {
                                          customAlert(
                                            alertType: QuickAlertType.success,
                                            title: viewModel.successMessage ??
                                                'Password Berhasil Diperbarui',
                                            afterDelay: () {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const SignInScreen()),
                                                (route) => false,
                                              );
                                            },
                                          );
                                        } else if (statusCode == 422) {
                                          customAlert(
                                            alertType: QuickAlertType.error,
                                            title: viewModel.errorMessages ??
                                                'Token Tidak Valid !',
                                          );
                                        } else {
                                          customAlert(
                                            alertType: QuickAlertType.error,
                                            title: 'Gagal memperbarui password',
                                          );
                                        }
                                      } on SocketException {
                                        customAlert(
                                          alertType: QuickAlertType.warning,
                                          text:
                                              'Tidak ada koneksi internet. Periksa jaringan Anda.',
                                        );
                                      } 
                                      catch (e) {
                                        customAlert(
                                          alertType: QuickAlertType.error,
                                          text:
                                              'Terjadi kesalahan: ${e.toString()}',
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
