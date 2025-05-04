import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/view/detailtugas/detail_tugas_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
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
import 'package:dotted_border/dotted_border.dart';

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
            return Card(
              key: ValueKey('card-${card.id}'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Card
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              card.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Row(
                              children: [
                                if (canEdit)
                                RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '+ Tambah Tugas',
                                          style: const TextStyle(
                                            color: Color(0xff293066),
                                            fontSize: 13,
                                            fontFamily: "Helvetica",
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomTambahDetailCardTugas(
                                                    cardId: card.id,
                                                  ),
                                                ),
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),

                        // Container for tasks that can accept drops from other cards
                        DragTarget<Map<String, dynamic>>(
                          onWillAccept: (data) {
                            return data != null &&
                                data['sourceCardId'] != card.id;
                          },
                          onAccept: (data) {
                            final task = data['task'] as model.Task;
                            final sourceCardId = data['sourceCardId'] as int;

                            if (sourceCardId != card.id) {
                              // Task is moved from another card to this card
                              _handleTaskMoved(task, card, card.tasks.length);
                            }
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: candidateData.isNotEmpty
                                    ? Colors.grey.withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.05),
                              ),
                              child: Column(
                                children: [
                                  // Reorderable list for tasks in this card
                                  ReorderableListView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    onReorder: (oldIndex, newIndex) {
                                      if (newIndex > oldIndex) {
                                        newIndex -= 1;
                                      }

                                      final movedTask = card.tasks[oldIndex];
                                      _handleTaskReordered(
                                          movedTask, card, oldIndex, newIndex);
                                    },
                                    children: [
                                      for (int i = 0;
                                          i < card.tasks.length;
                                          i++)
                                        _buildDraggableTaskItem(
                                            card.tasks[i],
                                            size,
                                            context,
                                            viewModel,
                                            board.id,
                                            card.id,
                                            i),
                                    ],
                                  ),

                                  // Empty drop area at the bottom of each list
                                  if (candidateData.isNotEmpty)
                                    DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(8),
                                      color: const Color(0xff293066),
                                      strokeWidth: 2,
                                      dashPattern: const [6, 3],
                                      child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Letakkan tugas di sini",
                                            style: TextStyle(
                                              color: Color(0xff293066),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        if(canEdit)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final token = sp.tokenSharedPreference;
                                customShowDialog(
                                    useForm: true,
                                    context: context,
                                    customWidget: customTextFormField(
                                      keyForm: viewModel.formKey,
                                      titleText: "Update Judul Card",
                                      controller: viewModel.namaCard,
                                      labelText:
                                          "Masukkan Judul Card yang Baru",
                                      validator: (value) =>
                                          viewModel.validateNamaCard(value!),
                                    ),
                                    txtButtonL: "Batal",
                                    txtButtonR: "Update",
                                    onPressedBtnL: () {
                                      Navigator.pop(context);
                                    },
                                    onPressedBtnR: () async {
                                      Navigator.pop(context);
                                      viewModel.cardId = card.id.toString();

                                      if (viewModel.formKey.currentState!
                                          .validate()) {
                                        await customAlert(
                                          alertType: QuickAlertType.loading,
                                          text: "Mohon tunggu...",
                                          autoClose: false,
                                        );
                                        try {
                                          final response = await viewModel
                                              .updateTugasCard(token: token);

                                          if (response == 200) {
                                            final success = await viewModel
                                                .refreshCardTugasData(
                                                    token: token);

                                            navigatorKey.currentState?.pop();

                                            if (success) {
                                              customAlert(
                                                alertType:
                                                    QuickAlertType.success,
                                                title:
                                                    "Judul Card Berhasil di Update!",
                                              );
                                            } else {
                                              customAlert(
                                                alertType: QuickAlertType.error,
                                                text:
                                                    "Gagal mengupdate card. Coba lagi nanti.",
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
                                        } on SocketException catch (_) {
                                          navigatorKey.currentState?.pop();
                                          await customAlert(
                                            alertType: QuickAlertType.warning,
                                            text:
                                                'Tidak ada koneksi internet. Periksa jaringan Anda.',
                                          );
                                        } catch (e) {
                                          navigatorKey.currentState?.pop();
                                          await customAlert(
                                            alertType: QuickAlertType.error,
                                            text:
                                                'Terjadi kesalahan, Coba lagi beberapa saat',
                                          );
                                        }
                                      }
                                    });
                              },
                              icon: SvgPicture.asset(
                                "assets/pencil.svg",
                                height: size.height * 0.025,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                final token = sp.tokenSharedPreference;
                                customShowDialog(
                                    useForm: false,
                                    context: context,
                                    text1:
                                        "Apakah anda yakin ingin menghapus card ini?",
                                    text2:
                                        "Data yang sudah dihapus tidak dapat dikembalikan",
                                    txtButtonL: "Batal",
                                    txtButtonR: "Hapus",
                                    onPressedBtnL: () {
                                      Navigator.pop(context);
                                    },
                                    onPressedBtnR: () async {
                                      Navigator.pop(context);
                                      viewModel.cardId = card.id.toString();

                                      final response = await viewModel
                                          .deleteTugasCard(token: token);

                                      if (!mounted) return;

                                      if (response == 200) {
                                        final success = await viewModel
                                            .refreshCardTugasData(token: token);

                                        if (!mounted) return;

                                        if (success) {
                                          customAlert(
                                            alertType: QuickAlertType.success,
                                            title: "Card berhasil dihapus!",
                                          );
                                        } else {
                                          customAlert(
                                            alertType: QuickAlertType.error,
                                            text: viewModel.errorMessages,
                                          );
                                        }
                                      } else {
                                        customAlert(
                                          alertType: QuickAlertType.error,
                                          text:
                                              "Gagal menghapus card. Coba lagi nanti.",
                                        );
                                      }
                                    });
                              },
                              icon: SvgPicture.asset(
                                "assets/tongsampah.svg",
                                height: size.height * 0.025,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper method to build draggable task item that can move between cards
  Widget _buildDraggableTaskItem(
      model.Task task,
      Size size,
      BuildContext context,
      CardTugasViewModel viewModel,
      int boardId,
      int cardId,
      int index) {
    return LongPressDraggable<Map<String, dynamic>>(
      key: ValueKey('task-${task.id}'),
      data: {'task': task, 'sourceCardId': cardId, 'sourceIndex': index},
      feedback: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: size.width * 0.85,
          padding: EdgeInsets.all(size.height * 0.013),
          decoration: BoxDecoration(
            color: const Color(0xff293066),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  task.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: "Helvetica",
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Card(
          color: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            padding: EdgeInsets.all(size.height * 0.013),
            child: const Center(child: Text("Tugas dipindahkan...")),
          ),
        ),
      ),
      child: Card(
        color: const Color(0xff293066),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
          onTap: () {
            viewModel.setBoardId(boardId.toString());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    DetailTugasScreen(taskId: task.id, boardId: boardId),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.013),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: "Helvetica",
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
