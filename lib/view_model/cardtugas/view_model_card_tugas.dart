import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_card_tugas.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_tasklist_id.dart';
import 'package:projectmanagementstmiktime/services/service_add_tugas.dart';
import 'package:projectmanagementstmiktime/services/service_card_tugas.dart';
import 'package:projectmanagementstmiktime/services/service_checklist.dart';
import 'package:projectmanagementstmiktime/services/service_delete_task_detail.dart';
import 'package:projectmanagementstmiktime/services/service_edit_task_detail.dart';
import 'package:projectmanagementstmiktime/services/service_fetch_tasklist_id.dart';
import 'package:projectmanagementstmiktime/services/service_tambah_card_tugas.dart';
import 'dart:io';
import 'package:projectmanagementstmiktime/services/service_task_attachment.dart';

class CardTugasViewModel with ChangeNotifier {
  ModelFetchCardTugas? modelFetchCardTugas;
  ModelFetchTaskId? modelFetchTaskId;
  TextEditingController namaCard = TextEditingController();
  TextEditingController namaTugas = TextEditingController();
  TextEditingController deskripsiTugas = TextEditingController();
  TextEditingController clName = TextEditingController();
  final services = CardTugasService();
  final clService = ChecklistService();
  final service = TambahCardTugasService();
  final deleteDetailTugasService = DeleteDetailTaskService();
  final taskService = TambahTugasService();
  final editTaskService = EditDetailTaskService();
  final fetchTaskListService = FetchTaskListIdService();
  final uploadFileService = UploadFileService();
  bool isLoading = false;
  bool isSukses = false;
  bool heightContainer = false;
  String savedBoardId = "";
  String savedTaskId = "";
  String cardId = "";
  String checklistId = "";
  String? successMessage;
  String? errorMessages;
  final formKey = GlobalKey<FormState>();
  DateTime start = DateTime.now();
  DateTime end = DateTime.now().add(const Duration(days: 30));
  bool isStartDateSelected = false;
  bool isEndDateSelected = false;

  File? uploadedFile;
  String? uploadedFileName;
  bool isFileTooLarge = false;
  bool isUploading = false;
  bool hasUploadedFile = false;
  final int maxFileSizeBytes = 10 * 1024 * 1024; // 10MB

  String get startTimeLabel {
    if (!isStartDateSelected) {
      return "Waktu mulai...";
    }

    return "Mulai ${formatTime(start.toIso8601String())}";
  }

  String get endTimeLabel {
    if (!isEndDateSelected) {
      return "Waktu selesai...";
    }

    return "Selesai ${formatTime(end.toIso8601String())}";
  }

