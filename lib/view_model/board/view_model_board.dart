import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:projectmanagementstmiktime/model/model_board.dart';
import 'package:projectmanagementstmiktime/services/sevices_board.dart';
import 'package:projectmanagementstmiktime/utils/state/finite_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardViewModel with ChangeNotifier {
  ModelBoard? modelBoard;
  TextEditingController judulBoard = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final services = BoardService();
  String _tanggalTerformat = '';
  bool isLoading = false;
  bool isSukses = false;
  bool heightContainer = false;
  String userName = "";
  String nameSharedPreference = '';
  String? successMessage;
  String? errorMessages;
  final formKey = GlobalKey<FormState>();
  final List<String> availableBoardVisibility = ["Public", "Private"];
  final String _selectedBoardVisibility = "Public";
  String get selectedBoardVisibility => _selectedBoardVisibility;
  String get tanggalTerformat => _tanggalTerformat;

  String _searchQuery = "";
  List<Datum> _filteredBoards = [];

  String get searchQuery => _searchQuery;
  List<Datum> get filteredBoards => _filteredBoards;

  BoardViewModel() {
    _loadUserName();
    _perbaruiTanggal();
    searchController.addListener(_onSearchChanged);
    _filteredBoards = [];
  }

  void _onSearchChanged() {
    searchBoards(searchController.text);
  }

  void searchBoards(String query) {
    _searchQuery = query.toLowerCase().trim();

    if (_searchQuery.isEmpty) {
      // Jika pencarian kosong, tampilkan semua board
      _filteredBoards = modelBoard?.data ?? [];
    } else {
      // Filter board berdasarkan nama board atau nama user
      _filteredBoards = (modelBoard?.data ?? []).where((board) {
        final boardName = board.name.toLowerCase();
        final userName = board.user.name.toLowerCase();

        return boardName.contains(_searchQuery) ||
            userName.contains(_searchQuery);
      }).toList();
    }

    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    _searchQuery = "";
    _filteredBoards = modelBoard?.data ?? [];
    notifyListeners();
  }

  Future<int> editBoard({
    required String? token,
    String? visibility,
    required String encryptId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final boardVisibility = visibility ?? _selectedBoardVisibility;
      final response = await services.updateBoard(
        encryptId: encryptId,
        token: token,
        boardName: judulBoard.text,
        visibility: boardVisibility,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        judulBoard.text = '';
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

  /// 🔹 Fetch Board List (dengan token)
  Future<void> getBoardList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      modelBoard = await services.fetchBoard(token: token);
      _filteredBoards = modelBoard?.data ?? [];

      isLoading = false;
    } catch (e) {
      isLoading = false;
    }
    notifyListeners();
  }

  Future<bool> refreshBoardList({required String? token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await services.fetchBoard(
        token: token,
      );

      if (result != null) {
        modelBoard = result;
        if (_searchQuery.isNotEmpty) {
          searchBoards(_searchQuery);
        } else {
          _filteredBoards = modelBoard?.data ?? [];
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

  /// 🔹 Ambil Username dari SharedPreferences
  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedFullName = prefs.getString('name') ?? "User";
    nameSharedPreference = storedFullName;
    notifyListeners();
  }

  /// 🔹 Perbarui Tanggal
  Future<void> _perbaruiTanggal() async {
    await initializeDateFormatting('id_ID', null);
    _tanggalTerformat =
        DateFormat('EEEE, d MMMM', 'id_ID').format(DateTime.now());
    notifyListeners();
  }

  String? validateBoardName(String value) {
    if (value.isEmpty) {
      heightContainer = true;
      notifyListeners();
      return 'Nama Dashboard Tidak Boleh Kosong';
    }
    heightContainer = false;
    notifyListeners();
    return null;
  }

  Future<int> deleteBoard({
    required String? token,
    required String encryptId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await services.deleteBoard(
        token: token,
        encryptId: encryptId,
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

      // Ambil pesan error dari API (jika tersedia)
      if (e.response != null && e.response!.data != null) {
        // Coba ekstrak pesan dari respons
        if (e.response!.data is Map) {
          errorMessages = e.response!.data['message'] ?? e.message;
        } else {
          errorMessages = e.message;
        }
      } else {
        errorMessages = e.message;
      }

      notifyListeners();

      // Return the status code
      return e.response?.statusCode ?? 500;
    }
  }

  Future<int> duplicateBoard({
    required String? token,
    required String encryptId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await services.hitDuplicateBord(
        token: token,
        encryptedId: encryptId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
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

      errorMessages = "Terjadi kesalahan";
      return 500;
    }
  }

  String truncateDescription(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  RoleUserInBoard getUserRoleFromBoard(Datum board, int userId) {
    // Cek apakah user adalah owner board (dari field user)
    if (board.user.id == userId) {
      return RoleUserInBoard.owner;
    }

    // Cek apakah user ada dalam daftar member
    try {
      // Cari member dengan user_id yang cocok
      final member = board.members.firstWhere(
        (member) => member.userId == userId,
      );

      // Jika menemukan member, periksa levelnya
      if (member.level == "Admin") {
        return RoleUserInBoard.admin;
      } else if (member.level == "Member") {
        return RoleUserInBoard.member;
      }
    } catch (e) {
      // Jika tidak menemukan member dengan ID tersebut
    }

    // Default jika tidak ditemukan
    return RoleUserInBoard.unknown;
  }

  bool canUserEditBoard(Datum board, int userId) {
    // Super Admin can edit any board regardless of role
    if (isSuperAdmin()) {
      return true;
    }
    
    // Original logic for other roles
    final role = getUserRoleFromBoard(board, userId);
    return role == RoleUserInBoard.owner || role == RoleUserInBoard.admin;
  }

  // Helper method to check if current user is a Super Admin
  bool isSuperAdmin() {
    // Get role from SharedPreferences
    try {
      SharedPreferences prefs = SharedPreferences.getInstance().asStream().first as SharedPreferences;
      final role = prefs.getString('role') ?? "";
      return role.toLowerCase() == "super admin";
    } catch (e) {
      return false;
    }
  }

  // More reliable way to check Super Admin role using a passed parameter
  bool canUserEditBoardById(int? boardId, int userId, {String? userRole}) {
    // If user is a Super Admin, they can edit any board
    if (userRole?.toLowerCase() == "super admin") {
      return true;
    }
    
    if (modelBoard == null) return false;

    try {
      // Cari board dengan ID yang cocok
      final board = modelBoard!.data.firstWhere(
        (board) => board.id == boardId,
      );

      return canUserEditBoard(board, userId);
    } catch (e) {
      // Board tidak ditemukan
      return false;
    }
  }
}
