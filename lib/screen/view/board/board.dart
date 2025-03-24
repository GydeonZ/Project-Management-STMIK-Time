import 'dart:math';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/screen/view/onboarding/onboarding.dart';
import 'package:projectmanagementstmiktime/screen/widget/boardbottomsheet.dart';
import 'package:projectmanagementstmiktime/screen/widget/card_board.dart';
import 'package:projectmanagementstmiktime/view_model/board/view_model_board.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late BoardViewModel boardViewModel;
  late SignInViewModel sp;
  late SharedPreferences logindata;

  @override
  void initState() {
    super.initState();
    initial();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sp = Provider.of<SignInViewModel>(context, listen: false);
      final token = sp.tokenSharedPreference;
      boardViewModel = Provider.of<BoardViewModel>(context, listen: false);
      sp.setSudahLogin();
      boardViewModel.getBoardList(
        token: token,
      );
    });
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Consumer<SignInViewModel>(
          builder: (context, contactModel, child) {
            return Text(
              "Hello ${contactModel.nameSharedPreference}!",
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
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

              return CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  initials,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await boardViewModel.getBoardList(token: sp.tokenSharedPreference);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<BoardViewModel>(
                  builder: (context, boardViewModel, child) {
                return Text(
                  "Tugas Anda pada hari ${boardViewModel.tanggalTerformat}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                );
              }),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<BoardViewModel>(
                  builder: (context, boardViewModel, child) {
                    if (boardViewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final boards = boardViewModel.modelBoard?.data ?? [];

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: boards.length + 1, // +1 for "Add Board"
                      itemBuilder: (context, index) {
                        if (index == boards.length) {
                          return _buildAddBoardCard(); // "Tambah Board" at the end
                        }
                        final board = boards[index];
                        return customCardBoard(
                          title: board.name,
                          subtitle: board.user.name,
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          nickname: board.user.name.substring(0, 2),
                        );
                      },
                    );
                  },
                ),
              ),
              Consumer<SignInViewModel>(builder: (context, model, child) {
                return FloatingActionButton(
                  onPressed: () {
                    logindata.setBool('login', true);
                    model.keluar();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Icon(Icons.refresh),
                );
              })
            ],
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
    return GestureDetector(
      onTap: () {
        _showCreateBoardBottomSheet();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.grey, size: 32),
              SizedBox(height: 8),
              Text("Buat Board", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
