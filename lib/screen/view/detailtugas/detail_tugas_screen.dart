import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customdetailtugas.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/utils/state/finite_state.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_anggota_list.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';

class DetailTugasScreen extends StatefulWidget {
  final int boardId;
  final int taskId;

  const DetailTugasScreen({
    super.key,
    required this.boardId,
    required this.taskId,
  });

  @override
  State<DetailTugasScreen> createState() => _DetailTugasScreenState();
}

class _DetailTugasScreenState extends State<DetailTugasScreen> {
  late CardTugasViewModel cardTugasViewModel;
  late SignInViewModel sp;

  @override
  void initState() {
    super.initState();
    sp = Provider.of<SignInViewModel>(context, listen: false);
    cardTugasViewModel =
        Provider.of<CardTugasViewModel>(context, listen: false);
    cardTugasViewModel.savedTaskId = widget.taskId.toString();
    final token = sp.tokenSharedPreference;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set the taskId in the viewModel
      if (widget.taskId != 0) {
        // Set task ID for both view models
        cardTugasViewModel.setTaskId(widget.taskId.toString());

        // Fetch task details using the dedicated method
        cardTugasViewModel.getTaskListById(token: token);

        // Also fetch the anggota list to get the board owner
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool canEdit = _checkUserCanEdit();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Detail Tugas',
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
        actions: [
          if (canEdit) ...[
            Consumer<CardTugasViewModel>(builder: (context, viewModel, child) {
              return Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/pencil.svg",
                      height: size.height * 0.025,
                    ),
                    onPressed: () {
                      final token = sp.tokenSharedPreference;
                      customShowDialog(
                          useForm: true,
                          context: context,
                          customWidget: customTextFormField(
                            keyForm: viewModel.formKey,
                            titleText: "Update Judul Tugas",
                            controller: viewModel.namaTugas,
                            labelText: "Masukkan Judul Tugas yang Baru",
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

                            if (viewModel.formKey.currentState!.validate()) {
                              await customAlert(
                                alertType: QuickAlertType.loading,
                                text: "Mohon tunggu...",
                                autoClose: false,
                              );
                              try {
                                final response = await viewModel
                                    .updateJudulTugas(token: token);

                                if (response == 200) {
                                  final success = await viewModel
                                      .refreshTaskListById(token: token);

                                  navigatorKey.currentState?.pop();

                                  if (success) {
                                    await viewModel.refreshCardTugasData(
                                        token: token);
                                  } else {
                                    customAlert(
                                      alertType: QuickAlertType.error,
                                      text:
                                          "Gagal mengupdate card. Coba lagi nanti.",
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
                                  text: 'Terjadi kesalahan: ${e.toString()}',
                                );
                              }
                            }
                          });
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/tongsampah.svg",
                      height: size.height * 0.025,
                    ),
                    onPressed: () {
                      final token = sp.tokenSharedPreference;
                      customShowDialog(
                          useForm: false,
                          context: context,
                          text1: "Apakah anda yakin ingin menghapus Tugas ini?",
                          text2:
                              "Tugas yang sudah dihapus tidak dapat dikembalikan",
                          txtButtonL: "Batal",
                          txtButtonR: "Hapus",
                          onPressedBtnL: () {
                            Navigator.pop(context);
                          },
                          onPressedBtnR: () async {
                            Navigator.pop(context);
                            // viewModel.cardId = card.id.toString();

                            await customAlert(
                              alertType: QuickAlertType.loading,
                              text: "Mohon tunggu...",
                              autoClose: false,
                            );
                            final response =
                                await viewModel.deleteDetailTugas(token: token);
                            navigatorKey.currentState?.pop();

                            if (response == 200) {
                              navigatorKey.currentState?.pop();
                              final success = await viewModel
                                  .refreshCardTugasData(token: token);

                              if (success) {
                              } else {
                                customAlert(
                                  alertType: QuickAlertType.error,
                                  text: viewModel.errorMessages,
                                );
                              }
                            } else {
                              navigatorKey.currentState?.pop();
                              customAlert(
                                alertType: QuickAlertType.error,
                                text:
                                    "Gagal menghapus Detail Tugas. Coba lagi nanti.",
                              );
                            }
                          });
                    },
                  ),
                ],
              );
            })
          ],
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomDetailCardTugas(
          boardId: widget.boardId,
          taskId: widget.taskId,
        ),
      ),
    );
  }

  bool _checkUserCanEdit() {
    // Get the current user ID from SharedPreferences
    final userIdStr = sp.idSharedPreference;
    final currentUserId = userIdStr;

    if (currentUserId == 0) {
      return false;
    }

    // Get anggota list view model
    final anggotaViewModel =
        Provider.of<AnggotaListViewModel>(context, listen: false);

    // If anggota list is not loaded yet or is empty, default to false
    if (anggotaViewModel.modelAnggotaList == null) {
      return false;
    }

    // Check the user role using the existing method in AnggotaListViewModel
    final userRole = anggotaViewModel.getUserRoleFromAnggota(
        anggotaViewModel.modelAnggotaList!, currentUserId);
    // Define which roles can edit - Owner and Admin can edit
    final canEdit =
        userRole == RoleUserInBoard.owner || userRole == RoleUserInBoard.admin;
    return canEdit;
  }
}
