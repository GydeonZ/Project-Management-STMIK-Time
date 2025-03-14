import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectmanagementstmiktime/screen/view/signin_signup/signscreen.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signup.dart';
import 'package:projectmanagementstmiktime/screen/widget/button.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:provider/provider.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allow content to resize when keyboard appears
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsetsDirectional.only(
                top: size.height * 0.02,
                bottom: size.height * 0.06,
                start: size.width * 0.06,
                end: size.width * 0.06,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      SizedBox(height: size.height * 0.05),
                      Flexible(
                        child: Form(
                          key: viewModel.formKey,
                          child: Column(
                            children: [
                              customTextFormField(
                                titleText: "Nama Pengguna",
                                textCapitalization:
                                    TextCapitalization.sentences,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z ']+"),
                                  ),
                                ],
                                controller: viewModel.username,
                                labelText: "Nama pengguna Anda",
                                validator: (value) =>
                                    viewModel.validateUsename(value!),
                              ),
                              customTextFormField(
                                titleText: "Nama Lengkap",
                                textCapitalization:
                                    TextCapitalization.sentences,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z ']+"),
                                  ),
                                ],
                                controller: viewModel.fullname,
                                labelText: "Nama lengkap Anda",
                                validator: (value) =>
                                    viewModel.validateName(value!),
                              ),
                              customTextFormField(
                                titleText: "Nomor Induk Mahasiswa (NIM)",
                                controller: viewModel.nim,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(7),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                labelText: "Nomor Induk Mahasiswa (NIM)",
                                validator: (value) =>
                                    viewModel.validateNIM(value!),
                              ),
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
                                    viewModel.validateEmail(value!),
                              ),
                              Consumer<SignUpViewModel>(
                                builder: (context, contactModel, child) {
                                  return Column(
                                    children: [
                                      customTextFormField(
                                        titleText: "Kata Sandi",
                                        controller: viewModel.password,
                                        labelText: "Kata sandi Anda",
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
                                        validator: (value) =>
                                            viewModel.validatePassword(value!),
                                      ),
                                      customTextFormField(
                                        titleText: "Konfirmasi Kata Sandi",
                                        controller: viewModel.cnfrmPassword,
                                        labelText: "Konfirmasi kata sandi Anda",
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
                                        validator: (value) =>
                                            viewModel.validatePassword(value!),
                                      ),
                                      Consumer<SignUpViewModel>(
                                        builder: (context, viewModel, child) {
                                          return customButton(
                                            text: "Daftar",
                                            fntSize: 16,
                                            height: size.height * 0.055,
                                            bgColor: const Color(0xff3853A4),
                                            onPressed: () {
                                              if (!viewModel
                                                  .formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  viewModel.showErrorMessage =
                                                      true; // Show error message
                                                });
                                              } else {
                                                setState(() {
                                                  viewModel.showErrorMessage =
                                                      false;
                                                });
                                                // Continue with login
                                              }
                                            },
                                          );
                                        },
                                      ),
                                      SizedBox(height: size.height * 0.04),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Sudah punya akun? ",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              color: Color(0xff939393),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignInScreen(),
                                                ),
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
                                  );
                                },
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
          },
        ),
      ),
    );
  }
}
