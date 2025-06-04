// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectmanagementstmiktime/screen/view/onboarding/onboarding.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/button.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/profile/view_model_ganti_password.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class GantiPasswordScreen extends StatelessWidget {
  const GantiPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sp = Provider.of<SignInViewModel>(context, listen: false);
    final token = sp.tokenSharedPreference;
    final viewModel =
        Provider.of<GantiPasswordViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Kata Sandi Baru',
          style: GoogleFonts.figtree(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Consumer<GantiPasswordViewModel>(
            builder: (context, contactModel, child) {
              return Form(
                key: viewModel.formKey,
                child: Column(
                  children: [
                    customTextFormField(
                      controller: viewModel.passwordLama,
                      titleText: 'Password Lama',
                      labelText: "Masukkan password anda yang lama",
                      obscureText: !viewModel.isPasswordVisiblePasswordLama,
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.isPasswordVisiblePasswordBaru
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF484F88),
                        ),
                        onPressed: () {
                          viewModel.togglePasswordVisibilityPasswordLama();
                        },
                      ),
                      validator: (value) =>
                          viewModel.validatePasswordLama(value!),
                    ),
                    const SizedBox(height: 5),
                    customTextFormField(
                      controller: viewModel.passwordBaru,
                      titleText: 'Password Baru',
                      labelText: "Masukkan password anda yang baru",
                      obscureText: !viewModel.isPasswordVisiblePasswordBaru,
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.isPasswordVisiblePasswordBaru
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF484F88),
                        ),
                        onPressed: () {
                          viewModel.togglePasswordVisibilityPasswordBaru();
                        },
                      ),
                      validator: (value) =>
                          viewModel.validatePasswordBaru(value!),
                    ),
                    const SizedBox(height: 5),
                    customTextFormField(
                      controller: viewModel.cnfrmPassword,
                      titleText: 'Konfirmasi Password',
                      labelText: "Masukkan ulang password anda",
                      obscureText: !viewModel.isPasswordVisibleCnfrmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.isPasswordVisibleCnfrmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF484F88),
                        ),
                        onPressed: () {
                          viewModel.togglePasswordVisibilityCnfrmPassword();
                        },
                      ),
                      validator: (value) =>
                          viewModel.validatePasswordBaru(value!),
                    ),
                    const SizedBox(height: 15),
                    Consumer<GantiPasswordViewModel>(
                      builder: (context, viewModel, child) {
                        return customButton(
                          text: "Lanjut",
                          bgColor: const Color(0xFF484F88),
                          onPressed: () async {
                            if (viewModel.formKey.currentState!.validate()) {
                              customAlert(
                                alertType: QuickAlertType.loading,
                                text: "Mohon Tunggu...",
                              );

                              try {
                                final response =
                                    await viewModel.changeNewPasswordProfile(
                                  token: token,
                                );
                                Navigator.pop(context);
                                if (response == 200) {
                                  customAlert(
                                    alertType: QuickAlertType.success,
                                    title: viewModel.successMessage ??
                                        "Password berhasil diperbarui silahkan login kembali",
                                    afterDelay: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const OnboardingScreen(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                  );
                                } else if (response == 400) {
                                  customAlert(
                                    alertType: QuickAlertType.error,
                                    title: "Data Anda Salah!\n",
                                    text: viewModel.errorMessages ??
                                        "Password lama tidak sesuai.",
                                  );
                                } else {
                                  customAlert(
                                    alertType: QuickAlertType.error,
                                    text: "Terjadi kesalahan. Coba lagi nanti.",
                                  );
                                }
                              } on SocketException {
                                Navigator.pop(context);
                                customAlert(
                                  alertType: QuickAlertType.warning,
                                  text:
                                      'Tidak ada koneksi internet. Periksa jaringan Anda.',
                                );
                              } catch (e) {
                                Navigator.pop(context);
                                customAlert(
                                  alertType: QuickAlertType.error,
                                  text:
                                      'Terjadi kesalahan Silahkan Coba lagi nanti',
                                );
                              }
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
