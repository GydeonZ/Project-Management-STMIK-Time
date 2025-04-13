import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/screen/widget/detailtugas/customdetailtugas.dart';

class DetailTugasScreen extends StatelessWidget {
  final int boardId;
  final int taskId;

  const DetailTugasScreen({
    super.key,
    required this.boardId,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Detail Tugas',
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
        child: CustomDetailCardTugas(
          boardId: boardId,
          taskId: taskId,
        ),
      ),
    );
  }
}
