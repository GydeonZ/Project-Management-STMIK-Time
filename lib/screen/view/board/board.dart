import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/screen/view/navigation/navigation.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_board.dart';
import 'package:provider/provider.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late BoardViewModel viewModel;

  @override
  void initState() {
    viewModel = Provider.of<BoardViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardViewModel(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Hello Kenny!",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          actions: const [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                "KH",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tugas Anda pada hari ${viewModel.tanggalTerformat}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: "Pencarian",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildTaskCard("Skripsi", "5 tugas", Colors.blue),
                    _buildTaskCard("Everything", "57 tasks", Colors.orange),
                    _buildTaskCard("Skripsi", "5 tugas", Colors.blue),
                    _buildTaskCard("Everything", "57 tasks", Colors.orange),
                    _buildAddBoardCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTaskCard(String title, String subtitle, Color color) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: const Text(
              "KH",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    ),
  );
}

Widget _buildAddBoardCard() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Colors.grey, size: 32),
          SizedBox(height: 8),
          Text("Buat board", style: TextStyle(color: Colors.grey)),
        ],
      ),
    ),
  );
}
