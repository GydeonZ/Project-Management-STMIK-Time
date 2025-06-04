import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customdetailtugas.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/textfield_widget.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_comment.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';

class DetailTugasScreen extends StatefulWidget {
  // final int boardId;
  final int taskId;

  const DetailTugasScreen({
    super.key,
    // required this.boardId,
    required this.taskId,
  });

  @override
  State<DetailTugasScreen> createState() => _DetailTugasScreenState();
}

class _DetailTugasScreenState extends State<DetailTugasScreen> {
  late CardTugasViewModel cardTugasViewModel;
  late SignInViewModel sp;
  late CommentViewModel commentViewModel;

  @override
  void initState() {
    super.initState();
    sp = Provider.of<SignInViewModel>(context, listen: false);
    cardTugasViewModel =
        Provider.of<CardTugasViewModel>(context, listen: false);
    commentViewModel = Provider.of<CommentViewModel>(context, listen: false);
    cardTugasViewModel.savedTaskId = widget.taskId.toString();

    // Gunakan flag untuk mencegah fetch berulang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Hanya fetch jika belum ada data atau task ID berbeda
      if (cardTugasViewModel.modelFetchTaskId == null ||
          cardTugasViewModel.modelFetchTaskId!.task.id != widget.taskId) {
        final token = sp.tokenSharedPreference;
        cardTugasViewModel.getTaskListById(token: token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Consumer<CardTugasViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading || viewModel.modelFetchTaskId == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Evaluasi canEdit hanya setelah data tersedia
          bool canEdit = _checkUserCanEdit();

          return Scaffold(
            appBar: _buildAppBar(canEdit, size),
            body: RefreshIndicator(
              onRefresh: () async {
                final token = sp.tokenSharedPreference;
                await viewModel.refreshTaskListById(token: token);
              },
              color: const Color(0xFF293066),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomDetailCardTugas(
                  taskId: widget.taskId,
                ),
              ),
            ),
            bottomNavigationBar: RoundedTextField(
                controller: commentViewModel.commentController,
                taskId: widget.taskId),
          );
        },
      ),
    );
  }

  // Ekstrak AppBar ke method terpisah
  PreferredSizeWidget _buildAppBar(bool canEdit, Size size) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        'Detail Tugas',
        style: GoogleFonts.figtree(
          color: const Color(0xFF293066),
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
            return PopupMenuButton<String>(
              icon: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.more_vert,
                  color: Color(0xff293066),
                ),
              ),
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                if (value == 'edit') {
                  // Edit action
                  final token = sp.tokenSharedPreference;
                  customShowDialog(
                    useForm: true,
                    context: context,
                    customWidget: customTextFormField(
                      keyForm: viewModel.formKey,
                      titleText: "Update Judul Tugas",
                      controller: viewModel.namaTugas,
                      labelText: "Masukkan Judul Tugas yang Baru",
                      validator: (value) => viewModel.validateNamaCard(value!),
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
                          final response =
                              await viewModel.updateJudulTugas(token: token);

                          if (response == 200) {
                            final success = await viewModel.refreshTaskListById(
                                token: token);
                            navigatorKey.currentState?.pop();

                            if (success) {
                              await viewModel.refreshCardTugasData(
                                  token: token);
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
                        } catch (e) {
                          navigatorKey.currentState?.pop();
                          await customAlert(
                            alertType: QuickAlertType.error,
                            text: 'Terjadi kesalahan Silahkan Coba lagi nanti',
                          );
                        }
                      }
                    },
                  );
                } else if (value == 'dupe') {
                  try {
                    final response = await viewModel.dupeTask(
                        token: sp.tokenSharedPreference);
                    navigatorKey.currentState?.pop();

                    if (response == 200) {
                      // Refresh task data to show updated checklists
                      await viewModel.refreshCardTugasData(
                        token: sp.tokenSharedPreference,
                      );
                    } else {
                      customAlert(
                        alertType: QuickAlertType.error,
                        text: viewModel.errorMessages ??
                            "Gagal Menghapus Notifikasi",
                      );
                    }
                  } catch (e) {
                    navigatorKey.currentState?.pop();
                    customAlert(
                      alertType: QuickAlertType.error,
                      text: "Terjadi kesalahan Silahkan Coba Lagi",
                    );
                  }
                } else if (value == 'delete') {
                  // Delete action
                  final token = sp.tokenSharedPreference;
                  customShowDialog(
                    useForm: false,
                    context: context,
                    text1: "Apakah anda yakin ingin menghapus Tugas ini?",
                    text2: "Tugas yang sudah dihapus tidak dapat dikembalikan",
                    txtButtonL: "Batal",
                    txtButtonR: "Hapus",
                    onPressedBtnL: () {
                      Navigator.pop(context);
                    },
                    onPressedBtnR: () async {
                      Navigator.pop(context);

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
                        await viewModel.refreshCardTugasData(token: token);
                      } else {
                        customAlert(
                          alertType: QuickAlertType.error,
                          text:
                              "Gagal menghapus Detail Tugas. Coba lagi nanti.",
                        );
                      }
                    },
                  );
                } else if (value == 'move') {
                  // Add "Pindah" functionality
                  // Add implementation for moving the task
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/pencil.svg",
                        height: size.height * 0.02,
                        colorFilter: const ColorFilter.mode(
                          Colors.blue,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Ubah',
                        style: GoogleFonts.figtree(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'dupe',
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/dupe.svg",
                        height: size.height * 0.02,
                        colorFilter: const ColorFilter.mode(
                          Colors.green,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Duplikat',
                        style: GoogleFonts.figtree(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/tongsampah.svg",
                        height: size.height * 0.02,
                        colorFilter: const ColorFilter.mode(
                          Colors.red,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Hapus',
                        style: GoogleFonts.figtree(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  bool _checkUserCanEdit() {
    // Jika sp belum dimuat, kembalikan false

    // Untuk Super Admin, selalu berikan akses edit
    if (sp.roleSharedPreference.toLowerCase() == "super admin") {
      return true;
    }

    // Jika data task belum sepenuhnya dimuat, return false sementara
    if (cardTugasViewModel.modelFetchTaskId == null) {
      return false;
    }

    final currentUserId = sp.idSharedPreference;
    final task = cardTugasViewModel.modelFetchTaskId!.task;
    final boardOwner = cardTugasViewModel.modelFetchTaskId!.boardOwner;

    // Gunakan canUserEditTask yang lebih lengkap
    return cardTugasViewModel.canUserEditTask(task, boardOwner, currentUserId);
  }
}
