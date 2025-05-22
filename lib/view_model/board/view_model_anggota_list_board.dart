import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_available_member_board.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_member_board.dart';
import 'package:projectmanagementstmiktime/services/service_anggota_list_board.dart';
import 'package:projectmanagementstmiktime/services/service_available_board_anggota.dart';

class BoardAnggotaListViewModel with ChangeNotifier {
  ModelFetchBoardMember? modelFetchBoardMember;
  ModelFetchAvailableBoardMember? modelFetchAvailableBoardMember;
  final services = BoardAnggotaListService();
  final serviceAvailableMember = AvailableBoardAnggotaListService();
  bool isLoading = false;
  bool isSukses = false;
  String savedBoardId = "";
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

  BoardAnggotaListViewModel() {
    searchController.addListener(_onSearchChanged);
  }

  void searchBoardMembers(String query) {
    _searchQueryForMembers = query.toLowerCase().trim();

    if (_searchQueryForMembers.isEmpty) {
      // Jika pencarian kosong, tampilkan semua member
      _filteredBoardMembers = modelFetchBoardMember?.members ?? [];
    } else {
      // Filter berdasarkan nama, email, atau role
      _filteredBoardMembers =
          (modelFetchBoardMember?.members ?? []).where((member) {
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
    _filteredBoardMembers = modelFetchBoardMember?.members ?? [];
    notifyListeners();
  }

  Future<void> getBoardAnggotaList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await services.fetchBoardAnggotaList(
        token: token,
        boardId: savedBoardId,
      );

      modelFetchBoardMember = result;

      // Initialize filtered list with all members
      _filteredBoardMembers = result?.members ?? [];

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAvailableBoardAnggotaList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result =
          await serviceAvailableMember.fetchAvailableBoardAnggotaList(
        token: token,
        boardId: savedBoardId,
      );

      modelFetchAvailableBoardMember = result;

      // Initialize filtered list with all members
      _filteredMembers = modelFetchAvailableBoardMember?.data ?? [];

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<int> editAnggotaRole({
    required String token,
    String? level,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final userLevel = level ?? _selectedMemberLevel;
      final response = await services.editAnggotaList(
        token: token,
        boardId: savedBoardId,
        userId: savedUserId,
        userLevel: userLevel,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
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

  Future<int> deleteAnggota({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await services.deleteAnggotaBoard(
        token: token,
        boardId: savedBoardId,
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

      final result = await services.fetchBoardAnggotaList(
          token: token, boardId: savedBoardId);

      if (result != null) {
        modelFetchBoardMember = result;
        // Perbarui filtered list agar mencerminkan perubahan role
        _filteredBoardMembers = modelFetchBoardMember?.members ?? [];

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
      final response = await services.addBoardAnggotaList(
        token: token,
        boardId: savedBoardId,
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

  void setTaskId(String boardId) {
    savedBoardId = boardId;
    notifyListeners(); // Memastikan UI diperbarui jika diperlukan
  }

  // RoleUserInBoard getUserRoleFromAnggota(
  //     ModelFetchBoardMember boardAnggotaList, int userId) {
  //   // Check if the user is the board owner
  //   if (boardAnggotaList.boardOwner.id == userId) {
  //     return RoleUserInBoard.owner;
  //   }

  //   // Check if the user is in the members list
  //   try {
  //     final member = boardAnggotaList.members.firstWhere(
  //       (member) => member.user.id == userId,
  //     );

  //     // If we got here, a member was found
  //     // Check the member's level
  //     if (member.level == "Admin") {
  //       return RoleUserInBoard.admin;
  //     } else if (member.level == "Member") {
  //       return RoleUserInBoard.member;
  //     }
  //   } catch (e) {
  //     // No member was found with that ID
  //   }
  //   return RoleUserInBoard.unknown;
  // }

  void searchAvailableMembers(String query) {
    _searchQuery = query.toLowerCase().trim();

    if (_searchQuery.isEmpty) {
      // Reset ke semua member jika pencarian kosong
      _filteredMembers = modelFetchAvailableBoardMember?.data ?? [];
    } else {
      // Filter berdasarkan nama dan email
      _filteredMembers =
          (modelFetchAvailableBoardMember?.data ?? []).where((user) {
        final nameMatch = user.name.toLowerCase().contains(_searchQuery);
        final emailMatch = user.email.toLowerCase().contains(_searchQuery);
        return nameMatch || emailMatch;
      }).toList();
    }

    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = "";
    searchController.text = ""; // Pastikan controller text juga diupdate
    _filteredMembers = modelFetchAvailableBoardMember?.data ?? [];
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
