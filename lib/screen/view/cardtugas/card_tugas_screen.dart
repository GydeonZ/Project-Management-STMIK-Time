import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/botsheetaddbutton.dart';
import 'package:projectmanagementstmiktime/screen/widget/cardtugas/card_tugas.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_board.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';

class CardTugasScreen extends StatefulWidget {
  final int boardId;
  const CardTugasScreen({super.key, required this.boardId});

  @override
  State<CardTugasScreen> createState() => _CardTugasScreenState();
}

class _CardTugasScreenState extends State<CardTugasScreen> {
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

  bool _checkUserCanEdit() {
    // Mendapatkan user ID dari SharedPreferences
    final currentUserId = sp.idSharedPreference;

    // Mendapatkan board view model
    final boardVm = Provider.of<BoardViewModel>(context, listen: false);

    // Menggunakan fungsi yang baru dibuat
    return boardVm.checkUserCanEditBoardById(widget.boardId, currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    final bool canEdit = _checkUserCanEdit();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Card',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await cardTugasViewModel.getCardTugasList(
                        token: sp.tokenSharedPreference);
                  },
                  child: CustomCardTugas(boardId: widget.boardId),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            Consumer<CardTugasViewModel>(builder: (context, viewModel, child) {
          if (!canEdit) {
            return const SizedBox.shrink();
          }
          return bottomSheetAddCard(
            context: context,
            judulBtn: "Tugas",
            onTap: () {
              final token = sp.tokenSharedPreference;
              customShowDialog(
                  useForm: true,
                  context: context,
                  customWidget: customTextFormField(
                    keyForm: viewModel.formKey,
                    titleText: "Judul Card",
                    controller: viewModel.namaCard,
                    labelText: "Masukkan Judul Card",
                    validator: (value) => viewModel.validateNamaCard(value!),
                  ),
                  txtButtonL: "Batal",
                  txtButtonR: "Tambah",
                  onPressedBtnL: () {
                    Navigator.pop(context);
                  },
                  onPressedBtnR: () async {
                    Navigator.pop(context); // Tutup form/modal sebelumnya

                    if (viewModel.formKey.currentState!.validate()) {
                      await customAlert(
                        alertType: QuickAlertType.loading,
                        text: "Mohon tunggu...",
                        autoClose: false,
                      );

                      try {
                        final response =
                            await viewModel.tambahTugasCard(token: token);

                        if (response == 200) {
                          final success = await viewModel.refreshCardTugasData(
                              token: token);

                          navigatorKey.currentState?.pop();

                          if (success) {
                            await customAlert(
                              alertType: QuickAlertType.success,
                              title: "Card berhasil ditambahkan!",
                            );
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
                            text: "Gagal menambahkan card. Coba lagi nanti.",
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
                              'Terjadi kesalahan, Coba lagi beberapa saat lagi',
                        );
                      }
                    }
                  });
            },
          );
        }));
  }
}
