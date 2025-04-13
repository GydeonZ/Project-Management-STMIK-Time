// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_tasklist_id.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:provider/provider.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_tasklist_id.dart'
    as model;

class CustomDetailCardTugas extends StatefulWidget {
  final int boardId;
  final int? taskId;

  const CustomDetailCardTugas(
      {super.key, required this.boardId, required this.taskId});

  @override
  State<CustomDetailCardTugas> createState() => _CustomDetailCardTugasState();
}

class _CustomDetailCardTugasState extends State<CustomDetailCardTugas> {
  late CardTugasViewModel cardTugasViewModel;
  late SignInViewModel sp;

  // State untuk mengontrol ekspansi panel
  final Map<String, bool> _expandedSections = {
    'PENDAHULUAN': false,
    'METODOLOGI': false,
    'HASIL': false,
  };

  // Contoh data untuk ListView
  final List<String> _pendahuluanItems = [
    'Latar Belakang',
    'Rumusan Masalah',
    'Batasan Masalah',
    'Tujuan Penelitian',
    'Manfaat Penelitian',
    'A',
    'B',
    'C',
  ];

  @override
  void initState() {
    super.initState();
    cardTugasViewModel =
        Provider.of<CardTugasViewModel>(context, listen: false);
    sp = Provider.of<SignInViewModel>(context, listen: false);
    final token = sp.tokenSharedPreference;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set the taskId in the viewModel
      if (widget.taskId != null) {
        cardTugasViewModel.setTaskId(widget.taskId.toString());
        // Fetch task details using the dedicated method
        cardTugasViewModel.getTaskListById(token: token);
      }
    });
  }

  String _truncateDescription(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<CardTugasViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Use modelFetchTaskId instead of extracting from boards list
        final task = viewModel.modelFetchTaskId?.task;

        if (task == null) {
          return const Center(
            child: Text(
              'Tugas tidak ditemukan',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Helvetica',
              ),
            ),
          );
        }

        // Get task data directly from the detailed task endpoint
        final taskName = task.name;
        final cardName = task.card.name;
        final boardName = task.card.board.name;

        // Format the dates
        String startTime = "Waktu mulai belum diatur";
        if (task.startTime != null) {
          startTime = formatDateTime(task.startTime);
        }

        String endTime = "Waktu selesai belum diatur";
        if (task.endTime != null) {
          endTime = formatDateTime(task.endTime);
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Text(
                taskName,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: size.height * 0.02),

              // Informasi Task yang diambil dari model
              Text(
                boardName, // Nama board
                style: const TextStyle(fontSize: 15, fontFamily: 'Helvetica'),
              ),
              SizedBox(height: size.height * 0.008),
              Text(
                cardName, // Nama card
                style: const TextStyle(fontSize: 15, fontFamily: 'Helvetica'),
              ),

              SizedBox(height: size.height * 0.025),

              // Form fields with task data
              _buildFormFields(size, task, startTime, endTime),
              // Show activities from the task
              _buildActivityList(size, task.activities),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpandableSection(String title, List<String> items, Size size) {
    return customFormDetailTugas(
      context: context,
      listContainer: true,
      onTapListContainer: () {
        setState(() {
          _expandedSections[title] = !(_expandedSections[title] ?? false);
        });
      },
      listDataTitle: title,
      animatedTurn: _expandedSections[title] ?? false ? 0.5 : 0,
      maxHeightListData: _expandedSections[title] ?? false
          ? (items.length > 6
              ? 6 * 56.0
              : items.length * 56.0) // Batasi tinggi maksimal
          : 0,
      scrollListData: _expandedSections[title] ?? false
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      opacityDataList: _expandedSections[title] ?? false ? 1.0 : 0.0,
      itemDataList: items.map((item) => _buildListItem(item)).toList(),
    );
  }

  Widget _buildListItem(String text) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                  value: true,
                  onChanged: (bool? value) {},
                  activeColor: const Color(0xFF484F88)),
              SizedBox(width: size.width * 0.02),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Helvetica',
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/pencil.svg',
                  height: size.height * 0.02,
                  width: size.width * 0.02,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/tongsampah.svg',
                  height: size.height * 0.02,
                  width: size.width * 0.02,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(
      Size size, model.Task task, String startTime, String endTime) {
    return Column(
      children: [
        customFormDetailTugas(
          context: context,
          colorText: Colors.black,
          containerOnTap: () {
            // Show full description in a dialog if it's long
            if (task.description.length > 40) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(task.name),
                  content: SingleChildScrollView(
                    child: Text(task.description),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              );
            }
          },
          listContainer: false,
          labelText: task.description.isNotEmpty
              ? _truncateDescription(task.description, 40)
              : "Deskripsi belum ditambah...",
          iconPath: "assets/deskripsi.svg",
          heightIcon: size.height * 0.025,
          widthIcon: size.width * 0.025,
        ),
        customFormDetailTugas(
          context: context,
          colorText: Colors.black,
          listContainer: false,
          labelText: startTime,
          iconPath: "assets/clock.svg",
        ),
        customFormDetailTugas(
          context: context,
          colorText: Colors.black,
          listContainer: false,
          labelText: endTime,
          iconPath: "assets/clock.svg",
        ),
        customFormDetailTugas(
          context: context,
          containerOnTap: () {
            
          },
          listContainer: false,
          labelText: "Anggota",
          iconPath: "assets/Two-user.svg",
        ),

        // Display team members if available
        if (task.members != null && task.members!.isNotEmpty)
          _buildTeamAvatars(size, task.members!),

        // Show checklists if available
        if (task.checklists != null && task.checklists!.isNotEmpty)
          _buildExpandableSection('Daftar List Tugas', _pendahuluanItems, size),

        // Show comments section
        customFormDetailTugas(
          context: context,
          listContainer: false,
          labelText: "Komentar",
          iconPath: "assets/komentar.svg",
          colorText: Colors.black,
        ),

        // Show comment list
        SizedBox(
          height: 120,
          child: task.comments != null && task.comments!.isNotEmpty
              ? ListView.builder(
                  itemCount: task.comments!.length,
                  itemBuilder: (context, index) {
                    // Build comment items here when you have the comment structure
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("Komentar tersedia"),
                    );
                  },
                )
              : const Center(
                  child: Text(
                    "Belum ada komentar",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),

        // File upload option
        customFormDetailTugas(
          context: context,
          containerOnTap: () {},
          listContainer: false,
          labelText: "Upload File",
          iconPath: "assets/clip.svg",
          textBold: true,
          colorText: Colors.black,
        ),

        // Display files if available
        if (task.files != null && task.files!.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: task.files!.length,
              itemBuilder: (context, index) {
                // Build file items here
                return const ListTile(
                  leading: Icon(Icons.file_present),
                  title: Text("File name"),
                );
              },
            ),
          ),
      ],
    );
  }

  // Add a new method to display activities from the task
  Widget _buildActivityList(Size size, List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customFormDetailTugas(
          context: context,
          listContainer: false,
          labelText: "Aktivitas",
          iconPath: "assets/komentar.svg",
          colorText: Colors.black,
        ),
        SizedBox(
          height: activities.isEmpty ? 50 : 120,
          child: activities.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada aktivitas",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    final userName = activity.user.name;
                    final initial = userName
                        .split(' ')
                        .map((e) => e.isNotEmpty ? e[0] : '')
                        .join('')
                        .substring(0, min(2, userName.length));

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.primaries[
                                userName.hashCode % Colors.primaries.length],
                            child: Text(
                              initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "$userName ${activity.activity}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'helvetica',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Add a method to display team member avatars
  Widget _buildTeamAvatars(Size size, List<dynamic> members) {
    // Determine how many avatars to show and how many are hidden
    const int maxVisibleAvatars = 3;
    final int remainingCount = members.length > maxVisibleAvatars
        ? members.length - maxVisibleAvatars
        : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          // Display the visible avatars
          for (int i = 0; i < min(maxVisibleAvatars, members.length); i++)
            Padding(
              padding: const EdgeInsets.only(right: -8), // Negative for overlap
              child: CircleAvatar(
                radius: 20,
                backgroundColor:
                    Colors.primaries[(i * 5) % Colors.primaries.length],
                child: Text(
                  "M${i + 1}", // Replace with actual member initials when available
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

          // Show remaining count if there are more members
          if (remainingCount > 0)
            Container(
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade50,
                child: Text(
                  "+$remainingCount",
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to format date strings
  String formatDateTime(DateTime dateTime) {
    try {
      // Format bulan dalam bahasa Indonesia
      List<String> namaBulan = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];

      String hari = dateTime.day.toString();
      String bulan = namaBulan[dateTime.month - 1];
      String tahun = dateTime.year.toString();
      String jam = dateTime.hour.toString().padLeft(2, '0');
      String menit = dateTime.minute.toString().padLeft(2, '0');

      return "$hari $bulan $tahun jam $jam.$menit";
    } catch (e) {
      return "Format waktu tidak valid";
    }
  }
}
