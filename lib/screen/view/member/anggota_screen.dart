import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/view/member/add_anggota_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/botsheetaddbutton.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customcardanggota.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customdropdown.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/utils/state/finite_state.dart';
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

    final token = sp.tokenSharedPreference;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.taskId != null) {
        anggotaListViewModel.setTaskId(widget.taskId.toString());
        anggotaListViewModel.getAnggotaList(token: token);
        cardTugasViewModel.getCardTugasList(token: token);
      }
    });
  }

  @override
  void dispose() {
    anggotaListViewModel.searchController.dispose();
    super.dispose();
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

            // Owner tidak termasuk dalam hasil pencarian
            final boardOwner = viewModel.modelAnggotaList?.boardOwner;

            // Menggunakan hasil filter dari ViewModel
            final filteredMembers = viewModel.filteredBoardMembers;

            // Jika pencarian tidak kosong dan hasilnya kosong, tampilkan pesan
            final bool showNoResults =
                viewModel.searchQueryForMembers.isNotEmpty &&
                    filteredMembers.isEmpty;

            return Column(
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

                // Owner card selalu muncul jika pencarian kosong
                if (viewModel.searchQueryForMembers.isEmpty &&
                    boardOwner != null)
                  customCardAnggotaList(
                    context: context,
                    useIcon: false,
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
                  Expanded(
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
                            style: const TextStyle(
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredMembers.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final member = filteredMembers[index];
                        final user = member.user;
                        return customCardAnggotaList(
                          context: context,
                          useIcon: _checkUserCanEdit(),
                          namaUser: user.name,
                          roleUser: user.role,
                          emailUser: user.email,
                          nomorIndukuser:
                              user.role == "Mahasiswa" ? user.nim : user.nidn,
                          levelUser: member.level,
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
                                  await cardTugasViewModel.refreshTaskListById(
                                      token: token);
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
                                        "Gagal menambahkan tugas. Coba lagi nanti.",
                                  );
                                }
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
                      builder: (_) => AddAnggotaScreen(taskId: widget.taskId)),
                );
              })
          : null,
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
