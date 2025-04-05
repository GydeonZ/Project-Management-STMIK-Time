import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/screen/widget/cardtugas/card_tugas.dart';
// import 'package:skeletonizer/skeletonizer.dart';

class CardTugasScreen extends StatefulWidget {
  final int boardId;
  const CardTugasScreen({super.key, required this.boardId});
  

  @override
  State<CardTugasScreen> createState() => _CardTugasScreenState();
}

class _CardTugasScreenState extends State<CardTugasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Card',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: CustomCardTugas(boardId: widget.boardId))],
        ),
      ),
    );
  }
}

// Consumer<CardTugasViewModel>(builder: (context, viewModel, child) {
            //   if (viewModel.isLoading == true) {
            //     return Skeletonizer(
            //       enabled: viewModel.isLoading,
            //       child: ListView.builder(
            //         itemCount: 7,
            //         itemBuilder: (context, index) {
            //           return Card(
            //             child: ListTile(
            //               title: Text('Item number $index as title'),
            //               subtitle: const Text('Subtitle here'),
            //             ),
            //           );
            //         },
            //       ),
            //     );
            //   }
            //   // final boards = boardViewModel.modelBoard?.data ?? [];

            //   return ListView.builder(
            //       itemCount: 7, itemBuilder: (context, index) {});
            // })