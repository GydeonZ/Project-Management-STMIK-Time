import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/screen/view/detailtugas/detail_tugas_screen.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_card_tugas.dart'
    as model;
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';

Widget buildDraggableTaskItem(model.Task task, Size size, BuildContext context,
    CardTugasViewModel viewModel, int boardId, int cardId, int index) {
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
              builder: (_) => DetailTugasScreen(
                taskId: task.id,
                // boardId: boardId,
              ),
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
