import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/screen/view/forgotpassword/ubah_password_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/button.dart';
import 'package:projectmanagementstmiktime/view_model/forgot_password/view_model_forgot_password.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';

class VerifikasiOtpScreen extends StatefulWidget {
  const VerifikasiOtpScreen({super.key});

  @override
  State<VerifikasiOtpScreen> createState() => _VerifikasiOtpScreenState();
}

class _VerifikasiOtpScreenState extends State<VerifikasiOtpScreen> {
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
    final heightContainer = heightMediaQuery / 3;
    double appBarHeight = AppBar().preferredSize.height;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: widthMediaQuery,
          height: heightMediaQuery - appBarHeight - 70,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: heightMediaQuery / 3,
                  width: widthMediaQuery,
                  decoration: const BoxDecoration(
                      color: Color(0xFF293066),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                  child: Column(
                    children: [
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
                              'OTP Kata Sandi',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Silahkan Masukkan 6 Digit Kode yang dikirim ke Alamat Email Anda',
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
                top: heightMediaQuery / 3.5,
                left: widthMediaQuery / 15,
                right: widthMediaQuery / 15,
                child: Container(
                  height: heightContainer,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5E9F4),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        8.0,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: heightContainer / 2,
                        child: Center(
                          child: SizedBox(child:
                              Consumer<ForgotPasswordViewModel>(
                                  builder: (context, viewModel, child) {
                            return Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 40,
                                      child: OtpTextField(
                                        alignment: Alignment.center,
                                        keyboardType: TextInputType.number,
                                        margin: const EdgeInsets.only(right: 2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(7.0)),
                                        filled: true,
                                        numberOfFields: 6,
                                        focusedBorderColor:
                                            const Color(0xFF484F88),
                                        showFieldAsBox: true,
                                        borderWidth: 2.0,
                                        onCodeChanged: (String code) {},
                                        onSubmit: (String verificationCode) {
                                          viewModel.kodeOtp = verificationCode;
                                        },
                                      ),
                                    )),
                                const SizedBox(height: 5),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Tidak menerima kode? ',
                                          style: TextStyle(
                                              color: Color(0xFF293066),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13),
                                        ),
                                        TextSpan(
                                          text: 'Kirim ulang',
                                          style: const TextStyle(
                                            color: Color(0xFF8CA2CE),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              try {
                                                final statusCode =
                                                    await viewModel
                                                        .resendReqOTP();

                                                if (statusCode == 200) {
                                                  customAlert(
                                                    context: context,
                                                    alertType:
                                                        QuickAlertType.success,
                                                    title: "Kode OTP Dikirim!",
                                                    text: viewModel
                                                            .successMessage ??
                                                        "Kode OTP telah kami kirim! Silahkan cek email Anda.",
                                                  );
                                                } else if (statusCode == 400) {
                                                  customAlert(
                                                    context: context,
                                                    alertType:
                                                        QuickAlertType.error,
                                                    title:
                                                        "Data Tidak Ditemukan!\n",
                                                    text: viewModel
                                                            .errorMessages ??
                                                        "Email tidak ditemukan.",
                                                  );
                                                } else if (statusCode == 429) {
                                                  customAlert(
                                                    context: context,
                                                    alertType:
                                                        QuickAlertType.warning,
                                                    title:
                                                        "Terlalu Banyak Permintaan!\n",
                                                    text: viewModel
                                                            .errorMessages ??
                                                        "Terlalu banyak permintaan OTP. Coba lagi dalam beberapa menit.",
                                                  );
                                                } else {
                                                  customAlert(
                                                    context: context,
                                                    alertType:
                                                        QuickAlertType.error,
                                                    text:
                                                        "Terjadi kesalahan. Coba lagi nanti.",
                                                  );
                                                }
                                              } on SocketException {
                                                customAlert(
                                                  context: context,
                                                  alertType:
                                                      QuickAlertType.warning,
                                                  text:
                                                      'Tidak ada koneksi internet. Periksa jaringan Anda.',
                                                );
                                              } catch (e) {
                                                customAlert(
                                                  context: context,
                                                  alertType:
                                                      QuickAlertType.error,
                                                  text:
                                                      'Terjadi kesalahan: ${e.toString()}',
                                                );
                                              }
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          })),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Consumer<ForgotPasswordViewModel>(
                          builder: (context, contactModel, child) {
                            return customButton(
                              text: "Verifikasi",
                              bgColor: const Color(0xFF484F88),
                              onPressed: () async {
                                final otpForget = viewModel.kodeOtp;
                                try {
                                  final statusCode = await viewModel
                                      .checkVerifikasiOTP(kodeOtp: otpForget);

                                  if (!context.mounted) return;

                                  if (statusCode == 200) {
                                    customAlert(
                                      context: context,
                                      alertType: QuickAlertType.success,
                                      title: viewModel.successMessage ??
                                          "OTP Berhasil di Verifikasi!",
                                      afterDelay: () {
                                        if (context.mounted) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const UbahPasswordScreen(),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  } else if (statusCode == 422) {
                                    // ✅ Tidak ada pop, biarkan user tetap di screen Verifikasi OTP
                                    customAlert(
                                      context: context,
                                      alertType: QuickAlertType.error,
                                      title: viewModel.errorMessages ??
                                          "Kode OTP Salah!",
                                    );
                                  } else {
                                    // ✅ Tidak ada pop, tetap di screen yang sama
                                    customAlert(
                                      context: context,
                                      alertType: QuickAlertType.error,
                                      text:
                                          "Terjadi kesalahan. Coba lagi nanti.",
                                    );
                                  }
                                } on SocketException {
                                  if (context.mounted) {
                                    customAlert(
                                      context: context,
                                      alertType: QuickAlertType.warning,
                                      text:
                                          "Tidak ada koneksi internet. Periksa jaringan anda",
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    // ❌ Jangan pop context saat error terjadi
                                    customAlert(
                                      context: context,
                                      alertType: QuickAlertType.error,
                                      text: 'Terjadi kesalahan ${e.toString()}',
                                    );
                                  }
                                }
                                // ? customAlert(
                                //     context: context,
                                //     alertType: QuickAlertType.custom,
                                //     customAsset:
                                //         'assets/Group 427318233.png',
                                //     text:
                                //         'Yey! Akun anda telah berhasil dipulihkan...!',
                                //     afterDelay: () {
                                //       Navigator.pop(context);
                                //       Navigator.pushReplacement(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (_) =>
                                //               const UbahPasswordScreen(),
                                //         ),
                                //       );
                                //     },
                                //   )
                                // : customAlert(
                                //     context: context,
                                //     alertType: QuickAlertType.error,
                                //     text: 'OTP yang anda masukkan salah',
                                //     afterDelay: () {
                                //       Navigator.pop(context);
                                //     },
                                //   );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
