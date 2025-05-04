import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/view/member/add_anggota_board_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/botsheetaddbutton.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customcardanggota.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customdropdown.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_anggota_list_board.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_board.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BoardAnggotaTaskScreen extends StatefulWidget {
  final int? boardId;

  const BoardAnggotaTaskScreen({
    super.key,
    required this.boardId,
  });

  @override
  State<BoardAnggotaTaskScreen> createState() => _BoardAnggotaTaskScreenState();
}

class _BoardAnggotaTaskScreenState extends State<BoardAnggotaTaskScreen> {
  late BoardAnggotaListViewModel boardAnggotaListViewModel;
  late SignInViewModel sp;
  late CardTugasViewModel cardTugasViewModel;
  String? selectedLevel;

  @override
  void initState() {
    super.initState();
    cardTugasViewModel =
        Provider.of<CardTugasViewModel>(context, listen: false);
    sp = Provider.of<SignInViewModel>(context, listen: false);
    boardAnggotaListViewModel =
        Provider.of<BoardAnggotaListViewModel>(context, listen: false);

    final token = sp.tokenSharedPreference;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load card tugas data
      cardTugasViewModel.getCardTugasList(token: token);

      // Periksa apakah data anggota board sudah dimuat dan untuk board yang sama
      final isBoardAnggotaLoaded =
          boardAnggotaListViewModel.modelFetchBoardMember != null &&
              boardAnggotaListViewModel.savedBoardId ==
                  widget.boardId.toString();

      if (!isBoardAnggotaLoaded) {
        // Load board anggota data jika belum dimuat atau untuk board yang berbeda
        boardAnggotaListViewModel.setTaskId(widget.boardId.toString());
        boardAnggotaListViewModel.getBoardAnggotaList(token: token);
      }
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Member',
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
        child: Consumer<BoardAnggotaListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Column(
                children: [
                  customTextFormField(
                    controller: TextEditingController(),
                    labelText: "Pencarian",
                    prefixIcon: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Skeletonizer(
                      enabled: viewModel.isLoading,
                      child: ListView.builder(
                        itemCount: 5,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, builder) {
                          return customCardAnggotaList(
                            context: context,
                            useIcon: false,
                            namaUser: "Farhan Maulana",
                            roleUser: "Mahasiswa",
                            emailUser: "aaaaa.aaaaa@zzzzz.com",
                            nomorIndukuser: "zzzzzzzzz",
                            levelUser: "Owner",
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            final anggota = viewModel.modelFetchBoardMember?.members ?? [];
            return Column(
              children: [
                customTextFormField(
                  controller: TextEditingController(),
                  labelText: "Pencarian",
                  prefixIcon: const Icon(Icons.search),
                ),
                const SizedBox(height: 16),
                customCardAnggotaList(
                  context: context,
                  useIcon: false,
                  namaUser: viewModel.modelFetchBoardMember?.boardOwner.name,
                  roleUser: viewModel.modelFetchBoardMember?.boardOwner.role,
                  emailUser: viewModel.modelFetchBoardMember?.boardOwner.email,
                  nomorIndukuser:
                      viewModel.modelFetchBoardMember?.boardOwner.nidn,
                  levelUser: "Owner",
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: anggota.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final user = anggota[index].user;
                      return customCardAnggotaList(
                        context: context,
                        useIcon: _checkUserCanEdit(),
                        namaUser: user.name,
                        roleUser: user.role,
                        emailUser: user.email,
                        nomorIndukuser:
                            user.role == "Mahasiswa" ? user.nim : user.nidn,
                        levelUser: anggota[index].level,
                        onTapIcon: () async {
                          customShowDialog(
                            useForm: false,
                            context: context,
                            text1:
                                "Apakah anda yakin ingin menghapus user ini?",
                            txtButtonL: "Batal",
                            txtButtonR: "Hapus",
                            onPressedBtnL: () {
                              Navigator.pop(context);
                            },
                            onPressedBtnR: () async {
                              Navigator.pop(context);
                              viewModel.savedUserId = user.id.toString();
                              final token = sp.tokenSharedPreference;

                              await customAlert(
                                alertType: QuickAlertType.loading,
                                text: "Mohon tunggu...",
                                autoClose: false,
                              );
                              final response =
                                  await viewModel.deleteAnggota(token: token);
                              navigatorKey.currentState?.pop();

                              if (response == 200) {
                                final success = await viewModel
                                    .refreshAnggotaList(token: token);
                                await cardTugasViewModel.refreshTaskListById(
                                    token: token);

                                if (success) {
                                  customAlert(
                                    alertType: QuickAlertType.success,
                                    title: "Anggota berhasil dihapus!",
                                  );
                                } else {
                                  navigatorKey.currentState?.pop();
                                  customAlert(
                                    alertType: QuickAlertType.error,
                                    text: viewModel.errorMessages,
                                  );
                                }
                              } else {
                                customAlert(
                                  alertType: QuickAlertType.error,
                                  text:
                                      "Gagal menghapus Anggota. Coba lagi nanti.",
                                );
                              }
                            },
                          );
                        },
                        onTap: () {
                          selectedLevel = viewModel.selectedMemberLevel;
                          viewModel.savedUserId = user.id.toString();
                          customShowDialog(
                            context: context,
                            useForm: true,
                            customWidget:
                                StatefulBuilder(builder: (context, setState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 16),
                                  levelDropdownWidget(
                                    context,
                                    selectedLevel ?? "Member",
                                    (value) {
                                      setState(() {
                                        selectedLevel = value;
                                      });
                                    },
                                  ),
                                ],
                              );
                            }),
                            txtButtonL: "Batal",
                            txtButtonR: "Simpan",
                            onPressedBtnL: () {
                              Navigator.pop(context);
                            },
                            onPressedBtnR: () async {
                              // final token = sp.tokenSharedPreference;

                              // Navigator.pop(
                              //     context); // Tutup form/modal sebelumnya
                              // customAlert(
                              //   alertType: QuickAlertType.loading,
                              //   text: "Mohon tunggu...",
                              //   autoClose: false,
                              // );

                              // final response = await viewModel.editAnggotaList(
                              //   token: token,
                              //   level: selectedLevel,
                              // );
                              // navigatorKey.currentState?.pop();
                              // if (response == 200) {
                              //   final success = await viewModel
                              //       .refreshAnggotaList(token: token);
                              //   await cardTugasViewModel.refreshTaskListById(
                              //       token: token);
                              //   if (success) {} else {
                              //     await customAlert(
                              //       alertType: QuickAlertType.error,
                              //       text: viewModel.errorMessages,
                              //     );
                              //   }
                              // } else {
                              //   navigatorKey.currentState?.pop();
                              //   await customAlert(
                              //     alertType: QuickAlertType.error,
                              //     text:
                              //         "Gagal menambahkan tugas. Coba lagi nanti.",
                              //   );
                              // }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _checkUserCanEdit()
          ? bottomSheetAddCard(
              context: context,
              judulBtn: "Anggota",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          AddAnggotaBoardScreen(boardId: widget.boardId)),
                );
              })
          : null,
    );
  }
}
