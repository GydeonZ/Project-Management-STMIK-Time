// ignore_for_file: must_be_immutable, sort_child_properties_last

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/settings/text_field_setting.dart';
import 'package:projectmanagementstmiktime/screen/widget/settings/text_title_text_field.dart';
import 'package:projectmanagementstmiktime/view_model/profile/view_model_profile.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late ProfileViewModel viewModel;
  late SignInViewModel sp;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    sp = Provider.of<SignInViewModel>(context, listen: false);
    viewModel.awal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accessToken = sp.tokenSharedPreference;
    Size size = MediaQuery.of(context).size;
    TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ubah Profile',
          style: TextStyle(
            color: Color(0xff293066),
            fontFamily: 'Helvetica',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff293066),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        height: size.height * 1.1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Consumer<SignInViewModel>(
                builder: (context, contactModel, child) {
                  String initials = contactModel.nameSharedPreference.isNotEmpty
                      ? contactModel.nameSharedPreference
                          .substring(0, 2)
                          .toUpperCase()
                      : "??";
                  return SizedBox(
                    width: size.width * 0.25,
                    height: size.width * 0.25,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xff293066),
                      child: Text(
                        initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 35),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: size.height * 0.06),
              Consumer<ProfileViewModel>(
                builder: (context, contactModel, child) {
                  return Form(
                    key: formKey,
                    child: Column(
                      children: [
                        textSetting(text: "Fullname"),
                        textFieldSetting(
                          controller: viewModel.fullNameController,
                          enable: viewModel.isEdit,
                          fill: viewModel.isEdit
                              ? Colors.white
                              : const Color.fromARGB(130, 158, 158, 158),
                          colorhintext: viewModel.isEdit
                              ? const Color(0xFF999999)
                              : Colors.black,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<ProfileViewModel>(
                builder: (context, viewModel, child) {
                  return Row(
                    mainAxisAlignment: viewModel.isEdit
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          viewModel.enable();
                          viewModel.fullNameController.clear();
                        },
                        child:
                            Text(viewModel.isEdit ? "Batal" : "Edit Profile"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              viewModel.isEdit ? Colors.red : Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (viewModel.isEdit)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (formKey.currentState!.validate()) {
                              customAlert(
                                alertType: QuickAlertType.loading,
                                text: "Mohon Tunggu...",
                                autoClose: false,
                              );
                              try {
                                final statusCode =
                                    await viewModel.changeProfile(
                                        token: accessToken,
                                        signInViewModel: sp);
                                navigatorKey.currentState?.pop();
                                if (statusCode == 200) {
                                  customAlert(
                                    alertType: QuickAlertType.success,
                                    title: "Berhasil...\n",
                                    text: viewModel.successMessage ??
                                        "Nama berhasil diperbarui!",
                                  );
                                  navigatorKey.currentState?.pop();
                                } else {
                                  customAlert(
                                    alertType: QuickAlertType.error,
                                    text: "Terjadi kesalahan. Coba lagi nanti.",
                                  );
                                }
                              } on SocketException {
                                customAlert(
                                  alertType: QuickAlertType.warning,
                                  text:
                                      'Tidak ada koneksi internet. Periksa jaringan Anda.',
                                );
                              } catch (e) {
                                customAlert(
                                  alertType: QuickAlertType.error,
                                  text: 'Terjadi kesalahan: ${e.toString()}',
                                );
                              }
                            }
                          },
                          child: const Text("Simpan"),
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
  }
}
