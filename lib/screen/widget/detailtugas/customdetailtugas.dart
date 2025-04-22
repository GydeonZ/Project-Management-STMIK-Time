// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_tasklist_id.dart';
import 'package:projectmanagementstmiktime/screen/view/member/anggota_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/utils/state/finite_state.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_anggota_list.dart';
import 'package:provider/provider.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_tasklist_id.dart'
    as model;
import 'package:quickalert/models/quickalert_type.dart';

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
  late AnggotaListViewModel anggotaListViewModel;
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
    anggotaListViewModel =
        Provider.of<AnggotaListViewModel>(context, listen: false);
    final token = sp.tokenSharedPreference;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set the taskId in the viewModel
      if (widget.taskId != null) {
        // Set task ID for both view models
        cardTugasViewModel.setTaskId(widget.taskId.toString());
        anggotaListViewModel.setTaskId(widget.taskId.toString());

        // Fetch task details using the dedicated method
        cardTugasViewModel.getTaskListById(token: token);

        // Also fetch the anggota list to get the board owner
        anggotaListViewModel.getAnggotaList(token: token);
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
          startTime = cardTugasViewModel.formatDateTime(task.startTime);
        }

        String endTime = "Waktu selesai belum diatur";
        if (task.endTime != null) {
          endTime = cardTugasViewModel.formatDateTime(task.endTime);
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
    return Consumer<CardTugasViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            customFormDetailTugas(
              context: context,
              colorText: Colors.black,
              containerOnTap: () {
                customShowDialogDeskripsi(
                  useForm: false,
                  roleChecker: _checkUserCanEdit(),
                  context: context,
                  text1: task.description,
                  txtButtonL: "Batal",
                  txtButtonR: "Edit",
                  onPressedBtnL: () {
                    Navigator.pop(context);
                  },
                  onPressedBtnR: () {
                    Navigator.pop(context);
                    viewModel.deskripsiTugas.text = task.description;
                    customShowDialogDeskripsi(
                      useForm: true,
                      roleChecker: _checkUserCanEdit(),
                      context: context,
                      formKey: viewModel.formKey,
                      txtButtonL: 'Batal',
                      txtButtonR: 'Simpan',
                      controller: viewModel.deskripsiTugas,
                      validator: (value) =>
                          viewModel.validateDeskripsiTugas(value!),
                      onPressedBtnL: () {
                        Navigator.pop(context);
                      },
                      onPressedBtnR: () async {
                        Navigator.pop(context);
                        final token = sp.tokenSharedPreference;

                        if (viewModel.formKey.currentState!.validate()) {
                          await customAlert(
                            alertType: QuickAlertType.loading,
                            text: "Mohon tunggu...",
                            autoClose: false,
                          );
                          try {
                            final response = await viewModel
                                .updateDeskripsiTugas(token: token);

                            if (response == 200) {
                              final success = await viewModel
                                  .refreshTaskListById(token: token);

                              navigatorKey.currentState?.pop();

                              if (success) {
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
                              text: 'Terjadi kesalahan: ${e.toString()}',
                            );
                          }
                        }
                      },
                    );
                  },
                );
              },
              listContainer: false,
              labelText: task.description.isNotEmpty
                  ? _truncateDescription(task.description, 40)
                  : "Deskripsi belum ditambah...",
              iconPath: "assets/deskripsi.svg",
              heightIcon: size.height * 0.025,
              widthIcon: size.width * 0.025,
            ),
            // Modify your customFormDetailTugas widgets for dates in _buildFormFields
            customFormDetailTugas(
              context: context,
              colorText: Colors.black,
              containerOnTap: () async {
                bool canEdit = _checkUserCanEdit();
                if (!canEdit) {
                  return;
                }

                final originalStart = viewModel.start;
                viewModel.start = task.startTime;
                viewModel.isStartDateSelected = true;

                // Show date picker
                await viewModel.selectStartDate(context);

                // Confirm changes
                if (viewModel.start != originalStart) {
                  // Show confirmation dialog
                  bool confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Ubah Waktu Mulai'),
                          content: Text(
                              'Ubah waktu mulai menjadi: ${viewModel.formatDateTime(viewModel.start)}?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Reset to original value
                                viewModel.start = originalStart;
                                Navigator.pop(context, false);
                              },
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Simpan'),
                            ),
                          ],
                        ),
                      ) ??
                      false;

                  if (confirm) {
                    // Save the changes
                    await customAlert(
                      alertType: QuickAlertType.loading,
                      text: "Mohon tunggu...",
                      autoClose: false,
                    );

                    try {
                      final response = await viewModel.updateTaskStartDates(
                          token: sp.tokenSharedPreference);

                      if (response == 200) {
                        // Refresh task data
                        await viewModel.refreshTaskListById(
                            token: sp.tokenSharedPreference);
                        navigatorKey.currentState?.pop();
                      } else {
                        navigatorKey.currentState?.pop();
                        customAlert(
                          alertType: QuickAlertType.error,
                          text: viewModel.errorMessages ??
                              "Gagal memperbarui waktu",
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
                      customAlert(
                        alertType: QuickAlertType.error,
                        text: "Terjadi kesalahan, Silahkan Coba lagi",
                      );
                    }
                  }
                }
              },
              listContainer: false,
              labelText: startTime,
              iconPath: "assets/clock.svg",
            ),

            customFormDetailTugas(
              context: context,
              colorText: Colors.black,
              containerOnTap: () async {
                bool canEdit = _checkUserCanEdit();
                if (!canEdit) {
                  return;
                }
                final originalEnd = viewModel.end;
                viewModel.end = task.endTime;
                viewModel.isEndDateSelected = true;

                // Show date picker
                await viewModel.selectStartDate(context);

                // Confirm changes
                if (viewModel.start != originalEnd) {
                  // Show confirmation dialog
                  bool confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Ubah Waktu Mulai'),
                          content: Text(
                              'Ubah waktu mulai menjadi: ${viewModel.formatDateTime(viewModel.start)}?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Reset to original value
                                viewModel.start = originalEnd;
                                Navigator.pop(context, false);
                              },
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Simpan'),
                            ),
                          ],
                        ),
                      ) ??
                      false;

                  if (confirm) {
                    // Save the changes
                    await customAlert(
                      alertType: QuickAlertType.loading,
                      text: "Mohon tunggu...",
                      autoClose: false,
                    );

                    try {
                      final response = await viewModel.updateTaskEndDates(
                          token: sp.tokenSharedPreference);

                      if (response == 200) {
                        // Refresh task data
                        await viewModel.refreshTaskListById(
                            token: sp.tokenSharedPreference);
                        navigatorKey.currentState?.pop();
                      } else {
                        navigatorKey.currentState?.pop();
                        customAlert(
                          alertType: QuickAlertType.error,
                          text: viewModel.errorMessages ??
                              "Gagal memperbarui waktu",
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
                      customAlert(
                        alertType: QuickAlertType.error,
                        text: "Terjadi kesalahan, Silahkan Coba lagi",
                      );
                    }
                  }
                }
              },
              listContainer: false,
              labelText: endTime,
              iconPath: "assets/clock.svg",
            ),
            customFormDetailTugas(
              context: context,
              containerOnTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AnggotaTaskScreen(taskId: widget.taskId)),
                );
              },
              containerAnggotaList: true,
              listContainer: false,
              iconPath: "assets/Two-user.svg",
              suffixWidget: task.members != null && task.members.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: SizedBox(
                        width: size.width * 0.75, // Adjust based on your needs
                        height: size.height * 0.05,
                        child: _buildTeamAvatars(size, task.members),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        "Anggota",
                        style: TextStyle(
                          fontFamily: "Helvetica",
                          fontSize: 14,
                          color: Color(0xFFB0B0B0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
            ),

            // Show checklists if available
            if (task.checklists != null && task.checklists.isNotEmpty)
              _buildExpandableSection(
                  'Daftar List Tugas', _pendahuluanItems, size),

            _buildCommentList(size, task.comments),
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
            if (task.files != null && task.files.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: task.files.length,
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
      },
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
          height: activities.isEmpty ? size.height * 0.20 : size.height * 0.20,
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
                    // Calculate reversed index: start from the end of the list
                    final reversedIndex = activities.length - 1 - index;
                    final activity = activities[reversedIndex];

                    final userName = activity.user.name;
                    final initial =
                        cardTugasViewModel.getMemberInitials(activity.user);

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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'helvetica',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  activity.activity,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'helvetica',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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

  Widget _buildCommentList(Size size, List<Comment> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customFormDetailTugas(
          context: context,
          listContainer: false,
          labelText: "Komentar",
          iconPath: "assets/komentar.svg",
          colorText: Colors.black,
        ),
        SizedBox(
          height: comments.isEmpty ? size.height * 0.20 : size.height * 0.20,
          child: comments.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada Komentar",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    // Calculate reversed index: start from the end of the list
                    final reversedIndex = comments.length - 1 - index;
                    final comment = comments[reversedIndex];

                    final userName = comment.user.name;
                    final initial =
                        cardTugasViewModel.getMemberInitials(comment.user);

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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'helvetica',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  comment.comment,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'helvetica',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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

  // Updated method to include board owner in the count with stacked avatars
  Widget _buildTeamAvatars(Size size, List<dynamic> members) {
    final anggotaViewModel = Provider.of<AnggotaListViewModel>(context);
    if (anggotaViewModel.isLoading) {
      return const Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Text(
          "Anggota",
          style: TextStyle(
            fontFamily: "Helvetica",
            fontSize: 14,
            color: Color(0xFFB0B0B0),
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    final boardOwner = anggotaViewModel.modelAnggotaList?.boardOwner;
    const int maxVisibleAvatars = 3;
    final int totalCount =
        boardOwner != null ? members.length + 1 : members.length;
    final int memberAvatarsToShow = boardOwner != null
        ? min(maxVisibleAvatars - 1, members.length)
        : min(maxVisibleAvatars, members.length);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 50,
          width: 160,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              if (boardOwner != null)
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF293066),
                  child: Text(
                    cardTugasViewModel.getInitialsFromName(boardOwner.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              for (int i = 0; i < memberAvatarsToShow; i++)
                Positioned(
                  left: boardOwner != null ? 20.0 + (i * 18.0) : i * 18.0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        Colors.primaries[(i * 3) % Colors.primaries.length],
                    child: Text(
                      cardTugasViewModel.getMemberInitials(members[i]),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xffD8EBFF),
          child: Text(
            "+$totalCount",
            style: const TextStyle(
              color: Color(0xff293066),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  bool _checkUserCanEdit() {
    // Get the current user ID from SharedPreferences
    final userIdStr = sp.idSharedPreference;
    final currentUserId = userIdStr;

    if (currentUserId == null || currentUserId <= 0) {
      return false;
    }

    // Get anggota list view model
    final anggotaViewModel =
        Provider.of<AnggotaListViewModel>(context, listen: false);

    // If anggota list is not loaded yet or is empty, default to false
    if (anggotaViewModel.modelAnggotaList == null) {
      return false;
    }

    // Check the user role using the existing method in AnggotaListViewModel
    final userRole = anggotaViewModel.getUserRoleFromAnggota(
        anggotaViewModel.modelAnggotaList!, currentUserId);
    // Define which roles can edit - Owner and Admin can edit
    final canEdit =
        userRole == RoleUserInBoard.owner || userRole == RoleUserInBoard.admin;
    return canEdit;
  }
}
