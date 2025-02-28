import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/screen/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:projectmanagementstmiktime/screen/widget/button.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late SignInViewModel viewModel;

  @override
  void initState() {
    viewModel = Provider.of<SignInViewModel>(context, listen: false);
    viewModel.clearSignInForm();
    viewModel.formKeySignin = GlobalKey<FormState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              top: size.height * 0.06,
              bottom: size.height * 0.06,
              start: size.width * 0.05,
              end: size.width * 0.05,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/logostmik2.svg"),
                SizedBox(
                  height: size.height * 0.02,
                ),
                const Text(
                  "Selamat datang kembali",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Inter",
                  ),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                const Text(
                  "Masuk untuk melanjutkan",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff939393),
                    fontFamily: "Inter",
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Consumer<SignInViewModel>(
                  builder: (context, model, child) {
                    return Column(
                      children: [
                        Form(
                          key: viewModel.formKeySignin,
                          child: Column(
                            children: [
                              const Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Text("Email",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                    )),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              customTextFormField(
                                  controller: viewModel.email,
                                  labelText: "Masukkan Email Anda",
                                  validator: (value) =>
                                      viewModel.validateEmail(value!)),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              const Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Text("Kata Sandi",
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                    )),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              customTextFormField(
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
                        SizedBox(height: size.height * 0.02),
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
                        SizedBox(height: size.height * 0.04),
                        Consumer<SignInViewModel>(
                          builder: (context, viewMode, child) {
                            return customButton(
                              height: size.height * 0.055,
                              text: "Masuk",
                              fntSize: 16,
                              bgColor: const Color(0xff3853A4),
                              onPressed: () async {
                                if (!viewModel.formKeySignin.currentState!
                                    .validate()) {
                                  setState(() {
                                    viewModel.showErrorMessage =
                                        true; // Show error message
                                  });
                                } else {
                                  setState(() {
                                    viewModel.showErrorMessage = false;
                                  });
                                  // Continue with login
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
                                    builder: (context) => const SignInScreen(),
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
      ),
    );
  }
}
