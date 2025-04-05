import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_card_tugas.dart'
    as model;
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';

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
    cardTugasViewModel.getCardTugasList(token: token);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<CardTugasViewModel>(builder: (context, viewModel, _) {
      if (viewModel.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final board = viewModel.modelFetchCardTugas?.boards.firstWhere(
        (b) => b.id == widget.boardId, // <- gunakan widget.boardId
        orElse: () => model.Board(
          id: 0,
          name: '',
          visibility: '',
          userId: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          encryptedId: '',
          cards: [],
        ),
      );
      print("Board ID yang diterima: ${widget.boardId}");
      print("Semua Board ID yang ada:");
      viewModel.modelFetchCardTugas?.boards.forEach((b) {
        print(" - ${b.id}: ${b.name}");
      });


      if (board == null || board.id == 0) {
        return const Center(child: Text('Board tidak ditemukan'));
      }

      if (board.cards.isEmpty) {
        return const Center(child: Text("Belum ada card di board ini."));
      }

      return ListView.builder(
        itemCount: board.cards.length,
        itemBuilder: (context, index) {
          final card = board.cards[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        card.name ?? 'Tanpa Nama',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '+ Tambah Task',
                              style: const TextStyle(
                                color: Color(0xff0088D1),
                                fontSize: 13,
                                fontFamily: "Helvetica",
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Logika Tambah Task
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Tambah Task'),
                                      content: const Text(
                                          'Logika tambah task berhasil dijalankan!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Tutup'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  // Task List
                  Column(
                    children: List.generate(card.tasks.length, (taskIndex) {
                      final task = card.tasks[taskIndex];
                      return Card(
                        color: const Color(0xff293066),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(size.height * 0.013),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                task.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: "Helvetica",
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}






// Widget customCardTugas({
//   required String title,
//   required Color color,
//   required VoidCallback logic, // ✅ Ubah dari Function ke VoidCallback
// }) {
//   return Card(
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//           ),
//           const SizedBox(height: 4),
//           RichText(
//             text: TextSpan(children: [
//               TextSpan(
//                 text: '+ Tambah Tugas',
//                 style: const TextStyle(
//                   color: Color(0xff0088D1),
//                   fontSize: 13,
//                   fontFamily: "Helvetica",
//                 ),
//                 recognizer: TapGestureRecognizer()
//                   ..onTap = logic, // ✅ Panggil langsung
//               ),
//             ]),
//           ),
//         ],
//       ),
//     ),
//   );
// }
