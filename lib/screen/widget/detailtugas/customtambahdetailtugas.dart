import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/button.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:provider/provider.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:quickalert/models/quickalert_type.dart';

class CustomTambahDetailCardTugas extends StatefulWidget {
  final int cardId;
  const CustomTambahDetailCardTugas({
    super.key,
    required this.cardId,
  });

  @override
  State<CustomTambahDetailCardTugas> createState() =>
      _CustomTambahDetailCardTugasState();
}

class _CustomTambahDetailCardTugasState
    extends State<CustomTambahDetailCardTugas> {
  late CardTugasViewModel cardTugasViewModel;
  late SignInViewModel sp;

  @override
  void initState() {
    super.initState();
    cardTugasViewModel =
        Provider.of<CardTugasViewModel>(context, listen: false);
    sp = Provider.of<SignInViewModel>(context, listen: false);
    final token = sp.tokenSharedPreference;
    cardTugasViewModel.cardId = widget.cardId.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cardTugasViewModel.getCardTugasList(token: token);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Tambah Tugas',
          style: TextStyle(
            color: Color(0xFF293066),
            fontFamily: 'Helvetica',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Color(0xff293066),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildFormFields(size),
      ),
    );
  }

  Widget _buildFormFields(Size size) {
    return Consumer<CardTugasViewModel>(
      builder: (context, viewModel, child) {
        return Form(
          key: viewModel.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customTextFormField(
                formTambahTugas: true,
                controller: viewModel.namaTugas,
                labelText: "Judul Tugas",
                iconPath: "assets/deskripsi.svg",
                heightIcon: size.height * 0.025,
                widthIcon: size.width * 0.025,
              ),
              customTextFormField(
                formTambahTugas: true,
                controller: viewModel.deskripsiTugas,
                maxLine: 5,
                labelText:
                    "Deskripsi tugas akan ditampilkan di sini. Anda dapat menambahkan detail lebih lanjut tentang tugas ini.",
                iconPath: "assets/deskripsi.svg",
                heightIcon: size.height * 0.025,
                widthIcon: size.width * 0.025,
              ),
              // Gunakan startTimeLabel dari ViewModel
              customFormDetailTugas(
                context: context,
                containerOnTap: () {
                  viewModel.selectStartDate(context);
                },
                listContainer: false,
                labelText: viewModel.startTimeLabel, // Gunakan getter ini
                colorText: viewModel.isStartDateSelected
                    ? Colors.black
                    : const Color(0xFFB0B0B0),
                iconPath: "assets/clock.svg",
                heightIcon: size.height * 0.025,
                widthIcon: size.width * 0.025,
              ),
              // Gunakan endTimeLabel dari ViewModel
              customFormDetailTugas(
                context: context,
                containerOnTap: () {
                  viewModel.selectEndDate(context);
                },
                listContainer: false,
                labelText: viewModel.endTimeLabel, // Gunakan getter ini
                colorText: viewModel.isEndDateSelected
                    ? Colors.black
                    : const Color(0xFFB0B0B0),
                iconPath: "assets/clock.svg",
                heightIcon: size.height * 0.025,
                widthIcon: size.width * 0.025,
              ),
              SizedBox(height: size.height * 0.02),
              customButton(
                text: "Tambah",
                height: size.height * 0.05,
                width: size.width * 0.25,
                bgColor: const Color(0xFF484F88),
                onPressed: () async {
                  final token = sp.tokenSharedPreference;

                  Navigator.pop(context); // Tutup form/modal sebelumnya

                  if (viewModel.formKey.currentState!.validate()) {
                    await customAlert(
                      alertType: QuickAlertType.loading,
                      text: "Mohon tunggu...",
                      autoClose: false,
                    );

                    try {
                      final response =
                          await viewModel.tambahTugas(token: token);

                      if (response == 200) {
                        final success =
                            await viewModel.refreshCardTugasData(token: token);

                        navigatorKey.currentState?.pop();

                        if (success) {
                          await customAlert(
                            alertType: QuickAlertType.success,
                            title: "Tugas berhasil ditambahkan!",
                          );
                          viewModel.clearForm();
                          navigatorKey.currentState?.pop();
                        } else {
                          await customAlert(
                            alertType: QuickAlertType.error,
                            text: viewModel.errorMessages,
                          );
                        }
                      } else {
                        navigatorKey.currentState?.pop();
                        await customAlert(
                          alertType: QuickAlertType.error,
                          text: "Gagal menambahkan tugas. Coba lagi nanti.",
                        );
                      }
                    } on SocketException catch (_) {
                      navigatorKey.currentState?.pop();
                      await customAlert(
                        alertType: QuickAlertType.warning,
                        text:
                            'Tidak ada koneksi internet. Periksa jaringan Anda.',
                      );
                    } catch (e) {
                      navigatorKey.currentState?.pop();
                      await customAlert(
                        alertType: QuickAlertType.error,
                        text: 'Terjadi kesalahan: ${e.toString()}',
                      );
                    }
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
