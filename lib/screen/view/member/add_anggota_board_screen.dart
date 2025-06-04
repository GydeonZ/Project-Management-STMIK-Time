import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customcardanggota.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customdropdown.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_anggota_list_board.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddAnggotaBoardScreen extends StatefulWidget {
  final int? boardId;
  const AddAnggotaBoardScreen({super.key, required this.boardId});

  @override
  State<AddAnggotaBoardScreen> createState() => _AddAnggotaBoardScreenState();
}

class _AddAnggotaBoardScreenState extends State<AddAnggotaBoardScreen> {
  late BoardAnggotaListViewModel boardAnggotaListViewModel;
  late CardTugasViewModel cardTugasViewModel;
  late SignInViewModel sp;
  String? selectedLevel;

  @override
  void initState() {
    super.initState();
    boardAnggotaListViewModel =
        Provider.of<BoardAnggotaListViewModel>(context, listen: false);
    sp = Provider.of<SignInViewModel>(context, listen: false);
    cardTugasViewModel =
        Provider.of<CardTugasViewModel>(context, listen: false);

    final token = sp.tokenSharedPreference;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.boardId != null) {
        boardAnggotaListViewModel.setTaskId(widget.boardId.toString());

        // Reset search state saat screen dibuka
        boardAnggotaListViewModel.clearSearch();

        // Load available members
        boardAnggotaListViewModel
            .getAvailableBoardAnggotaList(token: token)
            .then((_) {});

        cardTugasViewModel.getCardTugasList(token: token);
      }
    });
  }

  // No need for dispose method since controller is managed by ViewModel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Tambah Anggota',
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
        child: Consumer<BoardAnggotaListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Column(
                children: [
                  customTextFormField(
                    controller:
                        TextEditingController(), // Use ViewModel's controller
                    labelText: "Pencarian",
                    prefixIcon: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Skeletonizer(
                      enabled: true,
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

            // Use filteredMembers from viewModel
            final filteredUsers = viewModel.filteredMembers;

            return Column(
              children: [
                customTextFormField(
                  controller: viewModel.searchController,
                  labelText: "Pencarian",
                  prefixIcon: const Icon(Icons.search),
                  // Tambahkan onChanged callback untuk memastikan pencarian terpanggil
                  onChanged: (value) {
                    // Panggil searchAvailableMembers secara eksplisit saat text berubah
                    viewModel.searchAvailableMembers(value);
                  },
                  suffixIcon: viewModel.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            viewModel.clearSearch();
                          },
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredUsers.isEmpty
                      ? Center(
                          child: Text(
                            "Tidak ada anggota yang sesuai dengan pencarian",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.figtree(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredUsers.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return customCardAnggotaList(
                              addAnggota: true,
                              context: context,
                              canEdit: false,
                              namaUser: user.name,
                              onTap: () {
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
                                  txtButtonR: "Tambah",
                                  onPressedBtnL: () {
                                    viewModel.savedUserId = "";
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
                                        await viewModel.tambahAnggotaList(
                                      token: token,
                                      level: selectedLevel,
                                    );
                                    navigatorKey.currentState?.pop();
                                    if (response == 200) {
                                      final success = await viewModel.refreshAnggotaList(
                                          token: token);
                                      navigatorKey.currentState?.pop();

                                      if (success) {
                                        await customAlert(
                                          alertType: QuickAlertType.success,
                                          title:
                                              "Anggota berhasil ditambahkan!",
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
    );
  }
}
