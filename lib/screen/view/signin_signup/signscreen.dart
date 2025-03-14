import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/screen/view/board/board.dart';
import 'package:projectmanagementstmiktime/screen/view/signin_signup/signupscreen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/view_model/navigation/view_model_navigation.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:projectmanagementstmiktime/screen/widget/button.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late SignInViewModel viewModel;
  late NavigationProvider navigator;

  @override
  void initState() {
    viewModel = Provider.of<SignInViewModel>(context, listen: false);
    // viewModel.clearSignInForm();
    viewModel.formKeySignin = GlobalKey<FormState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevents overflow when keyboard appears
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsetsDirectional.only(
                top: size.height * 0.06,
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
                      SvgPicture.asset("assets/logostmik2.svg"),
                      SizedBox(height: size.height * 0.02),
                      const Text(
                        "Selamat datang kembali",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter",
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
                      const Text(
                        "Masuk untuk melanjutkan",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff939393),
                          fontFamily: "Inter",
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      Consumer<SignInViewModel>(
                        builder: (context, model, child) {
                          return Column(
                            children: [
                              Form(
                                key: viewModel.formKeySignin,
                                child: Column(
                                  children: [
                                    customTextFormField(
                                        titleText: "Email",
                                        controller: viewModel.email,
                                        labelText: "Masukkan Email Anda",
                                        validator: (value) =>
                                            viewModel.validateEmail(value!)),
                                    customTextFormField(
                                      titleText: "Password",
                                      controller: viewModel.password,
                                      labelText: "Password",
                                      obscureText: !viewModel.isPasswordVisible,
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          viewModel.togglePasswordVisibility();
                                        },
                                        child: Icon(
                                          viewModel.isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: const Color(0xFF000000),
                                        ),
                                      ),
                                      validator: (value) =>
                                          viewModel.validatePassword(value!),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Consumer<SignInViewModel>(
                                        builder: (context, model, child) {
                                          return Checkbox(
                                            value: viewModel.rememberMe,
                                            onChanged: (bool? value) {
                                              viewModel.setRememberMe(value!);
                                            },
                                            activeColor: viewModel.rememberMe
                                                ? const Color(0xFF484F88)
                                                : null,
                                          );
                                        },
                                      ),
                                      const Text(
                                        "Ingat saya",
                                        style:
                                            TextStyle(fontFamily: 'Helvetica'),
                                      ),
                                    ],
                                  ),
                                  const Align(
                                    alignment: Alignment(1, 0),
                                    child: Text(
                                      "Lupa Password?",
                                      style: TextStyle(
                                        color: Color(0xff0088D1),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Inter",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.04),
                              Consumer<SignInViewModel>(
                                builder: (context, viewModel, child) {
                                  return customButton(
                                    text: "Masuk",
                                    bgColor: const Color(0xFF484F88),
                                    onPressed: () async {
                                      if (viewModel.formKeySignin.currentState!
                                          .validate()) {
                                        await viewModel.signIn();
                                        if (viewModel.isSuksesLogin == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const BoardScreen(),
                                            ),
                                          );

                                          viewModel.email.clear();
                                          viewModel.password.clear();
                                          viewModel.isSuksesLogin = false;
                                        } else {
                                          customAlert(
                                            context: context,
                                            alertType: QuickAlertType.error,
                                            text:
                                                'Gagal login, mohon periksa email atau kata sandi Anda.',
                                          );
                                        }
                                        await viewModel
                                            .saveDataSharedPreferences();
                                        if (viewModel.rememberMe) {
                                          viewModel.logindata
                                              .setBool('login', true);
                                        }
                                      }
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: size.height * 0.04),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Tidak punya akun? ",
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
                                              const SignUpScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Daftar",
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
            );
          },
        ),
      ),
    );
  }
}
