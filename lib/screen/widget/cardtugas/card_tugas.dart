import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/cardtugas/customskeletoncard.dart';
import 'package:projectmanagementstmiktime/screen/widget/cardtugas/draggablehelper.dart';
import 'package:projectmanagementstmiktime/screen/widget/cardtugas/customcard.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customtambahdetailtugas.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_board.dart';
import 'package:provider/provider.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_card_tugas.dart'
    as model;
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomCardTugas extends StatefulWidget {
  final int boardId;

  const CustomCardTugas({super.key, required this.boardId});

  @override
  State<CustomCardTugas> createState() => _CustomCardTugasState();
}

class _CustomCardTugasState extends State<CustomCardTugas> {
  late CardTugasViewModel cardTugasViewModel;
  late SignInViewModel sp;

  @override
  void initState() {
    super.initState();
    cardTugasViewModel =
        Provider.of<CardTugasViewModel>(context, listen: false);
    sp = Provider.of<SignInViewModel>(context, listen: false);
    final token = sp.tokenSharedPreference;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cardTugasViewModel.getCardTugasList(token: token);
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

  // Function untuk menangani perpindahan card
  Future<void> _handleCardReordered(
      model.Card card, int oldIndex, int newIndex) async {
    final token = sp.tokenSharedPreference;

    // Penyesuaian untuk posisi server (1-based)
    final serverPosition = newIndex + 1;

    await customAlert(
      alertType: QuickAlertType.loading,
      text: "Memperbarui posisi card...",
      autoClose: false,
    );

    try {
      final response = await cardTugasViewModel.updatePosCard(
        token: token,
        newPosition: serverPosition,
        cardId: card.id,
        boardId: card.boardId,
      );

      navigatorKey.currentState?.pop(); // Close loading alert

      if (response == 200) {
        await cardTugasViewModel.refreshCardTugasData(token: token);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Posisi card berhasil diubah'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                cardTugasViewModel.errorMessages ?? 'Gagal memindahkan card'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      navigatorKey.currentState?.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi Kesalahan, Coba lagi beberapa saat'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to handle task reordering within the same card
  Future<void> _handleTaskReordered(
      model.Task task, model.Card card, int oldIndex, int newIndex) async {
    final token = sp.tokenSharedPreference;
    final serverPosition = newIndex + 1;

    await customAlert(
      alertType: QuickAlertType.loading,
      text: "Memperbarui posisi tugas...",
      autoClose: false,
    );

    try {
      final response = await cardTugasViewModel.updatePosTugasCard(
        token: token,
        taskId: task.id,
        cardId: card.id,
        newPosition: serverPosition,
      );

      navigatorKey.currentState?.pop(); // Close loading alert

      if (response == 200) {
        await cardTugasViewModel.refreshCardTugasData(token: token);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Posisi tugas berhasil diubah'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                cardTugasViewModel.errorMessages ?? 'Gagal memindahkan tugas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      navigatorKey.currentState?.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi Kesalahan, Coba lagi beberapa saat'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to handle task moved to a different card
  Future<void> _handleTaskMoved(
      model.Task task, model.Card targetCard, int newPosition) async {
    final token = sp.tokenSharedPreference;

    // Create a position for the dropped task
    // Target position is end of list + 1 for the 1-based indexing
    final serverPosition = newPosition + 1;

    await customAlert(
      alertType: QuickAlertType.loading,
      text: "Memindahkan tugas ke card lain...",
      autoClose: false,
    );

    try {
      final response = await cardTugasViewModel.updatePosTugasCard(
        token: token,
        taskId: task.id,
        cardId: targetCard.id,
        newPosition: serverPosition,
      );

      navigatorKey.currentState?.pop();

      if (response == 200) {
        await cardTugasViewModel.refreshCardTugasData(token: token);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil dipindahkan ke card lain'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                cardTugasViewModel.errorMessages ?? 'Gagal memindahkan tugas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      navigatorKey.currentState?.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat memindahkan tugas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final canEdit = _checkUserCanEdit();

    return Consumer<CardTugasViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Skeletonizer(
            enabled: viewModel.isLoading,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, builder) {
                return customCardSkeleton(
                    context: context,
                    taskLength: 2,
                    color: Colors.grey,
                    taskColor: Colors.grey,
                    cardTitle: 'aaaaaaaa',
                    icon: false);
              },
            ),
          );
        }

        final board = viewModel.modelFetchCardTugas?.boards.firstWhere(
          (b) => b.id == widget.boardId,
          orElse: () => model.Board(
            id: 0,
            name: '',
            encryptedId: '',
            cards: [],
          ),
        );

        if (board == null || board.id == 0) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: size.height * 0.8,
              child: const Center(
                child: Text(
                  'Card tidak ditemukan',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          );
        }

        // Ganti ListView.builder menjadi ReorderableListView
        return ReorderableListView.builder(
          itemCount: board.cards.length,
          onReorder: (oldIndex, newIndex) {
            // Fix untuk ReorderableListView behavior
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }

            _handleCardReordered(board.cards[oldIndex], oldIndex, newIndex);
          },
          itemBuilder: (context, cardIndex) {
            final card = board.cards[cardIndex];
            return customCard(
              context: context,
              cardTitle: card.name,
              valueKey: ValueKey('card-${card.id}'),
              canEdit: canEdit,
              onTapTambahTugas: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomTambahDetailCardTugas(
                      cardId: card.id,
                    ),
                  ),
                );
              },
              onWillAccept: (data) {
                return data != null && data['sourceCardId'] != card.id;
              },
              onAccept: (data) {
                final task = data['task'] as model.Task;
                final sourceCardId = data['sourceCardId'] as int;

                if (sourceCardId != card.id) {
                  // Task is moved from another card to this card
                  _handleTaskMoved(task, card, card.tasks.length);
                }
              },
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }

                final movedTask = card.tasks[oldIndex];
                _handleTaskReordered(movedTask, card, oldIndex, newIndex);
              },
              forDrag: [
                for (int i = 0; i < card.tasks.length; i++)
                  buildDraggableTaskItem(card.tasks[i], size, context,
                      viewModel, board.id, card.id, i),
              ],
              onTapEdit: () async {
                final token = sp.tokenSharedPreference;
                viewModel.cardId = card.id.toString();
                customShowDialog(
                  useForm: true,
                  context: context,
                  customWidget: Column(
                    children: [
                      customTextFormField(
                        keyForm: viewModel.formKey,
                        titleText: "Update Judul Card",
                        controller: viewModel.namaCard,
                        labelText: "Masukkan Judul Card yang Baru",
                        validator: (value) =>
                            viewModel.validateNamaCard(value!),
                      ),
                    ],
                  ),
                  txtButtonL: "Batal",
                  txtButtonR: "Update",
                  onPressedBtnL: () {
                    viewModel.namaCard.clear();
                    Navigator.pop(context);
                  },
                  onPressedBtnR: () async {
                    viewModel.cardId = card.id.toString();
                    Navigator.pop(context); // Tutup form/modal sebelumnya
                    if (viewModel.formKey.currentState!.validate()) {
                      customAlert(
                        alertType: QuickAlertType.loading,
                        text: "Mohon tunggu...",
                        autoClose: false,
                      );

                      try {
                        final response =
                            await viewModel.updateTugasCard(token: token);
                        navigatorKey.currentState?.pop();
                        if (response == 200) {
                          final success = await viewModel.refreshCardTugasData(
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
                            text: "Gagal mengubah judul Card. Coba lagi nanti.",
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
              },
              onTapDelete: () async {
                final token = sp.tokenSharedPreference;
                viewModel.cardId = card.id.toString();
                customShowDialog(
                  useForm: false,
                  context: context,
                  text1: "Apakah anda yakin ingin menghapus Card ini?",
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

                    try {
                      final response =
                          await viewModel.deleteTugasCard(token: token);
                      navigatorKey.currentState?.pop(); // Tutup loading alert

                      if (response == 200) {
                        final success =
                            await viewModel.refreshCardTugasData(token: token);
                        if (success) {
                          customAlert(
                            alertType: QuickAlertType.success,
                            title: "Board berhasil dihapus!",
                          );
                        } else {
                          // Error saat refresh
                          customAlert(
                            alertType: QuickAlertType.error,
                            text: viewModel.errorMessages ??
                                "Gagal merefresh data board",
                          );
                        }
                      } else {
                        // Error dari API (400, dll)
                        customAlert(
                          alertType: QuickAlertType.error,
                          text: viewModel.errorMessages ??
                              "Gagal menghapus board",
                        );
                      }
                    } catch (e) {
                      navigatorKey.currentState?.pop(); // Tutup loading alert
                      customAlert(
                        alertType: QuickAlertType.error,
                        text: "Terjadi kesalahan: $e",
                      );
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
