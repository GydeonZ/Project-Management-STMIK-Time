import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_card_tugas.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_tasklist_id.dart';
import 'package:projectmanagementstmiktime/services/service_add_tugas.dart';
import 'package:projectmanagementstmiktime/services/service_card_tugas.dart';
import 'package:projectmanagementstmiktime/services/service_delete_task_detail.dart';
import 'package:projectmanagementstmiktime/services/service_edit_task_detail.dart';
import 'package:projectmanagementstmiktime/services/service_fetch_tasklist_id.dart';
import 'package:projectmanagementstmiktime/services/service_tambah_card_tugas.dart';

class CardTugasViewModel with ChangeNotifier {
  ModelFetchCardTugas? modelFetchCardTugas;
  ModelFetchTaskId? modelFetchTaskId;
  TextEditingController namaCard = TextEditingController();
  TextEditingController namaTugas = TextEditingController();
  TextEditingController deskripsiTugas = TextEditingController();
  final services = CardTugasService();
  final service = TambahCardTugasService();
  final deleteDetailTugasService = DeleteDetailTaskService();
  final taskService = TambahTugasService();
  final editTaskService = EditDetailTaskService();
  final fetchTaskListService = FetchTaskListIdService();
  bool isLoading = false;
  bool isSukses = false;
  bool heightContainer = false;
  String savedBoardId = "";
  String savedTaskId = "";
  String cardId = "";
  String? successMessage;
  String? errorMessages;
  final formKey = GlobalKey<FormState>();
  DateTime start = DateTime.now();
  DateTime end = DateTime.now().add(const Duration(days: 30));
  bool isStartDateSelected = false;
  bool isEndDateSelected = false;

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
    final pickedEndDate = await showDatePicker(
      context: context,
      initialDate: end,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedEndDate != null) {
      // Tambahkan pemilih waktu (timepicker)
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(end),
      );

      if (pickedTime != null) {
        // Gabungkan tanggal dan waktu yang dipilih
        final newDateTime = DateTime(
          pickedEndDate.year,
          pickedEndDate.month,
          pickedEndDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (newDateTime.isAfter(start)) {
          end = newDateTime;
          isEndDateSelected = true; // Set flag ke true ketika dipilih
          notifyListeners();
        } else {
          // Tampilkan pesan error jika diperlukan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Waktu selesai harus setelah waktu mulai'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    final pickedStartDate = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedStartDate != null) {
      // Tambahkan pemilih waktu (timepicker)
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(start),
      );

      if (pickedTime != null) {
        // Gabungkan tanggal dan waktu yang dipilih
        final newDateTime = DateTime(
          pickedStartDate.year,
          pickedStartDate.month,
          pickedStartDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        start = newDateTime;
        isStartDateSelected = true; // Set flag ke true ketika dipilih

        // Update end date jika start date lebih lambat
        if (end.isBefore(start)) {
          end = start.add(const Duration(hours: 1));
          isEndDateSelected = true;
        }

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
}
