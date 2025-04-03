import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/screen/view/forgotpassword/verifikasi_otp_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/button.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/forgot_password/view_model_forgot_password.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ForgotPasswordViewModel viewModel;
  final GlobalKey<FormState> formKeyUbahPassword = GlobalKey<FormState>();
  @override
  void initState() {
    viewModel = Provider.of<ForgotPasswordViewModel>(context, listen: false);
    super.initState();
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
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  color: Colors.white,
                                  Icons.arrow_back_ios,
                                  size: 24.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: SvgPicture.asset(
                            "assets/logo_no_title.svg",
                            width: size.width * 0.3,
                            height: size.width * 0.3,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lupa Kata Sandi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(right: size.width * 0.2),
                                child: const Text(
                                  'Masukkan email Anda dan kami akan mengirimkan kode OTP ke email Anda.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
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
                  top: heightMediaQuery / 2.9,
                  left: widthMediaQuery / 15,
                  right: widthMediaQuery / 15,
                  child: Container(
                    height: heightMediaQuery / 4.5,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5E9F4),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          8.0,
                        ),
                      ),
                    ),
                    child: Consumer<ForgotPasswordViewModel>(
                      builder: (context, viewModel, child) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Form(
                              key: formKeyUbahPassword,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customTextFormField(
                                      titleText: "Email",
                                      controller: viewModel.email,
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Color(0xFF484F88),
                                        size: 18,
                                      ),
                                      labelText: "Email",
                                      validator: (value) =>
                                          viewModel.validateEmail(value!)),
                                  customButton(
                                    text: "Kirim",
                                    bgColor: const Color(0xFF484F88),
                                    onPressed: () async {
                                      if (formKeyUbahPassword
                                          .currentState!
                                          .validate()) {
                                        customAlert(
                                          context: context,
                                          alertType: QuickAlertType.loading,
                                          text: "Mohon tunggu...",
                                        );

                                        try {
                                          final statusCode = await viewModel
                                              .sendReqOtp();
                                          Navigator.pop(
                                              context); // Tutup loading alert

                                          if (statusCode == 200) {
                                            customAlert(
                                                context: context,
                                                alertType:
                                                    QuickAlertType.success,
                                                title: "Kode OTP Dikirim!",
                                                text: viewModel
                                                        .successMessage ??
                                                    "Kode OTP telah kami kirim! Silahkan cek email Anda.",
                                                afterDelay: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const VerifikasiOtpScreen()),
                                                  );
                                                });
                                          } else if (statusCode == 400) {
                                            customAlert(
                                              context: context,
                                              alertType: QuickAlertType.error,
                                              title: "Data Tidak Ditemukan!\n",
                                              text: viewModel.errorMessages ??
                                                  "Email tidak ditemukan.",
                                            );
                                          } else if (statusCode == 429) {
                                            customAlert(
                                              context: context,
                                              alertType: QuickAlertType.warning,
                                              title: "Terlalu Banyak Permintaan!\n",
                                              text: viewModel.errorMessages ??
                                                  "Terlalu banyak permintaan OTP. Coba lagi dalam beberapa menit.",
                                            );
                                          } else {
                                            customAlert(
                                              context: context,
                                              alertType: QuickAlertType.error,
                                              text:
                                                  "Terjadi kesalahan. Coba lagi nanti.",
                                            );
                                          }
                                        } on SocketException {
                                          customAlert(
                                            context: context,
                                            alertType: QuickAlertType.warning,
                                            text:
                                                'Tidak ada koneksi internet. Periksa jaringan Anda.',
                                          );
                                        } catch (e) {
                                          customAlert(
                                            context: context,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
