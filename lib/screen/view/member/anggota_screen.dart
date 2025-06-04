import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/view/member/add_anggota_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/botsheetaddbutton.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customcardanggota.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customdropdown.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_anggota_list.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnggotaTaskScreen extends StatefulWidget {
  final int? taskId;

  const AnggotaTaskScreen({
    super.key,
    required this.taskId,
  });

  @override
  State<AnggotaTaskScreen> createState() => _AnggotaTaskScreenState();
}

class _AnggotaTaskScreenState extends State<AnggotaTaskScreen> {
  late AnggotaListViewModel anggotaListViewModel;
  late SignInViewModel sp;
  late CardTugasViewModel cardTugasViewModel;
  String? selectedLevel;

  @override
  void initState() {
    super.initState();
    anggotaListViewModel =
        Provider.of<AnggotaListViewModel>(context, listen: false);
    sp = Provider.of<SignInViewModel>(context, listen: false);
    cardTugasViewModel =
        Provider.of<CardTugasViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set task ID untuk viewModel
      final String taskIdString = widget.taskId.toString();
      anggotaListViewModel.setTaskId(taskIdString);

      // Periksa apakah datanya sudah ada dan valid
      if (anggotaListViewModel.modelAnggotaList == null ||
          anggotaListViewModel.lastFetchedTaskId != taskIdString) {
        // Hanya fetch jika data belum ada atau taskId berbeda
        final token = sp.tokenSharedPreference;
        anggotaListViewModel.getAnggotaList(token: token);
      } else {
        // Data sudah ada, pastikan UI yang ditampilkan up to date
        anggotaListViewModel.loadCachedAnggotaList();
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
    final taskVm = Provider.of<CardTugasViewModel>(context, listen: false);

    // Check user permissions for this specific board
    return taskVm.canUserEditTaskById(widget.taskId, currentUserId,
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
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AnggotaListViewModel>(
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
            final boardOwner = viewModel.modelAnggotaList?.boardOwner;

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
              color: const Color(0xFF293066), // Warna sesuai tema
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

                  // Semua konten lain dalam scrollable container
                  Expanded(
                    child: ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(), // Penting untuk refresh
                      children: [
                        // Owner card selalu muncul jika pencarian kosong
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

                        // Tampilkan pesan jika hasil pencarian kosong
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
                                    viewModel.savedUserId = user.id.toString();
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
                                      final success = await viewModel
                                          .refreshAnggotaList(token: token);
                                      await cardTugasViewModel
                                          .refreshTaskListById(token: token);

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
                                        await viewModel.editAnggotaList(
                                      token: token,
                                      level: selectedLevel,
                                    );
                                    navigatorKey.currentState?.pop();
                                    if (response == 200) {
                                      final success = await viewModel
                                          .refreshAnggotaList(token: token);
                                      await cardTugasViewModel
                                          .refreshTaskListById(token: token);
                                      if (success) {
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
                    builder: (_) => AddAnggotaScreen(taskId: widget.taskId),
                  ),
                ).then((refreshNeeded) async {
                  if (refreshNeeded == true) {
                    // User menekan tombol close atau ada perubahan data
                    // Refresh data anggota untuk memastikan UI up-to-date
                    final token = sp.tokenSharedPreference;
                    await anggotaListViewModel.refreshAnggotaList(token: token);
                  }
                });
              },
            )
          : null,
    );
  }
}
