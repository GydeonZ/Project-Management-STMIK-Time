// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_tasklist_id.dart';
import 'package:projectmanagementstmiktime/screen/view/member/anggota_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_anggota_list.dart';
import 'package:provider/provider.dart';
import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_tasklist_id.dart'
    as model;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDetailCardTugas extends StatefulWidget {
  // final int boardId;
  final int? taskId;

  const CustomDetailCardTugas({
    super.key,
    // required this.boardId,
    required this.taskId,
  });

  @override
  State<CustomDetailCardTugas> createState() => _CustomDetailCardTugasState();
}

class _CustomDetailCardTugasState extends State<CustomDetailCardTugas> {
  late CardTugasViewModel cardTugasViewModel;
  late AnggotaListViewModel anggotaListViewModel;
  late SignInViewModel sp;

  // Replace your existing _expandedSections declaration with this in _CustomDetailCardTugasState class
  final Map<String, bool> _expandedSections = {
    'Daftar List Tugas': false,
    'File Lampiran': false,
  };

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

  Future<void> launchURL(int fileId) async {
    String url = '${Urls.baseUrls}${Urls.downloadFileUrls}$fileId/download';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
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
          return const SizedBox();
        }

        // Use modelFetchTaskId instead of extracting from boards list
        final task = viewModel.modelFetchTaskId?.task;

        if (task == null) {
          return Center(
            child: Text(
              'Tugas tidak ditemukan',
              style: GoogleFonts.figtree(
                fontSize: 16,
              ),
            ),
          );
        }

        // Get task data directly from the detailed task endpoint
        final taskName = task.name;
        final cardName = task.card.name;
        final boardName = task.card.board.name;
        // Format the dates
        String startTime = "Waktu mulai...";
        final bool canRead = _checkUserCanRead();
        if (task.startTime != null && canRead) {
          startTime = cardTugasViewModel.formatDateTime(task.startTime);
        }

        String endTime = "Waktu selesai...";
        if (task.endTime != null && canRead) {
          endTime = cardTugasViewModel.formatDateTime(task.endTime);
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Text(
                taskName,
                style: GoogleFonts.figtree(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: size.height * 0.02),

              // Informasi Task yang diambil dari model
              Text(
                boardName, // Nama board
                style: GoogleFonts.figtree(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: size.height * 0.008),
              Text(
                cardName, // Nama card
                style: GoogleFonts.figtree(
                  fontSize: 15,
                ),
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

  Widget buildExpandableSection(String title, List<String> items, Size size) {
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
                style: GoogleFonts.figtree(
                  fontSize: 14,
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
    final bool canEdit = _checkUserCanEdit();
    final bool canRead = _checkUserCanRead();
    return Consumer<CardTugasViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            customFormDetailTugas(
              context: context,
              colorText: Colors.black,
              containerOnTap: () {
                if (!canEdit) {
                  return;
                }
                customShowDialogDeskripsi(
                  useForm: false,
                  roleChecker: canEdit,
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
                      roleChecker: canEdit,
                      context: context,
                      formKey: viewModel.formKey,
                      txtButtonL: 'Batal',
                      txtButtonR: 'Simpan',
                      controller: viewModel.deskripsiTugas,
                      validator: (value) =>
                          viewModel.validateDeskripsiTugas(value!),
                      onPressedBtnL: () {
                        viewModel.deskripsiTugas.clear();
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
                              text:
                                  'Terjadi kesalahan Silahkan Coba lagi nanti',
                            );
                          }
                        }
                      },
                    );
                  },
                );
              },
              listContainer: false,
              labelText: task.description.isNotEmpty && canRead
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
                        context: navigatorKey.currentContext!,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: const Text('Ubah Waktu Mulai'),
                          content: Text(
                              'Ubah waktu mulai menjadi: ${viewModel.formatDateTime(viewModel.start)}?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Reset to original value
                                viewModel.start = originalStart;
                                viewModel.isStartDateSelected = false;
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
                if (!canEdit) {
                  return;
                }

                final originalEnd = viewModel.end;
                viewModel.end = task.endTime;
                viewModel.isEndDateSelected = true;

                // Show date picker
                await viewModel.selectEndDate(context);

                // Confirm changes
                if (viewModel.end != originalEnd) {
                  // Show confirmation dialog
                  bool confirm = await showDialog(
                        context: navigatorKey.currentContext!,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: const Text('Ubah Waktu Akkhir'),
                          content: Text(
                              'Ubah waktu akhir menjadi: ${viewModel.formatDateTime(viewModel.end)}?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Reset to original value
                                viewModel.end = originalEnd;
                                viewModel.isEndDateSelected = false;
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
                if (!canRead) {
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AnggotaTaskScreen(taskId: widget.taskId)),
                );
              },
              containerAnggotaList: true,
              listContainer: false,
              iconPath: "assets/Two-user.svg",
              suffixWidget: task.members != null &&
                      task.members.isNotEmpty &&
                      canRead
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: SizedBox(
                        width: size.width * 0.75, // Adjust based on your needs
                        height: size.height * 0.05,
                        child: _buildTeamAvatars(size, task.members),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        "Anggota",
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          color: const Color(0xFFB0B0B0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
            ),

            // Show checklists if available - replace this section
            if (task.checklists.isNotEmpty)
              _buildChecklistSection(task.checklists, size),

            _buildCommentList(size, task.comments),
            customFormDetailTugas(
              context: context,
              containerOnTap: () {
                if (!canEdit) {
                  return;
                }
                showFilePickerOption(context);
              },
              listContainer: false,
              labelText: "Upload File",
              iconPath: "assets/clip.svg",
              textBold: true,
              colorText: Colors.black,
            ),

            // Display files if available
            if (task.files != null && task.files.isNotEmpty)
              _buildFileSection(task.files, size),
          ],
        );
      },
    );
  }

