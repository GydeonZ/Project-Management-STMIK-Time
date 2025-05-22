// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/screen/widget/button.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/forgot_password/view_model_reset_password.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String resetUrl;

  const ResetPasswordScreen(
      {super.key, required this.resetUrl});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetPasswordViewModel viewModel;
  
  @override
  void initState() {
    viewModel = Provider.of<ResetPasswordViewModel>(context, listen: false);
    viewModel.setUlang();
    // Simpan token & email yang diterima dari deep link
    // viewModel.tokenLink.text = widget.token;
    // viewModel.emailLink.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthMediaQuery = MediaQuery.of(context).size.width;
    final heightMediaQuery = MediaQuery.of(context).size.height;

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
                            "assets/logostmik2.svg",
                            width: 100,
                            height: 100,
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
                  top: heightMediaQuery / 2.9,
                  left: widthMediaQuery / 15,
                  right: widthMediaQuery / 15,
                  child: Consumer<ResetPasswordViewModel>(
                    builder: (context, contactModel, child) {
                      return Container(
                        height: viewModel.heightContainer
                            ? heightMediaQuery / 2
                            : heightMediaQuery / 2.4,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE5E9F4),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              8.0,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer<ResetPasswordViewModel>(
                                  builder: (context, contactModel, child) {
                                    return Form(
                                      key: viewModel.formKey,
                                      child: Column(
                                        children: [
                                          customTextFormField(
                                            controller: viewModel.emailLink,
                                            titleText: 'Email',
                                            status: false,
                                            labelText: viewModel.emailLink.text,
                                          ),
                                          const SizedBox(height: 5),
                                          customTextFormField(
                                            controller: viewModel.password,
                                            titleText: 'Password',
                                            labelText: "Masukkan password anda",
                                            obscureText:
                                                !viewModel.isPasswordVisiblePasswordBaru,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                viewModel.isPasswordVisiblePasswordBaru
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: const Color(0xFF484F88),
                                              ),
                                              onPressed: () {
                                                viewModel
                                                    .togglePasswordVisibilityPasswordBaru();
                                              },
                                            ),
                                            validator: (value) => viewModel
                                                .validatePasswordBaru(value!),
                                          ),
                                          const SizedBox(height: 5),
                                          customTextFormField(
                                              controller:
                                                  viewModel.cnfrmPassword,
                                              titleText: "Konfirmasi Pasword",
                                              labelText:
                                                  "Ketik Ulang password anda",
                                              obscureText:
                                                  !viewModel.isPasswordVisiblePasswordLama,
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  viewModel.isPasswordVisiblePasswordLama
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color:
                                                      const Color(0xFF484F88),
                                                ),
                                                onPressed: () {
                                                  viewModel
                                                      .togglePasswordVisibilityPasswordLama();
                                                },
                                              ),
                                              validator: (value) => viewModel
                                                  .validatePasswordLama(
                                                      value!)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                customButton(
                                  text: "Simpan",
                                  bgColor: const Color(0xFF484F88),
                                  onPressed: () async {
                                    // if (viewModel
                                    //     .formKey.currentState!
                                    //     .validate()) {
                                    //   int response =
                                    //       await viewModel.fetchNewPassword(
                                    //     token: widget
                                    //         .token, // Gunakan token dari deep link
                                    //   );
                                    //   if (response == 200) {
                                    //     ScaffoldMessenger.of(context)
                                    //         .showSnackBar(
                                    //       const SnackBar(
                                    //           content: Text(
                                    //               "Password berhasil direset")),
                                    //     );
                                    //   }
                                    // }
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
