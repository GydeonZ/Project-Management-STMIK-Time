import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/cardtugas/customcard.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:provider/provider.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_card_tugas.dart'
    as model;
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomCardTugas extends StatefulWidget {
  final int boardId;

  const CustomCardTugas({super.key, required this.boardId});

  @override
  State<CustomCardTugas> createState() => _CustomCardTugasState();
}

class _CustomCardTugasState extends State<CustomCardTugas> {
  late CardTugasViewModel cardTugasViewModel;
  late SignInViewModel sp;

  @override
  void initState() {
    super.initState();
    cardTugasViewModel =
        Provider.of<CardTugasViewModel>(context, listen: false);
    sp = Provider.of<SignInViewModel>(context, listen: false);
    final token = sp.tokenSharedPreference;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cardTugasViewModel.getCardTugasList(token: token);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<CardTugasViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Skeletonizer(
            enabled: viewModel.isLoading,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, builder) {
                return customCardSkeleton(
                    context: context,
                    taskLength: 2,
                    color: Colors.grey,
                    taskColor: Colors.grey,
                    cardTitle: 'aaaaaaaa',
                    icon: false);
              },
            ),
          );
        }

        final board = viewModel.modelFetchCardTugas?.boards.firstWhere(
          (b) => b.id == widget.boardId,
          orElse: () => model.Board(
            id: 0,
            name: '',
            encryptedId: '',
            cards: [],
          ),
        );

        if (board == null || board.id == 0) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: size.height *
                  0.8, // Agar RefreshIndicator tetap bisa digunakan
              child: const Center(
                child: Text(
                  'Board tidak ditemukan',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: board.cards.length,
          itemBuilder: (context, index) {
            final card = board.cards[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          card.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '+ Tambah Task',
                                  style: const TextStyle(
                                    color: Color(0xff0088D1),
                                    fontSize: 13,
                                    fontFamily: "Helvetica",
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      viewModel.cardId = card.id.toString();
                                      final token = sp.tokenSharedPreference;
                                      customShowDialog(
                                          useForm: true,
                                          context: context,
                                          customWidget: customTextFormField(
                                            keyForm: viewModel.formKey,
                                            titleText: "Judul Tugas",
                                            controller: viewModel.namaTugas,
                                            labelText: "Masukkan Judul Tugas",
                                            validator: (value) => viewModel
                                                .validateNamaCard(value!),
                                          ),
                                          txtButtonL: "Batal",
                                          txtButtonR: "Tambah",
                                          onPressedBtnL: () {
                                            Navigator.pop(context);
                                          },
                                          onPressedBtnR: () async {
                                            Navigator.pop(
                                                context); // Tutup form/modal sebelumnya

                                            if (viewModel.formKey.currentState!
                                                .validate()) {
                                              await customAlert(
                                                alertType:
                                                    QuickAlertType.loading,
                                                text: "Mohon tunggu...",
                                                autoClose: false,
                                              );

                                              try {
                                                final response = await viewModel
                                                    .tambahTugas(token: token);

                                                if (response == 200) {
                                                  final success =
                                                      await viewModel
                                                          .refreshCardTugasData(
                                                              token: token);

                                                  navigatorKey.currentState
                                                      ?.pop();

                                                  if (success) {
                                                    await customAlert(
                                                      alertType: QuickAlertType
                                                          .success,
                                                      title:
                                                          "Tugas berhasil ditambahkan!",
                                                    );
                                                  } else {
                                                    await customAlert(
                                                      alertType:
                                                          QuickAlertType.error,
                                                      text: viewModel
                                                          .errorMessages,
                                                    );
                                                  }
                                                } else {
                                                  navigatorKey.currentState
                                                      ?.pop();
                                                  await customAlert(
                                                    alertType:
                                                        QuickAlertType.error,
                                                    text:
                                                        "Gagal menambahkan tugas. Coba lagi nanti.",
                                                  );
                                                }
                                              } on SocketException catch (_) {
                                                navigatorKey.currentState
                                                    ?.pop();
                                                await customAlert(
                                                  alertType:
                                                      QuickAlertType.warning,
                                                  text:
                                                      'Tidak ada koneksi internet. Periksa jaringan Anda.',
                                                );
                                              } catch (e) {
                                                navigatorKey.currentState
                                                    ?.pop();
                                                await customAlert(
                                                  alertType:
                                                      QuickAlertType.error,
                                                  text:
                                                      'Terjadi kesalahan: ${e.toString()}',
                                                );
                                              }
                                            }
                                          });
                                    }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    // Task List
                    Column(
                      children: List.generate(
                        card.tasks.length,
                        (taskIndex) {
                          final task = card.tasks[taskIndex];
                          return Card(
                            color: const Color(0xff293066),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(size.height * 0.013),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    task.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: "Helvetica",
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final token = sp.tokenSharedPreference;
                            customShowDialog(
                                useForm: true,
                                context: context,
                                customWidget: customTextFormField(
                                  keyForm: viewModel.formKey,
                                  titleText: "Update Judul Card",
                                  controller: viewModel.namaCard,
                                  labelText: "Masukkan Judul Card yang Baru",
                                  validator: (value) =>
                                      viewModel.validateNamaCard(value!),
                                ),
                                txtButtonL: "Batal",
                                txtButtonR: "Update",
                                onPressedBtnL: () {
                                  Navigator.pop(context);
                                },
                                onPressedBtnR: () async {
                                  Navigator.pop(context);
                                  viewModel.cardId = card.id.toString();

                                  if (viewModel.formKey.currentState!
                                      .validate()) {
                                    await customAlert(
                                      alertType: QuickAlertType.loading,
                                      text: "Mohon tunggu...",
                                      autoClose: false,
                                    );
                                    try {
                                      final response = await viewModel
                                          .updateTugasCard(token: token);

                                      if (response == 200) {
                                        final success = await viewModel
                                            .refreshCardTugasData(token: token);

                                        navigatorKey.currentState?.pop();

                                        if (success) {
                                          customAlert(
                                            alertType: QuickAlertType.success,
                                            title:
                                                "Judul Card Berhasil di Update!",
                                          );
                                        } else {
                                          customAlert(
                                            alertType: QuickAlertType.error,
                                            text: "Gagal mengupdate card. Coba lagi nanti.",
                                          );
                                        }
                                      } else {
                                        navigatorKey.currentState?.pop();
                                        customAlert(
                                          alertType: QuickAlertType.error,
                                          text:
                                              "Gagal mengupdate judul card. Coba lagi nanti.",
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
                                        text:
                                            'Terjadi kesalahan: ${e.toString()}',
                                      );
                                    }
                                  }
                                });
                          },
                          icon: SvgPicture.asset(
                            "assets/pencil.svg",
                            height: size.height * 0.025,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final token = sp.tokenSharedPreference;
                            customShowDialog(
                                useForm: false,
                                context: context,
                                text1:
                                    "Apakah anda yakin ingin menghapus card ini?",
                                text2:
                                    "Data yang sudah dihapus tidak dapat dikembalikan",
                                txtButtonL: "Batal",
                                txtButtonR: "Hapus",
                                onPressedBtnL: () {
                                  Navigator.pop(context);
                                },
                                onPressedBtnR: () async {
                                  Navigator.pop(context);
                                  viewModel.cardId = card.id.toString();

                                  final response = await viewModel
                                      .deleteTugasCard(token: token);

                                  if (!mounted) return;

                                  if (response == 200) {
                                    final success = await viewModel
                                        .refreshCardTugasData(token: token);

                                    if (!mounted) return;

                                    if (success) {
                                      customAlert(
                                        alertType: QuickAlertType.success,
                                        title: "Card berhasil dihapus!",
                                      );
                                    } else {
                                      customAlert(
                                        alertType: QuickAlertType.error,
                                        text: viewModel.errorMessages,
                                      );
                                    }
                                  } else {
                                    customAlert(
                                      alertType: QuickAlertType.error,
                                      text:
                                          "Gagal menghapus card. Coba lagi nanti.",
                                    );
                                  }
                                });
                          },
                          icon: SvgPicture.asset(
                            "assets/tongsampah.svg",
                            height: size.height * 0.025,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
