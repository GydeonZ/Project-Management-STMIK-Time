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
      // Set the taskId in the viewModel
      if (widget.taskId != null) {
        anggotaListViewModel.setTaskId(widget.taskId.toString());
        // Fetch task details using the dedicated method
        anggotaListViewModel.getAnggotaList(token: token);
        cardTugasViewModel.getCardTugasList(token: token);
      }
    });
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
            final anggota = viewModel.modelAnggotaList?.members ?? [];
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
                  namaUser: viewModel.modelAnggotaList?.boardOwner.name,
                  roleUser: viewModel.modelAnggotaList?.boardOwner.role,
                  emailUser: viewModel.modelAnggotaList?.boardOwner.email,
                  nomorIndukuser: viewModel.modelAnggotaList?.boardOwner.nidn,
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
                          selectedLevel = anggota[index].level;
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
                                    selectedLevel ?? anggota[index].level,
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
                              // level: selectedLevel!, getter untuk role
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
