import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/model/model_available_anggota_list.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_anggota_list.dart';
import 'package:projectmanagementstmiktime/services/service_anggota_list.dart';
import 'package:projectmanagementstmiktime/services/service_available_anggota.dart';
import 'package:projectmanagementstmiktime/utils/state/finite_state.dart';

class AnggotaListViewModel with ChangeNotifier {
  ModelAnggotaList? modelAnggotaList;
  ModelAvailableAnggotaList? modelAvailableAnggotaList;
  final services = AnggotaListService();
  final servicesAvailableMember = AvailableAnggotaListService();
  bool isLoading = false;
  bool isSukses = false;
  String savedTaskId = "";
  String savedUserId = "";
  String? successMessage;
  String? errorMessages;
  TextEditingController searchController = TextEditingController();

  String _searchQuery = "";
  List<Datum> _filteredMembers = [];
  final List<String> availableMemberLevels = ["Member", "Admin"];
  String _selectedMemberLevel = "Member";
  String get selectedMemberLevel => _selectedMemberLevel;

  String get searchQuery => _searchQuery;
  List<Datum> get filteredMembers => _filteredMembers;

  String _searchQueryForMembers = "";
  List<Member> _filteredBoardMembers = [];
  String get searchQueryForMembers => _searchQueryForMembers;
  List<Member> get filteredBoardMembers => _filteredBoardMembers;

  AnggotaListViewModel() {
    searchController.addListener(_onSearchChanged);
  }

  Future<void> getAnggotaList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await services.fetchAnggotaList(
        token: token,
        taskId: savedTaskId,
      );

      modelAnggotaList = result;

      // Initialize filtered list with all members
      _filteredBoardMembers = modelAnggotaList?.members ?? [];

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAvailableAnggotaList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await servicesAvailableMember.fetchAvailableAnggotaList(
        token: token,
        taskId: savedTaskId,
      );

      modelAvailableAnggotaList = result;

      // Initialize filtered list with all members
      _filteredMembers = modelAvailableAnggotaList?.data ?? [];

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<int> deleteAnggota({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await services.deleteAnggota(
        token: token,
        taskId: savedTaskId,
        userId: savedUserId,
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
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }

  Future<bool> refreshAnggotaList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result =
          await services.fetchAnggotaList(token: token, taskId: savedTaskId);

      if (result != null) {
        modelAnggotaList = result;
        // Perbarui filtered list agar mencerminkan perubahan role
        _filteredBoardMembers = modelAnggotaList?.members ?? [];

        // Jika pencarian aktif, aplikasikan kembali filter
        if (_searchQueryForMembers.isNotEmpty) {
          searchBoardMembers(_searchQueryForMembers);
        }

        isSukses = true;
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

  Future<int> tambahAnggotaList({
    required String token,
    String? level,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final userLevel = level ?? _selectedMemberLevel;
      final response = await services.addAnggotaList(
        token: token,
        taskId: savedTaskId,
        userId: savedUserId,
        userLevel: userLevel,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        savedUserId = "";
        _selectedMemberLevel = "Member";
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

  Future<int> editAnggotaList({
    required String token,
    String? level,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final userLevel = level ?? _selectedMemberLevel;
      final response = await services.editAnggotaList(
        token: token,
        taskId: savedTaskId,
        userId: savedUserId,
        userLevel: userLevel,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        savedUserId = "";
        _selectedMemberLevel = userLevel;
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

  void setTaskId(String taskId) {
    savedTaskId = taskId;
    notifyListeners(); // Memastikan UI diperbarui jika diperlukan
  }

  RoleUserInBoard getUserRoleFromAnggota(
      ModelAnggotaList anggotaList, int userId) {
    // Check if the user is the board owner
    if (anggotaList.boardOwner.id == userId) {
      return RoleUserInBoard.owner;
    }

    // Check if the user is in the members list
    try {
      final member = anggotaList.members.firstWhere(
        (member) => member.user.id == userId,
      );

      // If we got here, a member was found
      // Check the member's level
      if (member.level == "Admin") {
        return RoleUserInBoard.admin;
      } else if (member.level == "Member") {
        return RoleUserInBoard.member;
      }
    } catch (e) {
      // No member was found with that ID
    }
    return RoleUserInBoard.unknown;
  }

  void searchAvailableMembers(String query) {
    _searchQuery = query.toLowerCase();

    if (_searchQuery.isEmpty) {
      _filteredMembers = modelAvailableAnggotaList?.data ?? [];
    } else {
      _filteredMembers = (modelAvailableAnggotaList?.data ?? [])
          .where((user) => user.name.toLowerCase().contains(_searchQuery))
          .toList();
    }

    notifyListeners();
  }

  void searchBoardMembers(String query) {
    _searchQueryForMembers = query.toLowerCase().trim();

    if (_searchQueryForMembers.isEmpty) {
      // Jika pencarian kosong, tampilkan semua member
      _filteredBoardMembers = modelAnggotaList?.members ?? [];
    } else {
      // Filter berdasarkan nama, email, atau role
      _filteredBoardMembers = (modelAnggotaList?.members ?? []).where((member) {
        final user = member.user;
        return user.name.toLowerCase().contains(_searchQueryForMembers) ||
            user.email.toLowerCase().contains(_searchQueryForMembers) ||
            user.role.toLowerCase().contains(_searchQueryForMembers);
      }).toList();
    }

    notifyListeners();
  }

  void clearBoardMemberSearch() {
    _searchQueryForMembers = "";
    _filteredBoardMembers = modelAnggotaList?.members ?? [];
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = "";
    _filteredMembers = modelAvailableAnggotaList?.data ?? [];
    notifyListeners();
  }

  void _onSearchChanged() {
    searchAvailableMembers(searchController.text);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void setSelectedMemberLevel(String level) {
    if (availableMemberLevels.contains(level)) {
      _selectedMemberLevel = level;
      notifyListeners();
    }
  }
}