  /// 🔹 Fetch Board List (dengan token)
  Future<int> getCardTugasList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();
      modelFetchCardTugas = await services.fetchCardTugas(token: token);
      isLoading = false;
      if (modelFetchCardTugas != null) {
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();
      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    } finally {
      isLoading = false; // Pastikan loading diatur ke false setelah selesai
      notifyListeners();
    }
  }

  Future<bool> refreshCardTugasData({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await services.fetchCardTugas(token: token);

      if (result != null) {
        modelFetchCardTugas = result;
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
        errorMessages = '';
        return true;
      } else {
        isSukses = false;
        errorMessages = 'Data tidak ditemukan';
        return false;
      }
    } on DioException catch (e) {
      errorMessages = "Terjadi kesalahan: ${e.message}";
      return false;
    } catch (e) {
      errorMessages = "Error tidak terduga: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> refreshTaskListById({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await fetchTaskListService.fetchTaskListId(
        token: token,
        taskId: savedTaskId,
      );

      if (result != null) {
        modelFetchTaskId = result;
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
        errorMessages = '';
        return true;
      } else {
        isSukses = false;
        errorMessages = 'Data tidak ditemukan';
        return false;
      }
    } on DioException catch (e) {
      errorMessages = "Terjadi kesalahan: ${e.message}";
      return false;
    } catch (e) {
      errorMessages = "Error tidak terduga: $e";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? validateNamaCard(String value) {
    if (value.trim().isEmpty) {
      heightContainer = true;
      notifyListeners();
      return 'Nama tugas tidak boleh kosong';
    }
    heightContainer = false;
    notifyListeners();
    return null;
  }

  String? validateDeskripsiTugas(String value) {
    if (value.trim().isEmpty) {
      heightContainer = true;
      notifyListeners();
      return 'Deskripsi tugas tidak boleh kosong';
    }
    heightContainer = false;
    notifyListeners();
    return null;
  }

  String? validateNamaChecklist(String value) {
    if (value.trim().isEmpty) {
      heightContainer = true;
      notifyListeners();
      return 'Judul Checklist tugas tidak boleh kosong';
    }
    heightContainer = false;
    notifyListeners();
    return null;
  }

  void setBoardId(String boardId) {
    savedBoardId = boardId;
    notifyListeners(); // Memastikan UI diperbarui jika diperlukan
  }

  void setTaskId(String taskId) {
    savedTaskId = taskId;
    notifyListeners(); // Memastikan UI diperbarui jika diperlukan
  }

  Future<int> tambahTugasCard({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.hitTambahCardTugas(
        token: token,
        namaCard: namaCard.text,
        boardId: savedBoardId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> deleteTugasCard({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.hitDeleteCardTugas(
        token: token,
        cardId: cardId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> updateTugasCard({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.hitUpdateCardTugas(
        token: token,
        namaCard: namaCard.text,
        cardId: cardId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> updatePosTugasCard({
    required String token,
    required int taskId,
    required int cardId,
    required int newPosition, // Pastikan nilai ini minimal 1
  }) async {
    try {
      // Validasi posisi minimal 1
      if (newPosition < 1) {
        newPosition = 1; // Force minimal position to 1
      }

      isLoading = true;
      notifyListeners();

      final response = await service.hitUpdateMoveTask(
          token: token, taskId: taskId, cardId: cardId, position: newPosition);

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.response?.data['message'] ?? e.message;
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> updatePosCard({
    required String token,
    required int cardId,
    required int boardId,
    required int newPosition, // Pastikan nilai minimal 1
  }) async {
    try {
      // Validasi posisi minimal 1
      if (newPosition < 1) {
        newPosition = 1; // Force minimal position to 1
      }

      isLoading = true;
      notifyListeners();

      final response = await service.hitUpdateCardPosition(
        token: token,
        cardId: cardId,
        position: newPosition,
        boardId: boardId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.response?.data['message'] ?? e.message;
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> tambahTugas({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await taskService.hitTambahTugas(
        token: token,
        namaCard: namaTugas.text,
        deskripsiTugas: deskripsiTugas.text,
        startDate: start,
        endDate: end,
        cardId: cardId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        namaTugas.clear();
        deskripsiTugas.clear();
        heightContainer = false;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    // Mendapatkan tanggal hari ini
    final DateTime now = DateTime.now();

    // Pastikan tanggal akhir tidak sebelum tanggal mulai atau hari ini
    DateTime minDate = start.isAfter(now) ? start : now;

    // Menentukan tanggal awal untuk picker
    // Pastikan initialDate tidak sebelum firstDate (tanggal mulai atau hari ini)
    DateTime initialDate;
    if (isEndDateSelected) {
      // Jika ada tanggal yang sudah dipilih sebelumnya
      if (end.isBefore(minDate)) {
        // Jika tanggal akhir sebelum tanggal mulai atau hari ini, gunakan tanggal mulai
        initialDate = minDate;
      } else {
        initialDate = end;
      }
    } else {
      // Jika belum ada tanggal yang dipilih, gunakan tanggal mulai + 1 hari
      initialDate = start.add(const Duration(days: 1));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate:
          minDate, // Tidak bisa memilih sebelum tanggal mulai atau hari ini
      lastDate: DateTime(now.year + 5, now.month, now.day), // 5 tahun ke depan
    );

    if (picked != null) {
      // Setelah tanggal dipilih, tampilkan time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            isEndDateSelected ? end : start.add(const Duration(hours: 1))),
      );

      if (pickedTime != null) {
        // Gabungkan tanggal dan waktu yang dipilih
        final newDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Validasi tanggal akhir harus setelah tanggal mulai
        if (newDateTime.isAfter(start)) {
          // Update state
          isEndDateSelected = true;
          end = newDateTime;
          notifyListeners();
        } else {
          // Tampilkan pesan error jika tanggal akhir sebelum tanggal mulai
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Waktu selesai harus setelah waktu mulai"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    // Mendapatkan tanggal hari ini
    final DateTime now = DateTime.now();

    // Menentukan tanggal awal untuk picker
    // Pastikan initialDate tidak sebelum firstDate
    DateTime initialDate;
    if (isStartDateSelected) {
      // Jika ada tanggal yang sudah dipilih sebelumnya
      if (start.isBefore(now)) {
        // Jika tanggal sebelumnya sebelum hari ini, gunakan hari ini sebagai initialDate
        initialDate = now;
      } else {
        initialDate = start;
      }
    } else {
      initialDate = now;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.subtract(const Duration(days: 365)), // 1 tahun ke belakang
      lastDate: DateTime(now.year + 5, now.month, now.day), // 5 tahun ke depan
    );

    if (picked != null) {
      // Setelah tanggal dipilih, tampilkan time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            isStartDateSelected ? start : DateTime.now()),
      );

      if (pickedTime != null) {
        // Gabungkan tanggal dan waktu yang dipilih
        final newDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Update state
        isStartDateSelected = true;
        start = newDateTime;
        notifyListeners();
      }
    }
  }

  void clearForm() {
    namaTugas.clear();
    deskripsiTugas.clear();
    start = DateTime.now();
    end = DateTime.now().add(const Duration(days: 30));
    isStartDateSelected = false;
    isEndDateSelected = false;
    heightContainer = false;
    notifyListeners();
  }

  String formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);

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

  Future<int> getTaskListById({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      // Fix: Use savedTaskId to fetch the task
      modelFetchTaskId = await fetchTaskListService.fetchTaskListId(
        token: token,
        taskId: savedTaskId,
      );

      isLoading = false;

      // Fix: Check modelFetchTaskId instead of modelFetchCardTugas
      if (modelFetchTaskId != null) {
        isSukses = true;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();
      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    } finally {
      isLoading = false; // Pastikan loading diatur ke false setelah selesai
      notifyListeners();
    }
  }

// Get initials from a member object
  String getMemberInitials(dynamic member) {
    try {
      // Check if member has a name property
      if (member is Member) {
        // Direct access to name as string
        return getInitialsFromName(member.user.name);
      }
      // If member is a Map, try to access the name key
      else if (member is Map && member.containsKey('name')) {
        final name = member['name'].toString();
        return getInitialsFromName(name);
      }
      // If member is a dynamic object with name property
      else if (member != null && member.name != null) {
        final name = member.name.toString();
        return getInitialsFromName(name);
      }
      // Fallback
      return "?";
    } catch (e) {
      return "?";
    }
  }

// Extract initials from a name string
  String getInitialsFromName(String name) {
    if (name.isEmpty) return "?";

    final nameParts = name.split(' ');
    if (nameParts.length == 1) {
      // If single name, return first 2 chars or just first if name is 1 char
      return name.length > 1
          ? name.substring(0, 2).toUpperCase()
          : name.toUpperCase();
    } else {
      // Get first letter of first and last name
      final firstInitial = nameParts.first.isNotEmpty ? nameParts.first[0] : "";
      final lastInitial = nameParts.last.isNotEmpty ? nameParts.last[0] : "";
      return (firstInitial + lastInitial).toUpperCase();
    }
  }

  // Format DateTime to Indonesian format
  // Format DateTime to Indonesian format with Jakarta timezone (WIB)
  String formatDateTime(DateTime dateTime) {
    try {
      // Mengkonversi ke timezone Jakarta (UTC+7)
      final jakartaOffset = const Duration(hours: 7);
      final jakartaDateTime = dateTime.toUtc().add(jakartaOffset);

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

      String hari = jakartaDateTime.day.toString();
      String bulan = namaBulan[jakartaDateTime.month - 1];
      String tahun = jakartaDateTime.year.toString();
      String jam = jakartaDateTime.hour.toString().padLeft(2, '0');
      String menit = jakartaDateTime.minute.toString().padLeft(2, '0');

      return "$hari $bulan $tahun jam $jam.$menit WIB";
    } catch (e) {
      return "Format waktu tidak valid";
    }
  }

  Future<int> updateTaskStartDates({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await editTaskService.editStartTime(
        token: token,
        taskId: savedTaskId,
        startDate: start,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message;
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> updateTaskEndDates({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await editTaskService.editEndTime(
        token: token,
        taskId: savedTaskId,
        endDate: end,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message;
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> updateDeskripsiTugas({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await editTaskService.editDetailTaskDeskripsi(
        token: token,
        deskripsiTugas: deskripsiTugas.text,
        taskId: savedTaskId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        namaTugas.clear();
        heightContainer = false;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  bool isUserBoardOwner(String userId) {
    final task = modelFetchTaskId?.task;
    final boardOwnerId = task?.card.board.userId.toString();

    return userId == boardOwnerId;
  }

  Future<int> deleteDetailTugas({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await deleteDetailTugasService.hitDeleteDetailTask(
        token: token,
        taskId: savedTaskId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        namaCard.clear();
        heightContainer = false;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<int> updateJudulTugas({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await editTaskService.hitUpdateJudulTugas(
        token: token,
        judulDetailTask: namaTugas.text,
        taskId: savedTaskId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        namaTugas.clear();
        heightContainer = false;
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  // Add to your CardTugasViewModel class

  Future<int> toggleChecklistStatus({
    required String token,
    required int checklistId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await clService.toggleCheckList(
        token: token,
        clID: checklistId,
      );

      isLoading = false;
      notifyListeners();

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        return 200;
      } else {
        errorMessages = "Gagal mengupdate checklist";
        return 400;
      }
    } catch (e) {
      isLoading = false;
      errorMessages = e.toString();
      notifyListeners();
      return 500;
    }
  }

  Future<int> addChecklist({
    required String token,
    required int taskId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await clService.addCheckList(
        token: token,
        taskId: taskId,
        clName: clName.text,
      );

      isLoading = false;
      notifyListeners();

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        return 200;
      } else {
        errorMessages = "Gagal mengupdate nama checklist";
        return 400;
      }
    } catch (e) {
      isLoading = false;
      errorMessages = e.toString();
      notifyListeners();
      return 500;
    }
  }

  Future<int> updateChecklistName({
    required String token,
    required int checklistId,
    required String name,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await clService.updateNameCheckList(
        token: token,
        clID: checklistId,
        clName: name,
      );

      isLoading = false;
      notifyListeners();

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        return 200;
      } else {
        errorMessages = "Gagal mengupdate nama checklist";
        return 400;
      }
    } catch (e) {
      isLoading = false;
      errorMessages = e.toString();
      notifyListeners();
      return 500;
    }
  }

  Future<int> deleteChecklist({
    required String token,
    required int checklistId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await clService.deleteChecklist(
        token: token,
        clID: checklistId,
      );

      isLoading = false;
      notifyListeners();

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        return 200;
      } else {
        errorMessages = "Gagal menghapus checklist";
        return 400;
      }
    } catch (e) {
      isLoading = false;
      errorMessages = e.toString();
      notifyListeners();
      return 500;
    }
  }

  Future<int> filePicker({
    required String token,
    required int taskId,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        // Check file size
        int fileSize = await file.length();
        if (fileSize > maxFileSizeBytes) {
          isFileTooLarge = true;
          errorMessages = "Ukuran file melebihi batas maksimal 10MB";
          notifyListeners();
          return 400; // Return code untuk file terlalu besar
        }

        isFileTooLarge = false;
        uploadedFile = file;
        uploadedFileName = result.files.single.name;
        isUploading = true;
        notifyListeners();

        // Call the service method to upload the file
        final response = await uploadFileService.uploadFileToServer(
          file: file,
          token: token,
          taskId: taskId,
        );

        isUploading = false;
        notifyListeners();

        if (response != null) {
          hasUploadedFile = true;
          successMessage = response.message;
          errorMessages = null;
          return 200; // Return success code
        } else {
          uploadedFile = null;
          uploadedFileName = null;
          errorMessages = "Gagal mengunggah file";
          return 500; // Return error code
        }
      } else {
        // User canceled file selection
        return 0; // Return code untuk canceled
      }
    } catch (e) {
      isLoading = false;
      errorMessages = e.toString();
      notifyListeners();
      return 500; // Return error code
    }
  }

  Future<int> deleteFile({
    required String token,
    required int fileId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await uploadFileService.deleteChecklist(
        token: token,
        fileId: fileId,
      );

      isLoading = false;
      notifyListeners();

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        return 200;
      } else {
        errorMessages = "Gagal menghapus checklist";
        return 400;
      }
    } catch (e) {
      isLoading = false;
      errorMessages = e.toString();
      notifyListeners();
      return 500;
    }
  }

  // Tambahkan fungsi ini ke CardTugasViewModel
  Widget getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    IconData iconData;
    Color iconColor;

    switch (extension) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'doc':
      case 'docx':
        iconData = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        iconData = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        iconData = Icons.image;
        iconColor = Colors.purple;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return Icon(iconData, color: iconColor, size: 36);
  }

  // Tambahkan metode ini ke class CardTugasViewModel
  Widget formatActivityText(String activityText) {
    // Regular expression untuk mencari teks di dalam tanda kutip
    final RegExp quotePattern = RegExp(r"'([^']*)'");

    // Jika tidak ada tanda kutip, tampilkan teks biasa
    if (!quotePattern.hasMatch(activityText)) {
      return Text(
        activityText,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'helvetica',
          fontSize: 14,
        ),
      );
    }

    // Jika ada tanda kutip, format sesuai kebutuhan
    final match = quotePattern.firstMatch(activityText);
    if (match != null) {
      final beforeQuote = activityText.substring(0, match.start);
      final quotedText = match.group(1)!; // Teks dalam tanda kutip
      final afterQuote = activityText.substring(match.end);

      return RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'helvetica',
            fontSize: 14,
          ),
          children: [
            TextSpan(text: beforeQuote),
            TextSpan(
              text: quotedText, // Tanpa tanda kutip
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: afterQuote),
          ],
        ),
      );
    } else {
      return Text(
        activityText,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'helvetica',
          fontSize: 14,
        ),
      );
    }
  }
}