  // Add this new method to build the checklist section
  // Update your _buildChecklistSection to include an Add button
  Widget _buildChecklistSection(
    List<Checklist> checklists,
    Size size,
  ) {
    final bool canEdit = _checkUserCanEdit();
    if (!canEdit) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        customFormDetailTugas(
            context: context,
            listContainer: true,
            onTapListContainer: () {
              setState(() {
                _expandedSections['Daftar List Tugas'] =
                    !(_expandedSections['Daftar List Tugas'] ?? false);
              });
            },
            listDataTitle: "Daftar List Tugas",
            animatedTurn:
                _expandedSections['Daftar List Tugas'] ?? false ? 0.5 : 0,
            maxHeightListData: _expandedSections['Daftar List Tugas'] ?? false
                ? (checklists.length > 6 ? 6 * 75.0 : checklists.length * 75.0)
                : 0,
            scrollListData: _expandedSections['Daftar List Tugas'] ?? false
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            opacityDataList:
                _expandedSections['Daftar List Tugas'] ?? false ? 1.0 : 0.0,
            itemDataList: checklists
                .map((checklist) => _buildChecklistItem(checklist))
                .toList(),
            roleCheckerList: _checkUserCanEdit(),
            onTapCL: () {
              _addChecklist();
            }),
      ],
    );
  }

  // Add this method to build individual checklist items
  Widget _buildChecklistItem(Checklist checklist) {
    Size size = MediaQuery.of(context).size;
    final bool canEdit = _checkUserCanEdit();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // Use the is_checked value to set checkbox state
                Checkbox(
                  value: checklist.isChecked,
                  onChanged: (bool? value) {
                    _updateChecklistStatus(checklist.id, value ?? false);
                  },
                  activeColor: const Color(0xFF484F88),
                ),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: Text(
                    checklist.name,
                    style: GoogleFonts.figtree(
                      fontSize: 14,

                      // Optionally strike through text if checked
                      decoration: checklist.isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Only show edit/delete buttons if user can edit
          if (canEdit)
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _editChecklist(checklist);
                  },
                  icon: SvgPicture.asset(
                    'assets/pencil.svg',
                    height: size.height * 0.02,
                    width: size.width * 0.02,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _deleteChecklist(checklist.id);
                  },
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

  // Add these methods to handle checklist actions
  void _updateChecklistStatus(int checklistId, bool isChecked) async {
    // Show loading indicator
    await customAlert(
      alertType: QuickAlertType.loading,
      text: "Mohon tunggu...",
      autoClose: false,
    );

    try {
      // Call view model method to update checklist status
      final response = await cardTugasViewModel.toggleChecklistStatus(
          token: sp.tokenSharedPreference, checklistId: checklistId);

      // Close loading indicator
      navigatorKey.currentState?.pop();

      if (response == 200) {
        // Refresh task data to show updated checklists
        await cardTugasViewModel.refreshTaskListById(
          token: sp.tokenSharedPreference,
        );
      } else {
        customAlert(
          alertType: QuickAlertType.error,
          text:
              cardTugasViewModel.errorMessages ?? "Gagal mengupdate checklist",
        );
      }
    } catch (e) {
      navigatorKey.currentState?.pop();
      customAlert(
        alertType: QuickAlertType.error,
        text: "Terjadi kesalahan Silahkan Coba lagi nanti",
      );
    }
  }

  void _addChecklist() {
    // Show edit dialog
    customShowDialog(
        useForm: true,
        context: context,
        customWidget: customTextFormField(
          keyForm: cardTugasViewModel.formKey,
          titleText: "Judul Checklist",
          controller: cardTugasViewModel.clName,
          labelText: "Masukkan Judul Tugas yang Baru",
          validator: (value) =>
              cardTugasViewModel.validateNamaChecklist(value!),
        ),
        txtButtonL: "Batal",
        txtButtonR: "Tambah",
        onPressedBtnL: () {
          cardTugasViewModel.clName.clear();
          Navigator.pop(context);
        },
        onPressedBtnR: () async {
          // Close dialog
          Navigator.pop(context);

          // Show loading indicator
          await customAlert(
            alertType: QuickAlertType.loading,
            text: "Mohon tunggu...",
            autoClose: false,
          );

          try {
            // Call view model method to create new checklist
            final response = await cardTugasViewModel.addChecklist(
              token: sp.tokenSharedPreference,
              taskId: widget.taskId!,
            );

            // Close loading indicator
            navigatorKey.currentState?.pop();

            if (response == 200) {
              // Refresh task data to show updated checklists
              await cardTugasViewModel.refreshTaskListById(
                token: sp.tokenSharedPreference,
              );
              cardTugasViewModel.clName.clear();
            } else {
              customAlert(
                alertType: QuickAlertType.error,
                text: cardTugasViewModel.errorMessages ??
                    "Gagal menambahkan checklist",
              );
            }
          } catch (e) {
            navigatorKey.currentState?.pop();
            customAlert(
              alertType: QuickAlertType.error,
              text: "Terjadi kesalahan Silahkan Coba lagi nanti",
            );
          }
        });
  }

  void _editChecklist(Checklist checklist) {
    // Create text controller with current checklist name
    final TextEditingController controller =
        TextEditingController(text: checklist.name);

    // Show edit dialog
    customShowDialog(
        useForm: true,
        context: context,
        customWidget: customTextFormField(
          keyForm: cardTugasViewModel.formKey,
          titleText: "Update Judul Checklist",
          controller: controller,
          labelText: "Masukkan Judul Checklist yang Baru",
          validator: (value) =>
              cardTugasViewModel.validateNamaChecklist(value!),
        ),
        txtButtonL: "Batal",
        txtButtonR: "Update",
        onPressedBtnL: () {
          Navigator.pop(context);
        },
        onPressedBtnR: () async {
          // Close dialog
          Navigator.pop(context);

          // Show loading indicator
          await customAlert(
            alertType: QuickAlertType.loading,
            text: "Mohon tunggu...",
            autoClose: false,
          );

          try {
            // Call view model method to update checklist name
            final response = await cardTugasViewModel.updateChecklistName(
              token: sp.tokenSharedPreference,
              checklistId: checklist.id,
              name: controller.text,
            );

            // Close loading indicator
            navigatorKey.currentState?.pop();

            if (response == 200) {
              // Refresh task data to show updated checklists
              await cardTugasViewModel.refreshTaskListById(
                token: sp.tokenSharedPreference,
              );
            } else {
              customAlert(
                alertType: QuickAlertType.error,
                text: cardTugasViewModel.errorMessages ??
                    "Gagal mengupdate checklist",
              );
            }
          } catch (e) {
            navigatorKey.currentState?.pop();
            customAlert(
              alertType: QuickAlertType.error,
              text: "Terjadi kesalahan Silahkan Coba lagi nanti",
            );
          }
        });
  }

  void _deleteChecklist(int checklistId) {
    // Show confirmation dialog
    customShowDialog(
        context: context,
        useForm: false,
        text1: "Apakah anda yakin ingin menghapus Checklist tugas ini?",
        txtButtonL: "Batal",
        txtButtonR: "Hapus",
        onPressedBtnL: () {
          Navigator.pop(context);
        },
        onPressedBtnR: () async {
          Navigator.pop(context);

          // Show loading indicator
          await customAlert(
            alertType: QuickAlertType.loading,
            text: "Mohon tunggu...",
            autoClose: false,
          );

          try {
            // Call view model method to delete checklist
            final response = await cardTugasViewModel.deleteChecklist(
              token: sp.tokenSharedPreference,
              checklistId: checklistId,
            );

            // Close loading indicator
            navigatorKey.currentState?.pop();

            if (response == 200) {
              // Refresh task data to show updated checklists
              await cardTugasViewModel.refreshTaskListById(
                token: sp.tokenSharedPreference,
              );
            } else {
              customAlert(
                alertType: QuickAlertType.error,
                text: cardTugasViewModel.errorMessages ??
                    "Gagal menghapus checklist",
              );
            }
          } catch (e) {
            navigatorKey.currentState?.pop();
            customAlert(
              alertType: QuickAlertType.error,
              text: "Terjadi kesalahan Silahkan Coba lagi nanti",
            );
          }
        });
  }

  // Add a new method to display activities from the task
  Widget _buildActivityList(Size size, List<Activity> activities) {
    final bool canRead = _checkUserCanRead();

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
        canRead
            ? SizedBox(
                height: activities.isEmpty
                    ? size.height * 0.20
                    : size.height * 0.20,
                child: activities.isEmpty
                    ? Center(
                        child: Text(
                          "Belum ada aktivitas",
                          style: GoogleFonts.figtree(
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
                          final initial = cardTugasViewModel
                              .getMemberInitials(activity.user);

                          return Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.primaries[
                                      userName.hashCode %
                                          Colors.primaries.length],
                                  child: Text(
                                    initial,
                                    style: GoogleFonts.figtree(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName,
                                        style: GoogleFonts.figtree(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      cardTugasViewModel.formatActivityText(
                                          activity.activity),
                                      SizedBox(height: size.height * 0.005),
                                      Text(
                                        cardTugasViewModel
                                            .formatDateTime(activity.createdAt),
                                        style: GoogleFonts.figtree(
                                          color: Colors.grey,
                                          fontSize: 12,
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
              )
            : const SizedBox.shrink()
      ],
    );
  }

  Widget _buildCommentList(Size size, List<Comment> comments) {
    final bool canEdit = _checkUserCanEdit();

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
              ? Center(
                  child: Text(
                    "Belum ada Komentar",
                    style: GoogleFonts.figtree(
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
                    final userId = comment.userId;
                    final commentId = comment.id.toString();
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
                              style: GoogleFonts.figtree(
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
                                  style: GoogleFonts.figtree(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.comment,
                                          style: GoogleFonts.figtree(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.005),
                                        Text(
                                          cardTugasViewModel.formatDateTime(
                                              comment.createdAt),
                                          style: GoogleFonts.figtree(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (canEdit ||
                                        userId == sp.idSharedPreference)
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: SvgPicture.asset(
                                              "assets/pencil.svg",
                                              height: size.height * 0.02,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Colors.blue,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            onPressed: () {
                                              // Edit action
                                              final token =
                                                  sp.tokenSharedPreference;
                                              customShowDialog(
                                                useForm: true,
                                                context: context,
                                                customWidget:
                                                    customTextFormField(
                                                  keyForm: cardTugasViewModel
                                                      .formKey,
                                                  titleText: "Update Komentar",
                                                  controller: cardTugasViewModel
                                                      .commentController,
                                                  labelText:
                                                      "Masukkan komentar yang Baru",
                                                  validator: (value) =>
                                                      cardTugasViewModel
                                                          .validateEditComment(
                                                              value!),
                                                ),
                                                txtButtonL: "Batal",
                                                txtButtonR: "Update",
                                                onPressedBtnL: () {
                                                  cardTugasViewModel
                                                      .commentController
                                                      .clear();
                                                  Navigator.pop(context);
                                                },
                                                onPressedBtnR: () async {
                                                  Navigator.pop(context);

                                                  if (cardTugasViewModel
                                                      .formKey.currentState!
                                                      .validate()) {
                                                    await customAlert(
                                                      alertType: QuickAlertType
                                                          .loading,
                                                      text: "Mohon tunggu...",
                                                      autoClose: false,
                                                    );
                                                    try {
                                                      final response =
                                                          await cardTugasViewModel
                                                              .updateComment(
                                                                  token: token,
                                                                  commentId:
                                                                      commentId);

                                                      if (response == 200) {
                                                        final success =
                                                            await cardTugasViewModel
                                                                .refreshTaskListById(
                                                                    token:
                                                                        token);
                                                        navigatorKey
                                                            .currentState
                                                            ?.pop();

                                                        if (success) {
                                                          await cardTugasViewModel
                                                              .refreshCardTugasData(
                                                                  token: token);
                                                                  cardTugasViewModel.commentController.clear();
                                                        } else {
                                                          customAlert(
                                                            alertType:
                                                                QuickAlertType
                                                                    .error,
                                                            text:
                                                                "Gagal mengupdate komentar. Coba lagi nanti.",
                                                          );
                                                          cardTugasViewModel
                                                              .commentController
                                                              .clear();
                                                        }
                                                      } else {
                                                        navigatorKey
                                                            .currentState
                                                            ?.pop();
                                                        customAlert(
                                                          alertType:
                                                              QuickAlertType
                                                                  .error,
                                                          text:
                                                              "Gagal mengupdate komentar. Coba lagi nanti.",
                                                        );
                                                        cardTugasViewModel
                                                            .commentController
                                                            .clear();
                                                      }
                                                    } catch (e) {
                                                      navigatorKey.currentState
                                                          ?.pop();
                                                      await customAlert(
                                                        alertType:
                                                            QuickAlertType
                                                                .error,
                                                        text:
                                                            'Terjadi kesalahan Silahkan Coba lagi nanti',
                                                      );
                                                      cardTugasViewModel
                                                          .commentController
                                                          .clear();
                                                    }
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          SizedBox(width: size.width * 0.01),
                                          IconButton(
                                            icon: SvgPicture.asset(
                                              "assets/tongsampah.svg",
                                              height: size.height * 0.02,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Colors.red,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            onPressed: () async {
                                              customShowDialog(
                                                context: context,
                                                useForm: false,
                                                text1:
                                                    "Apakah anda yakin ingin menghapus Komentar ini?",
                                                txtButtonL: "Batal",
                                                txtButtonR: "Hapus",
                                                onPressedBtnL: () {
                                                  Navigator.pop(context);
                                                },
                                                onPressedBtnR: () async {
                                                  navigatorKey.currentState
                                                      ?.pop();
                                                  try {
                                                    // Call view model method to update checklist status
                                                    final response =
                                                        await cardTugasViewModel
                                                            .deleteComment(
                                                                token: sp
                                                                    .tokenSharedPreference,
                                                                commentId:
                                                                    commentId);

                                                    if (response == 200) {
                                                      // Refresh task data to show updated checklists
                                                      await cardTugasViewModel
                                                          .refreshTaskListById(
                                                        token: sp
                                                            .tokenSharedPreference,
                                                      );
                                                    } else {
                                                      customAlert(
                                                        alertType:
                                                            QuickAlertType
                                                                .error,
                                                        text: cardTugasViewModel
                                                                .errorMessages ??
                                                            "Gagal Menghapus Notifikasi",
                                                      );
                                                    }
                                                  } catch (e) {
                                                    navigatorKey.currentState
                                                        ?.pop();
                                                    customAlert(
                                                      alertType:
                                                          QuickAlertType.error,
                                                      text:
                                                          "Terjadi kesalahan Silahkan Coba Lagi",
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          SizedBox(width: size.width * 0.01)
                                        ],
                                      )
                                    else
                                      const SizedBox.shrink(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        )
      ],
    );
  }

  // Updated method to include board owner in the count with stacked avatars
  Widget _buildTeamAvatars(Size size, List<dynamic> members) {
    final anggotaViewModel = Provider.of<AnggotaListViewModel>(context);
    if (anggotaViewModel.isLoading) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Text(
          "Anggota",
          style: GoogleFonts.figtree(
            fontSize: 14,
            color: const Color(0xFFB0B0B0),
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
                    style: GoogleFonts.figtree(
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
                      style: GoogleFonts.figtree(
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
            style: GoogleFonts.figtree(
              color: const Color(0xff293066),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  bool _checkUserCanEdit() {
    if (sp == null) return false;

    // Check if user is Super Admin
    if (sp.roleSharedPreference.toLowerCase() == "super admin") {
      return true;
    }

    // Jika data task belum dimuat
    if (cardTugasViewModel.modelFetchTaskId == null) {
      return false;
    }

    final currentUserId = sp.idSharedPreference;
    final task = cardTugasViewModel.modelFetchTaskId!.task;

    // Delegate ke CardTugasViewModel untuk pengecekan permission
    return cardTugasViewModel.canUserEditTaskById(task.id, currentUserId,
        userRole: sp.roleSharedPreference);
  }

  bool _checkUserCanRead() {
    if (sp == null) return false;

    // Check if user is Super Admin
    if (sp.roleSharedPreference.toLowerCase() == "super admin") {
      return true;
    }

    // Jika data task belum dimuat
    if (cardTugasViewModel.modelFetchTaskId == null) {
      return false;
    }

    final currentUserId = sp.idSharedPreference;
    final task = cardTugasViewModel.modelFetchTaskId!.task;

    // Delegate ke CardTugasViewModel untuk pengecekan permission
    return cardTugasViewModel.canUserReadTaskById(task.id, currentUserId,
        userRole: sp.roleSharedPreference);
  }

  void showFilePickerOption(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      )),
      backgroundColor: Colors.white,
      context: context,
      builder: (builder) {
        return SizedBox(
          width: size.width * 0.9,
          height: size.height * 0.26,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              size.width * 0.05,
              size.height * 0.001,
              size.width * 0.05,
              size.height * 0.01,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upload File',
                      style: GoogleFonts.figtree(
                          color: const Color(0xff293066),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          width: size.width * 0.07,
                          height: size.height * 0.07,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff293066),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14.35,
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // First close the bottom sheet
                            Navigator.pop(context);

                            // IMMEDIATELY show loading indicator before file selection
                            customAlert(
                              alertType: QuickAlertType.loading,
                              text: "Mohon tunggu...",
                              autoClose: false,
                            );

                            final token = sp.tokenSharedPreference;
                            final taskId = widget.taskId!;

                            try {
                              // This will trigger the file picker and upload process
                              final response = await cardTugasViewModel
                                  .filePicker(token: token, taskId: taskId);

                              // Close the loading indicator that was shown earlier
                              navigatorKey.currentState?.pop();

                              if (response == 200) {
                                // Refresh the task data to show the uploaded file
                                await cardTugasViewModel.refreshTaskListById(
                                    token: sp.tokenSharedPreference);

                                // Show success message
                                customAlert(
                                  alertType: QuickAlertType.success,
                                  text: "File berhasil diunggah",
                                );
                              } else {
                                // Show error message if upload failed
                                customAlert(
                                  alertType: QuickAlertType.error,
                                  text: cardTugasViewModel.errorMessages ??
                                      "Gagal mengunggah file",
                                );
                              }
                            } on SocketException catch (_) {
                              // Close the loading indicator
                              navigatorKey.currentState?.pop();

                              await customAlert(
                                alertType: QuickAlertType.warning,
                                text:
                                    'Tidak ada koneksi internet. Periksa jaringan Anda.',
                              );
                            } catch (e) {
                              // Close the loading indicator
                              navigatorKey.currentState?.pop();

                              customAlert(
                                alertType: QuickAlertType.error,
                                text: "Terjadi kesalahan, Silahkan Coba lagi",
                              );
                            }
                          },
                          child: Container(
                            width: size.width * 0.2,
                            height: size.height * 0.1,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xff293066),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.folder,
                              color: Color(0xff293066),
                              size: 40,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: Text(
                            'Pick File',
                            style: GoogleFonts.figtree(
                              fontSize: 20,
                              color: const Color(0xff293066),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Tambahkan method ini ke _CustomDetailCardTugasState
  Widget _buildFileSection(List<FileElement> files, Size size) {
    final bool canRead = _checkUserCanRead();
    if (!canRead) {
      return const SizedBox.shrink(); // Return an empty widget if not editable
    }
    return Column(
      children: [
        customFormDetailTugas(
          context: context,
          listContainer: true,
          onTapListContainer: () {
            setState(() {
              _expandedSections['File Lampiran'] =
                  !(_expandedSections['File Lampiran'] ?? false);
            });
          },
          listDataTitle: "File Lampiran",
          animatedTurn: _expandedSections['File Lampiran'] ?? false ? 0.5 : 0,
          maxHeightListData: _expandedSections['File Lampiran'] ?? false
              ? (files.length > 3 ? 3 * 85.0 : files.length * 85.0)
              : 0,
          scrollListData: _expandedSections['File Lampiran'] ?? false
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          opacityDataList:
              _expandedSections['File Lampiran'] ?? false ? 1.0 : 0.0,
          itemDataList: files.map((file) => _buildFileItem(file)).toList(),
          roleCheckerList: false,
          onTapCL: () {
            showFilePickerOption(context);
          },
        ),
      ],
    );
  }

  // Tambahkan method ini untuk menampilkan item file
  Widget _buildFileItem(FileElement file) {
    Size size = MediaQuery.of(context).size;
    final bool canEdit = _checkUserCanEdit();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  // Gunakan getFileIcon dari viewModel
                  cardTugasViewModel.getFileIcon(file.displayName),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.displayName,
                          style: GoogleFonts.figtree(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          file.formattedFileSize,
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  launchURL(file.id);
                },
                icon: const Icon(
                  Icons.download,
                  color: Color(0xFF484F88),
                  size: 22,
                ),
                tooltip: "Download",
              ),
              if (canEdit)
                IconButton(
                  onPressed: () {
                    _deleteFile(file.id);
                  },
                  icon: SvgPicture.asset(
                    'assets/tongsampah.svg',
                    height: size.height * 0.02,
                    width: size.width * 0.02,
                  ),
                  tooltip: "Hapus",
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Tambahkan method untuk menghapus file
  void _deleteFile(int fileId) {
    customShowDialog(
      context: context,
      useForm: false,
      text1: "Apakah anda yakin ingin menghapus file ini?",
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
          final response = await cardTugasViewModel.deleteFile(
            token: sp.tokenSharedPreference,
            fileId: fileId,
          );
          navigatorKey.currentState?.pop();

          if (response == 200) {
            // Refresh task data to show updated checklists
            await cardTugasViewModel.refreshTaskListById(
              token: sp.tokenSharedPreference,
            );
          } else {
            customAlert(
              alertType: QuickAlertType.error,
              text: cardTugasViewModel.errorMessages ?? "Gagal menghapus Files",
            );
          }
        } catch (e) {
          navigatorKey.currentState?.pop();
          customAlert(
            alertType: QuickAlertType.error,
            text: "Terjadi kesalahan Silahkan Coba lagi nanti",
          );
        }
      },
    );
  }
}
