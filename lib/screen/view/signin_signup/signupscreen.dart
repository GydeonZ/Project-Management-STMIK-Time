import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectmanagementstmiktime/screen/view/signin_signup/signscreen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signup.dart';
import 'package:projectmanagementstmiktime/screen/widget/button.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late SignUpViewModel viewModel;

  @override
  void initState() {
    viewModel = Provider.of<SignUpViewModel>(context, listen: false);
    viewModel.setUlangRole();
    viewModel.clearSignUpForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Header Tetap (Tidak ikut Scroll)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06,
                vertical: size.height * 0.04,
              ),
              child: Column(
                children: [
                  const Text(
                    "Selamat datang di TIME",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Inter",
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  const Text(
                    "Daftar untuk bergabung",
                    style: TextStyle(
                      color: Color(0xff939393),
                      fontFamily: "Inter",
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Form Bisa Scroll
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    children: [
                      customTextFormField(
                        titleText: "Nama Lengkap",
                        textCapitalization: TextCapitalization.sentences,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z ']+")),
                        ],
                        controller: viewModel.fullname,
                        labelText: "Nama lengkap Anda",
                        validator: (value) => viewModel.validateName(value!),
                      ),
                      customTextFormField(
                        titleText: "Email",
                        controller: viewModel.email,
                        labelText: "Masukkan Email Anda",
                        validator: (value) => viewModel.validateEmail(value!),
                      ),
                      // 🔹 Role Selection
                      Padding(
                        padding: EdgeInsets.only(right: size.width * 0.7),
                        child: const Text(
                          "Role Anda",
                          style: TextStyle(fontFamily: "Inter", fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Consumer<SignUpViewModel>(
                        builder: (context, contactModel, child) {
                          return DropdownButtonFormField<String>(
                            style: TextStyle(
                              color: viewModel.selectedRole ==
                                      'Pilih Role Antara Dosen Atau Mahasiswa'
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  top: 8, left: 20, right: 8),
                              filled: true,
                              fillColor: const Color(0xFFECECEC),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            value: viewModel.selectedRole,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 15,
                            elevation: 160,
                            items: viewModel.roleList
                                .map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            onChanged: (String? newRole) {
                              viewModel.onRoleChanged(newRole);
                              setState(() {}); // Memperbarui tampilan
                            },
                            validator: (value) =>
                                viewModel.validateRole(value!),
                          );
                        },
                      ),
                      const SizedBox(height: 18),

                      // 🔹 Input NIM atau NIDN berdasarkan Role
                      if (viewModel.selectedRole == "Mahasiswa") ...[
                        customTextFormField(
                          titleText: "Nomor Induk Mahasiswa (NIM)",
                          controller: viewModel.nim,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(7),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          labelText: "Masukkan NIM Anda",
                          validator: (value) => viewModel.validateNIM(value!),
                        ),
                      ] else if (viewModel.selectedRole == "Dosen") ...[
                        customTextFormField(
                          titleText: "Nomor Induk Dosen Nasional (NIDN)",
                          controller: viewModel.nidn,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          labelText: "Masukkan NIDN Anda",
                          validator: (value) =>
                              value!.isEmpty ? "NIDN tidak boleh kosong" : null,
                        ),
                      ],
                      // 🔹 Password Fields
                      Consumer<SignUpViewModel>(
                          builder: (context, model, child) {
                        return Column(
                          children: [
                            customTextFormField(
                              titleText: "Kata Sandi",
                              controller: viewModel.password,
                              labelText: "Kata sandi Anda",
                              obscureText: !viewModel.isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  viewModel.isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xFF484F88),
                                ),
                                onPressed: () {
                                  viewModel.togglePasswordVisibility();
                                },
                              ),
                              validator: (value) =>
                                  viewModel.validatePassword(value!),
                            ),
                            customTextFormField(
                              titleText: "Konfirmasi Kata Sandi",
                              controller: viewModel.cnfrmPassword,
                              labelText: "Konfirmasi kata sandi Anda",
                              obscureText: !viewModel.isConfirmPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  viewModel.isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xFF484F88),
                                ),
                                onPressed: () {
                                  viewModel.toggleConfirmPasswordVisibility();
                                },
                              ),
                              validator: (value) =>
                                  viewModel.validatePassword(value!),
                            ),
                          ],
                        );
                      })
                    ],
                  ),
                ),
              ),
            ),
            // 🔹 Footer Tetap (Tidak ikut Scroll)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06,
                vertical: size.height * 0.03,
              ),
              child: Column(
                children: [
                  Consumer<SignUpViewModel>(
                    builder: (context, viewModel, child) {
                      return customButton(
                        text: "Daftar",
                        fntSize: 16,
                        height: size.height * 0.055,
                        bgColor: const Color(0xff3853A4),
                        onPressed: () async {
                          if (viewModel.formKey.currentState!.validate()) {
                            // ✅ Tampilkan loading alert
                            customAlert(
                              context: context,
                              alertType: QuickAlertType.loading,
                              text: "Mohon tunggu...",
                            );

                            try {
                              final statusCode = await viewModel.signUp();
                              Navigator.pop(context); // ✅ Tutup loading alert

                              if (statusCode == 200) {
                                // ✅ Registrasi sukses
                                customAlert(
                                  context: context,
                                  alertType: QuickAlertType.success,
                                  text: 'Daftar berhasil! Silakan verifikasi email Anda.',
                                  afterDelay: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const SignInScreen()),
                                    );
                                  },
                                );
                                viewModel.clearSignUpForm();
                              } else if (statusCode == 422) {
                                // ❌ Menampilkan error validasi email/NIM/NIDN
                                String errorMessage = "";

                                if (viewModel.errorMessages
                                    .containsKey("email")) {
                                  errorMessage +=
                                      "${viewModel.errorMessages["email"]}\n\n";
                                }
                                if (viewModel.errorMessages
                                    .containsKey("nim")) {
                                  errorMessage +=
                                      "${viewModel.errorMessages["nim"]}\n";
                                }
                                if (viewModel.errorMessages
                                    .containsKey("nidn")) {
                                  errorMessage +=
                                      "${viewModel.errorMessages["nidn"]}\n";
                                }

                                customAlert(
                                  context: context,
                                  alertType: QuickAlertType.error,
                                  title: "❗️ Pendaftaran Gagal\n",
                                  text: errorMessage,
                                );
                              } else {
                                // ❌ Error lainnya
                                customAlert(
                                  context: context,
                                  alertType: QuickAlertType.error,
                                  text: 'Terjadi kesalahan. Coba lagi nanti.',
                                );
                              }
                            } on SocketException {
                              Navigator.pop(context);
                              customAlert(
                                context: context,
                                alertType: QuickAlertType.warning,
                                text:
                                    'Tidak ada koneksi internet. Periksa jaringan Anda.',
                              );
                            } catch (e) {
                              Navigator.pop(context);
                              customAlert(
                                context: context,
                                alertType: QuickAlertType.error,
                                text: 'Terjadi kesalahan: ${e.toString()}',
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sudah punya akun? ",
                        style: TextStyle(
                            fontFamily: "Inter", color: Color(0xff939393)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Masuk",
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Color(0xff0088D1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
