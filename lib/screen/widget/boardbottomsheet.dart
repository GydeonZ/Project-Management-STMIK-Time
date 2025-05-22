// ignore_for_file: library_private_types_in_public_api, prefer_collection_literals, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_addboard.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_board.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';

class CreateBoardBottomSheet extends StatefulWidget {
  const CreateBoardBottomSheet({super.key});

  @override
  CreateBoardrBottomSheetState createState() => CreateBoardrBottomSheetState();
}

class CreateBoardrBottomSheetState extends State<CreateBoardBottomSheet> {
  late AddBoardViewModel addBoardViewModel;
  late BoardViewModel boardViewModel;
  late SignInViewModel sp;
  Set<String> selectedOptions = Set<String>();

  @override
  void initState() {
    super.initState();
    boardViewModel = Provider.of<BoardViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sp = Provider.of<SignInViewModel>(context, listen: false);
      sp.setSudahLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    addBoardViewModel = Provider.of<AddBoardViewModel>(context);
    bool isSaveButtonVisible = addBoardViewModel.boardName.text.isNotEmpty &&
        addBoardViewModel.selectedVisibility.text.isNotEmpty;
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.6,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bagian Header BottomSheet
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.295),
                    child: const Text(
                      'Tambah Board',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      addBoardViewModel.clearAll();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              _buildCreateBoard('Nama Board'),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Visibilitas',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showVisibilitySelection(
                          context); // Buka bottom sheet untuk memilih visibilitas
                    },
                    child: Consumer<BoardViewModel>(
                      builder: (context, boardViewModel, child) {
                        return Padding(
                          padding: EdgeInsets.only(left: size.width * 0.5),
                          child: Text(
                            addBoardViewModel.selectedVisibility.text.isEmpty
                                ? addBoardViewModel.selectedVisibility.text =
                                    "Public" // Default jika kosong
                                : addBoardViewModel.selectedVisibility.text,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color(0xff939393),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Tombol Simpan (jika ada perubahan)
              Visibility(
                visible: isSaveButtonVisible,
                child: ElevatedButton(
                  onPressed: () async {
                    final token = sp.tokenSharedPreference;
                    if (addBoardViewModel.formKey.currentState!.validate()) {
                      customAlert(
                        alertType: QuickAlertType.loading,
                        text: "Mohon tunggu...",
                        autoClose: false,
                      );

                      try {
                        final response =
                            await addBoardViewModel.addBoardList(token: token);
                        navigatorKey.currentState?.pop();
                        if (response == 200) {
                          final success = await boardViewModel.refreshBoardList(
                              token: token);
                          navigatorKey.currentState?.pop();
                          if (success) {
                          } else {
                            await customAlert(
                              alertType: QuickAlertType.error,
                              text: addBoardViewModel.errorMessages,
                            );
                          }
                        } else {
                          navigatorKey.currentState?.pop();
                          await customAlert(
                            alertType: QuickAlertType.error,
                            text: "Gagal mengubah board. Coba lagi nanti.",
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
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    backgroundColor: const Color(0xFF293066),
                  ),
                  child: const Text('Tambah Board'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk input Nama Board
  Widget _buildCreateBoard(String title) {
    return Consumer<BoardViewModel>(
      builder: (context, boardModel, child) {
        return customTextFormField(
            titleText: "Nama Board",
            keyForm: addBoardViewModel.formKey,
            controller: addBoardViewModel.boardName,
            labelText: "Masukkan Nama Dashbor",
            validator: (value) => addBoardViewModel.validateBoardName(value!));
      },
    );
  }

  // Menampilkan BottomSheet untuk memilih visibilitas
  void _showVisibilitySelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Public"),
                onTap: () {
                  setState(() {
                    addBoardViewModel.selectedVisibility.text = "Public";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Private"),
                onTap: () {
                  setState(() {
                    addBoardViewModel.selectedVisibility.text = "Private";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Menampilkan BottomSheet utama untuk menambahkan Board
void showCreateBoardBottomSheet(BuildContext context) {
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
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height * 0.7,
          child: const CreateBoardBottomSheet(),
        ),
      );
    },
  );
}
