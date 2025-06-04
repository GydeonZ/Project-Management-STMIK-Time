import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // Get the current user ID from SharedPreferences
    final currentUserId = sp.idSharedPreference;

    // Check if user is a Super Admin (they can edit anything)
    if (sp.roleSharedPreference.toLowerCase() == "super admin") {
      return true;
    }

    // Get the board view model
    final boardVm = Provider.of<BoardViewModel>(context, listen: false);

    // Check user permissions for this specific board
    return boardVm.canUserEditBoardById(widget.boardId, currentUserId,
        userRole: sp.roleSharedPreference);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Member',
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
            boardAnggotaListViewModel.clearSearch();
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
                            canEdit: false,
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
            // Owner tidak termasuk dalam hasil pencarian
            final boardOwner = viewModel.modelFetchBoardMember?.boardOwner;

            // Menggunakan hasil filter dari ViewModel
            final filteredMembers = viewModel.filteredBoardMembers;

            // Jika pencarian tidak kosong dan hasilnya kosong, tampilkan pesan
            final bool showNoResults =
                viewModel.searchQueryForMembers.isNotEmpty &&
                    filteredMembers.isEmpty;

            return RefreshIndicator(
              onRefresh: () async {
                final token = sp.tokenSharedPreference;
                await viewModel.refreshAnggotaList(token: token);
                return;
              },
              child: Column(
                children: [
                  customTextFormField(
                    controller: viewModel.searchController,
                    labelText: "Pencarian",
                    prefixIcon: const Icon(Icons.search),
                    onChanged: (value) {
                      // Panggil search dari ViewModel
                      viewModel.searchBoardMembers(value);
                    },
                    suffixIcon: viewModel.searchQueryForMembers.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              viewModel.searchController.clear();
                              viewModel.clearBoardMemberSearch();
                            },
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        if (viewModel.searchQueryForMembers.isEmpty &&
                            boardOwner != null)
                          customCardAnggotaList(
                            context: context,
                            canEdit: false,
                            namaUser: boardOwner.name,
                            roleUser: boardOwner.role,
                            emailUser: boardOwner.email,
                            nomorIndukuser: boardOwner.nidn,
                            levelUser: "Owner",
                          ),
                        if (viewModel.searchQueryForMembers.isEmpty)
                          const SizedBox(height: 16),

                        if (showNoResults)
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Tidak ada member yang cocok dengan '${viewModel.searchQueryForMembers}'",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.figtree(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // List hasil pencarian member
                        if (!showNoResults)
                          if (!showNoResults)
                            ...filteredMembers.map((member) {
                              final user = member.user;
                              return customCardAnggotaList(
                                context: context,
                                canEdit: _checkUserCanEdit() &&
                                    user.id != sp.idSharedPreference &&
                                    user.role != "Super Admin",
                                namaUser: user.name,
                                roleUser: user.role,
                                emailUser: user.email,
                                nomorIndukuser: user.role == "Mahasiswa"
                                    ? user.nim
                                    : user.nidn,
                                levelUser: user.role == "Super Admin"
                                    ? "Super Admin"
                                    : member.level,
                                onTapIcon: () async {
                                  // Existing delete functionality
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
                                      viewModel.savedUserId =
                                          user.id.toString();
                                      final token = sp.tokenSharedPreference;

                                      await customAlert(
                                        alertType: QuickAlertType.loading,
                                        text: "Mohon tunggu...",
                                        autoClose: false,
                                      );
                                      final response = await viewModel
                                          .deleteAnggota(token: token);
                                      navigatorKey.currentState?.pop();

                                      if (response == 200) {
                                        await viewModel.refreshAnggotaList(
                                            token: token);
                                        navigatorKey.currentState?.pop();

                                        //   if (success) {
                                        //     customAlert(
                                        //     alertType: QuickAlertType.success,
                                        //     title: "Anggota berhasil dihapus!",
                                        //   );
                                        //   } else {
                                        //   navigatorKey.currentState?.pop();
                                        //   customAlert(
                                        //     alertType: QuickAlertType.error,
                                        //     text: viewModel.errorMessages,
                                        //   );
                                        // }
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
                                  // Existing edit functionality
                                  selectedLevel = viewModel.selectedMemberLevel;
                                  viewModel.savedUserId = user.id.toString();
                                  customShowDialog(
                                    context: context,
                                    useForm: true,
                                    customWidget: StatefulBuilder(
                                        builder: (context, setState) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                      final token = sp.tokenSharedPreference;

                                      Navigator.pop(
                                          context); // Tutup form/modal sebelumnya
                                      customAlert(
                                        alertType: QuickAlertType.loading,
                                        text: "Mohon tunggu...",
                                        autoClose: false,
                                      );

                                      final response =
                                          await viewModel.editAnggotaRole(
                                        token: token,
                                        level: selectedLevel,
                                      );
                                      navigatorKey.currentState?.pop();
                                      if (response == 200) {
                                        await viewModel.refreshAnggotaList(
                                            token: token);
                                      } else {
                                        navigatorKey.currentState?.pop();
                                        await customAlert(
                                          alertType: QuickAlertType.error,
                                          text:
                                              "Gagal mengubah role. Coba lagi nanti.",
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
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
