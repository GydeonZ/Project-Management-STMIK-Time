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
  bool _isFetching = false;
  String lastFetchedTaskId = "";
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
  List<Member> _filteredTaskMembers = [];
  String get searchQueryForMembers => _searchQueryForMembers;
  List<Member> get filteredBoardMembers => _filteredTaskMembers;

  AnggotaListViewModel() {
    searchController.addListener(_onSearchChanged);
  }

  Future<bool> getAnggotaList({required String token}) async {
    // Cegah multiple fetch bersamaan
    if (_isFetching) return false;

    try {
      // Cek apakah data sudah ada dan untuk taskId yang sama
      if (modelAnggotaList != null && lastFetchedTaskId == savedTaskId) {
        // Data sudah ada, gunakan cache
        _filteredTaskMembers = modelAnggotaList?.members ?? [];
        notifyListeners();
        return true;
      }

      _isFetching = true;
      isLoading = true;
      notifyListeners();

      final result = await services.fetchAnggotaList(
        token: token,
        taskId: savedTaskId,
      );

      modelAnggotaList = result;
      // Simpan ID task yang baru di-fetch
      lastFetchedTaskId = savedTaskId;

      // Initialize filtered list with all members
      _filteredTaskMembers = modelAnggotaList?.members ?? [];

      if (modelAnggotaList != null) {
        isSukses = true;
        return true;
      } else {
        isSukses = false;
        return false;
      }
    } catch (e) {
      errorMessages = "Terjadi kesalahan saat memuat data";
      isSukses = false;
      return false;
    } finally {
      _isFetching = false; // Reset flag fetch
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> getAvailableAnggotaList({required String token}) async {
    if (_isFetching) return false;

    try {
      if (modelAvailableAnggotaList != null &&
          lastFetchedTaskId == savedTaskId) {
        _filteredTaskMembers = modelAnggotaList?.members ?? [];
        notifyListeners();
        return true;
      }

      _isFetching = true;
      isLoading = true;
      notifyListeners();

      final result = await servicesAvailableMember.fetchAvailableAnggotaList(
        token: token,
        taskId: savedTaskId,
      );

      modelAvailableAnggotaList = result;
      lastFetchedTaskId = savedTaskId;
      // Initialize filtered list with all members
      _filteredMembers = modelAvailableAnggotaList?.data ?? [];

      if (modelAvailableAnggotaList != null) {
        isSukses = true;
        return true;
      } else {
        isSukses = false;
        return false;
      }
    } catch (e) {
      errorMessages = "Terjadi kesalahan saat memuat data";
      isSukses = false;
      return false;
    } finally {
      _isFetching = false; // Reset flag fetch
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
    // Reset flag fetching untuk memungkinkan refresh meskipun taskId sama
    _isFetching = false;

    try {
      isLoading = true;
      notifyListeners();

      final result = await services.fetchAnggotaList(
        token: token,
        taskId: savedTaskId,
      );

      if (result != null) {
        modelAnggotaList = result;
        lastFetchedTaskId = savedTaskId;

        // Perbarui filtered list agar mencerminkan perubahan role
        _filteredTaskMembers = modelAnggotaList?.members ?? [];

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
    } catch (e) {
      errorMessages = "Terjadi kesalahan Silahkan Coba lagi nanti";
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
      _filteredTaskMembers = modelAnggotaList?.members ?? [];
    } else {
      // Filter berdasarkan nama, email, atau role
      _filteredTaskMembers = (modelAnggotaList?.members ?? []).where((member) {
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
    _filteredTaskMembers = modelAnggotaList?.members ?? [];
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

  void loadCachedAnggotaList() {
    if (modelAnggotaList != null) {
      // Gunakan data yang sudah ada
      _filteredTaskMembers = modelAnggotaList?.members ?? [];

      // Terapkan filter jika ada pencarian aktif
      if (_searchQueryForMembers.isNotEmpty) {
        searchBoardMembers(_searchQueryForMembers);
      }
      notifyListeners();
    }
  }
}
