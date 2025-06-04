import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/view/cardtugas/card_tugas_screen.dart';
import 'package:projectmanagementstmiktime/screen/view/member/board_anggota_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/boardbottomsheet.dart';
import 'package:projectmanagementstmiktime/screen/widget/board/card_board.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customdropdown.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_board.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  BoardViewModel? boardViewModel;
  SignInViewModel? sp;
  SharedPreferences? logindata;
  bool isInitialized = false;
  String? selectedVisibility;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      logindata = await SharedPreferences.getInstance();

      if (!mounted) return;

      sp = Provider.of<SignInViewModel>(context, listen: false);
      boardViewModel = Provider.of<BoardViewModel>(context, listen: false);

      final token = sp!.tokenSharedPreference;
      sp!.setSudahLogin();
      await boardViewModel!.getBoardList(token: token);

      if (mounted) {
        setState(() {
          isInitialized = true;
        });
      }
    } catch (e) {
      // print("Error initializing data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // Tutup keyboard saat tap di mana pun di layar
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Consumer<SignInViewModel>(
            builder: (context, contactModel, child) {
              return Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: Text(
                  "Hello ${contactModel.nameSharedPreference}!",
                  style: GoogleFonts.figtree(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              );
            },
          ),
          actions: [
            Consumer<SignInViewModel>(
              builder: (context, contactModel, child) {
                String initials = contactModel.nameSharedPreference.isNotEmpty
                    ? contactModel.nameSharedPreference
                        .substring(0, 2)
                        .toUpperCase()
                    : "??"; // Default jika kosong

                return Padding(
                  padding: EdgeInsets.only(top: size.height * 0.02),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      initials,
                      style: GoogleFonts.figtree(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (sp != null && boardViewModel != null) {
              await boardViewModel!
                  .refreshBoardList(token: sp!.tokenSharedPreference);
              // Re-apply search filter jika ada
              if (boardViewModel!.searchQuery.isNotEmpty) {
                boardViewModel!.searchBoards(boardViewModel!.searchQuery);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ganti bagian customTextFormField dengan Consumer
                Consumer<BoardViewModel>(
                  builder: (context, viewModel, child) {
                    return customTextFormField(
                      controller: viewModel
                          .searchController, // Tidak perlu ?. karena sudah pasti non-null
                      labelText: "Pencarian",
                      prefixIcon: const Icon(Icons.search),
                      onChanged: (value) {
                        viewModel.searchBoards(value);
                      },
                      suffixIcon: viewModel.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                viewModel.clearSearch();
                              },
                            )
                          : null,
                    );
                  },
                ),
                Consumer<BoardViewModel>(
                    builder: (context, boardViewModel, child) {
                  return Text(
                    "Tugas Anda pada hari ${boardViewModel.tanggalTerformat}",
                    style:
                        GoogleFonts.figtree(fontSize: 14, color: Colors.grey),
                  );
                }),
                const SizedBox(height: 16),
                Expanded(
                  child: Consumer<BoardViewModel>(
                    builder: (context, boardViewModel, child) {
                      if (boardViewModel.isLoading) {
                        return Skeletonizer(
                            enabled: boardViewModel.isLoading,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.2,
                              ),
                              itemCount: 7, // +1 for "Add Board"
                              itemBuilder: (context, index) {
                                return customCardBoard(
                                  context: context,
                                  title: 'Skipsi aaaa',
                                  subtitle: 'Subtitle here',
                                  color: Colors.grey,
                                  nickname: 'AA',
                                );
                              },
                            ));
                      }

                      // Gunakan filteredBoards alih-alih boards
                      final filteredBoards = boardViewModel.filteredBoards;
                      final hasSearch = boardViewModel.searchQuery.isNotEmpty;
                      final noResults = hasSearch && filteredBoards.isEmpty;

                      // Tampilkan pesan jika pencarian tidak memberikan hasil
                      if (noResults) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off,
                                  size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  "Tidak ada board yang sesuai dengan '${boardViewModel.searchQuery}'",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.figtree(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  boardViewModel.clearSearch();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF293066),
                                ),
                                child: const Text("Hapus Pencarian"),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.2,
                        ),
                        itemCount:
                            filteredBoards.length + 1, // +1 for "Add Board"
                        itemBuilder: (context, index) {
                          if (index == filteredBoards.length) {
                            return _buildAddBoardCard(); // "Tambah Board" at the end
                          }
                          final board = filteredBoards[index];
                          bool checkUserCanEditBoard(int boardOwnerId) {
                            if (sp == null) return false;

                            // Check if user is Super Admin
                            if (sp!.roleSharedPreference.toLowerCase() ==
                                "super admin") {
                              return true;
                            }

                            // Original logic - check if user is board owner
                            final currentUserId = sp!.idSharedPreference;

                            // For non-board owners, check admin rights via BoardViewModel
                            if (currentUserId != boardOwnerId) {
                              return boardViewModel.canUserEditBoardById(
                                  board
                                      .id, // You need to pass the board ID here
                                  currentUserId,
                                  userRole: sp!.roleSharedPreference);
                            }

                            return currentUserId == boardOwnerId;
                          }

                          return GestureDetector(
                            onTap: () {
                              final cardTugasViewModel =
                                  Provider.of<CardTugasViewModel>(context,
                                      listen: false);
                              cardTugasViewModel.setBoardId(
                                  board.id.toString()); // Simpan boardId
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CardTugasScreen(
                                      boardId: board.id), // <-- kirim ID
                                ),
                              );
                            },
                            child: customCardBoard(
                                title: boardViewModel.truncateDescription(
                                    board.name, 14),
                                subtitle: board.user.name,
                                color: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)],
                                nickname: board.user.name.substring(
                                    0, min(2, board.user.name.length)),
                                context: context,
                                boardId: board.id,
                                canEdit: checkUserCanEditBoard(board.user.id),
                                onTap: (value) async {
                                  if (value == 'edit') {
                                    // Edit board name
                                    // boardViewModel.boardId = boardId.toString();
                                    selectedVisibility =
                                        boardViewModel.selectedBoardVisibility;
                                    boardViewModel.judulBoard.text = board.name;
                                    // Pastikan dialog ditampilkan dengan StatefulBuilder untuk memastikan state diperbarui dengan benar
                                    customShowDialog(
                                      useForm: true,
                                      context: context,
                                      customWidget: StatefulBuilder(
                                          // Tambahkan StatefulBuilder di sini
                                          builder: (context, setDialogState) {
                                        return Column(
                                          children: [
                                            customTextFormField(
                                              keyForm: boardViewModel.formKey,
                                              titleText: "Update Nama Board",
                                              controller:
                                                  boardViewModel.judulBoard,
                                              labelText:
                                                  "Masukkan Nama Board yang Baru",
                                              validator: (value) =>
                                                  boardViewModel
                                                      .validateBoardName(
                                                          value!),
                                            ),
                                            visibilityDropdownWidget(
                                              context,
                                              selectedVisibility ?? "Public",
                                              (value) {
                                                // Gunakan setDialogState untuk memastikan UI dropdown diperbarui
                                                setDialogState(() {
                                                  selectedVisibility = value;
                                                });
                                                // Perbarui juga state di parent widget
                                                setState(() {
                                                  selectedVisibility = value;
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      }),
                                      txtButtonL: "Batal",
                                      txtButtonR: "Update",
                                      onPressedBtnL: () {
                                        boardViewModel.judulBoard.clear();
                                        Navigator.pop(context);
                                      },
                                      onPressedBtnR: () async {
                                        final token = sp?.tokenSharedPreference;
                                        Navigator.pop(context);

                                        if (boardViewModel.formKey.currentState!
                                            .validate()) {
                                          customAlert(
                                            alertType: QuickAlertType.loading,
                                            text: "Mohon tunggu...",
                                            autoClose: false,
                                          );

                                          try {
                                            final response =
                                                await boardViewModel.editBoard(
                                              token: token,
                                              encryptId: board.encryptedId,
                                              visibility:
                                                  selectedVisibility, // Pastikan nilainya dilewatkan dengan benar
                                            );
                                            navigatorKey.currentState?.pop();
                                            if (response == 200) {
                                              final success =
                                                  await boardViewModel
                                                      .refreshBoardList(
                                                          token: token);
                                              if (success) {
                                              } else {
                                                await customAlert(
                                                  alertType:
                                                      QuickAlertType.error,
                                                  text: boardViewModel
                                                      .errorMessages,
                                                );
                                              }
                                            } else {
                                              navigatorKey.currentState?.pop();
                                              await customAlert(
                                                alertType: QuickAlertType.error,
                                                text:
                                                    "Gagal mengubah judul Board. Coba lagi nanti.",
                                              );
                                            }
                                          } on SocketException catch (_) {
                                            customAlert(
                                              alertType: QuickAlertType.warning,
                                              text:
                                                  'Tidak ada koneksi internet. Periksa jaringan Anda.',
                                            );
                                          } catch (e) {
                                            customAlert(
                                              alertType: QuickAlertType.error,
                                              text: 'Terjadi kesalahan',
                                            );
                                          }
                                        }
                                      },
                                    );
                                  } else if (value == 'anggota') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BoardAnggotaTaskScreen(
                                            boardId: board.id),
                                      ),
                                    );
                                  } else if (value == 'duplicate') {
                                    customShowDialog(
                                      useForm: false,
                                      context: context,
                                      text1:
                                          "Apakah anda yakin ingin menduplikasi board ini?",
                                      txtButtonL: "Batal",
                                      txtButtonR: "Duplikat",
                                      onPressedBtnL: () {
                                        Navigator.pop(context);
                                      },
                                      onPressedBtnR: () async {
                                        Navigator.pop(context);
                                        final token = sp?.tokenSharedPreference;

                                        await customAlert(
                                          alertType: QuickAlertType.loading,
                                          text: "Mohon tunggu...",
                                          autoClose: false,
                                        );

                                        try {
                                          final response = await boardViewModel
                                              .duplicateBoard(
                                                  token: token,
                                                  encryptId: board.encryptedId);
                                          navigatorKey.currentState
                                              ?.pop(); // Tutup loading alert

                                          if (response == 200) {
                                            final success = await boardViewModel
                                                .refreshBoardList(token: token);
                                            if (success) {
                                              customAlert(
                                                alertType:
                                                    QuickAlertType.success,
                                                title:
                                                    "Board berhasil diduplikasi!",
                                              );
                                            } else {
                                              // Error saat refresh
                                              customAlert(
                                                alertType: QuickAlertType.error,
                                                text: boardViewModel
                                                        .errorMessages ??
                                                    "Gagal merefresh data board",
                                              );
                                            }
                                          } else {
                                            // Error dari API (400, dll)
                                            customAlert(
                                              alertType: QuickAlertType.error,
                                              text: boardViewModel
                                                      .errorMessages ??
                                                  "Gagal menduplikasi board",
                                            );
                                          }
                                        } catch (e) {
                                          navigatorKey.currentState
                                              ?.pop(); // Tutup loading alert
                                          customAlert(
                                            alertType: QuickAlertType.error,
                                            text: "Terjadi kesalahan: $e",
                                          );
                                        }
                                      },
                                    );
                                  } else if (value == 'delete') {
                                    customShowDialog(
                                      useForm: false,
                                      context: context,
                                      text1:
                                          "Apakah anda yakin ingin menghapus Board ini?",
                                      txtButtonL: "Batal",
                                      txtButtonR: "Hapus",
                                      onPressedBtnL: () {
                                        Navigator.pop(context);
                                      },
                                      onPressedBtnR: () async {
                                        Navigator.pop(context);
                                        final token = sp?.tokenSharedPreference;

                                        await customAlert(
                                          alertType: QuickAlertType.loading,
                                          text: "Mohon tunggu...",
                                          autoClose: false,
                                        );

                                        try {
                                          final response =
                                              await boardViewModel.deleteBoard(
                                                  token: token,
                                                  encryptId: board.encryptedId);
                                          navigatorKey.currentState
                                              ?.pop(); // Tutup loading alert

                                          if (response == 200) {
                                            final success = await boardViewModel
                                                .refreshBoardList(token: token);
                                            if (success) {
                                              customAlert(
                                                alertType:
                                                    QuickAlertType.success,
                                                title:
                                                    "Board berhasil dihapus!",
                                              );
                                            } else {
                                              // Error saat refresh
                                              customAlert(
                                                alertType: QuickAlertType.error,
                                                text: boardViewModel
                                                        .errorMessages ??
                                                    "Gagal merefresh data board",
                                              );
                                            }
                                          } else {
                                            // Error dari API (400, dll)
                                            customAlert(
                                              alertType: QuickAlertType.error,
                                              text: boardViewModel
                                                      .errorMessages ??
                                                  "Gagal menghapus board",
                                            );
                                          }
                                        } catch (e) {
                                          navigatorKey.currentState
                                              ?.pop(); // Tutup loading alert
                                          customAlert(
                                            alertType: QuickAlertType.error,
                                            text: "Terjadi kesalahan: $e",
                                          );
                                        }
                                      },
                                    );
                                  }
                                }),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateBoardBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const CreateBoardBottomSheet();
      },
    );
  }

  Widget _buildAddBoardCard() {
    if (sp == null ||
        sp!.roleSharedPreference != "Dosen" &&
            sp!.roleSharedPreference != "Super Admin") {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        _showCreateBoardBottomSheet();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.grey, size: 32),
              const SizedBox(height: 8),
              Text("Buat Board",
                  style: GoogleFonts.figtree(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
