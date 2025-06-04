import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_notifikasi.dart';
import 'package:projectmanagementstmiktime/services/service_notification_list.dart';

class NotificationViewModel with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool isLoading = false;
  final services = NotificationListService();
  ModelFetchNotifikasi? modelFetchNotifikasi;
  bool isSukses = false;
  String? errorMessages;

  // Pagination properties
  int _currentPage = 1;
  int _totalPages = 1;
  final int _itemsPerPage = 8;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;
  List<Datum> _paginatedData = [];

  // Getters
  List<NotificationModel> get notifications => _notifications;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;
  List<Datum> get paginatedData => _paginatedData;

  NotificationViewModel() {
    // Initialize and load notifications
    loadNotifications();
  }

  // Reset pagination to first page
  void resetPagination() {
    _currentPage = 1;
    _totalPages = 1;
    _paginatedData = [];
    _hasMoreData = true;
    notifyListeners();
  }

  // Get paginated data from the full list
  void updatePaginatedData() {
    if (modelFetchNotifikasi?.data == null) return;

    final allData = modelFetchNotifikasi!.data;
    _totalPages = (allData.length / _itemsPerPage).ceil();

    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage > allData.length
        ? allData.length
        : startIndex + _itemsPerPage;

    if (startIndex >= allData.length) {
      _hasMoreData = false;
      return;
    }

    _paginatedData = allData.sublist(startIndex, endIndex);
    _hasMoreData = endIndex < allData.length;

    notifyListeners();
  }

  // Load next page
  void loadNextPage() {
    if (!_hasMoreData || _isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    updatePaginatedData();

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    isLoading = true;
    notifyListeners();

    try {
      // This is where you would fetch notifications from your backend
      // For now, we'll use a local example list
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay

      // Example notifications
      _notifications = [
        NotificationModel(
          id: 1,
          title: 'New Task Assigned',
          body: 'You have been assigned a new task: Project Report',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: false,
          payload: {'type': 'new_task', 'task_id': '123', 'board_id': '45'},
        ),
        NotificationModel(
          id: 2,
          title: 'Comment on Your Task',
          body: 'John commented: Please review the latest changes',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
          payload: {'type': 'task_comment', 'task_id': '456'},
        ),
        NotificationModel(
          id: 3,
          title: 'Board Invitation',
          body: 'You have been invited to join: Marketing Campaign',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          isRead: true,
          payload: {'type': 'board_invitation', 'board_id': '789'},
        ),
      ];
    } catch (e) {
      // print('Error loading notifications: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final index =
        _notifications.indexWhere((item) => item.id == notificationId);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();

      // Here you would update the read status on your backend
      // await yourApiService.markNotificationAsRead(notificationId);
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    _notifications.removeWhere((item) => item.id == notificationId);
    notifyListeners();

    // Here you would delete the notification on your backend
    // await yourApiService.deleteNotification(notificationId);
  }

  Future<void> clearAllNotifications({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      // Here you would implement the API call to clear notifications
      // await services.clearAllNotifications(token: token);

      // For now, just clear the local data
      modelFetchNotifikasi = null;
      resetPagination();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessages = "Terjadi kesalahan: $e";
      notifyListeners();
    }
  }

  int getUnreadCount() {
    return _notifications.where((notification) => !notification.isRead).length;
  }

  static Future<void> createTestNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'high_importance_channel',
        title: 'Test Notification',
        body: 'This is a test notification from the app',
        notificationLayout: NotificationLayout.Default,
        payload: {'type': 'test'},
      ),
    );
  }

  String formatNotificationTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  Future<int> getNotificationList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      modelFetchNotifikasi = await services.fetchNotificationList(token: token);

      // Reset pagination whenever we fetch new data
      resetPagination();
      updatePaginatedData();

      isLoading = false;
      if (modelFetchNotifikasi != null) {
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

  Future<void> refreshNotificationList({required String token}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await services.fetchNotificationList(token: token);

      if (result != null) {
        modelFetchNotifikasi = result;
        isSukses = true;
        // Reset pagination dan perbaharui data
        resetPagination();
        updatePaginatedData();
        errorMessages = '';
      } else {
        isSukses = false;
        errorMessages = 'Data tidak ditemukan';
      }
    } on DioException catch (e) {
      errorMessages = "Terjadi kesalahan: ${e.message}";
    } catch (e) {
      errorMessages = "Error tidak terduga: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Mark notification as read
  Future<int> markNotification({
    required String token,
    required int notifId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await services.markNotifcation(
        token: token,
        notifId: notifId,
      );

      if (response != null) {
        // Perbarui status notifikasi di model lokal
        if (modelFetchNotifikasi != null) {
          // Cari dan update notifikasi dengan ID yang sesuai di semua data
          for (var notif in modelFetchNotifikasi!.data) {
            if (notif.id == notifId) {
              notif.isRead = true;
              break;
            }
          }

          // Perbarui juga data yang ada di paginatedData
          for (var notif in _paginatedData) {
            if (notif.id == notifId) {
              notif.isRead = true;
              break;
            }
          }
        }

        errorMessages = null;
        return 200;
      } else {
        errorMessages = "Gagal mengupdate notifikasi";
        return 400;
      }
    } catch (e) {
      errorMessages = e.toString();
      return 500;
    } finally {
      isLoading = false;
      notifyListeners(); // Akan memicu rebuild UI dengan data yang sudah diperbarui
    }
  }

  // Mark notification as read
  Future<int> markNotificationAll({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final success = await services.markNotifcationAll(
        token: token,
      );
      isLoading = false;
      notifyListeners();

      if (success) {
        errorMessages = null;
        return 200;
      } else {
        errorMessages = "Gagal mengupdate notifikasi";
        return 400;
      }
    } catch (e) {
      isLoading = false;
      errorMessages = e.toString();
      notifyListeners();
      return 500;
    }
  }

  Future<int> deleteNotif({
    required String token,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final success = await services.deleteNotif(
        token: token,
      );
      isLoading = false;
      notifyListeners();

      if (success) {
        errorMessages = null;
        return 200;
      } else {
        errorMessages = "Gagal mengupdate notifikasi";
        return 400;
      }
    } catch (e) {
      isLoading = false;
      errorMessages = e.toString();
      notifyListeners();
      return 500;
    }
  }

  Widget formatNotifikasiText(String activityText) {
    // Regular expression untuk mencari semua teks di dalam tanda kutip
    final RegExp quotePattern = RegExp(r"'([^']*)'");

    // Jika tidak ada tanda kutip, tampilkan teks biasa
    if (!quotePattern.hasMatch(activityText)) {
      return Text(
        activityText,
        style: GoogleFonts.figtree(
          color: Colors.black,
          fontSize: 14,
        ),
      );
    }

    // Memproses semua tanda kutip
    final List<TextSpan> textSpans = [];
    int lastEnd = 0;

    // Iterasi semua tanda kutip yang ditemukan
    for (Match match in quotePattern.allMatches(activityText)) {
      // Tambahkan teks sebelum tanda kutip
      if (match.start > lastEnd) {
        textSpans.add(TextSpan(
          text: activityText.substring(lastEnd, match.start),
        ));
      }

      // Tambahkan teks dalam tanda kutip (diberi formatting bold)
      final quotedText = match.group(1)!; // Teks dalam tanda kutip
      textSpans.add(TextSpan(
        text: quotedText, // Tanpa tanda kutip
        style: GoogleFonts.figtree(
          fontWeight: FontWeight.bold,
        ),
      ));

      lastEnd = match.end;
    }

    // Tambahkan teks yang tersisa setelah tanda kutip terakhir
    if (lastEnd < activityText.length) {
      textSpans.add(TextSpan(
        text: activityText.substring(lastEnd),
      ));
    }

    return RichText(
      text: TextSpan(
        style: GoogleFonts.figtree(
          color: Colors.black,
          fontSize: 14,
        ),
        children: textSpans,
      ),
    );
  }

  // Build notification item widget
  Widget buildNotificationItem({
    required String message,
    required DateTime time,
    required bool isRead,
    required Size size,
    required VoidCallback onTap,
  }) {
    return Card(
      color: isRead ? Colors.white : const Color(0xffeff6ff),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            formatNotifikasiText(message),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatNotificationTime(time),
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                isRead
                    ? const SizedBox.shrink()
                    : Container(
                        width: size.width * 0.02,
                        height: size.height * 0.02,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  void goToPage(int page) {
    if (page < 1 || page > _totalPages || page == _currentPage) return;

    _currentPage = page;
    updatePaginatedData();
    notifyListeners();
  }

// Go to previous page
  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      updatePaginatedData();
      notifyListeners();
    }
  }

// Go to next page
  void nextPage() {
    if (_currentPage < _totalPages) {
      _currentPage++;
      updatePaginatedData();
      notifyListeners();
    }
  }

  // Tambahkan metode untuk mendapatkan rentang nomor halaman yang ditampilkan (3 nomor)
  List<int> getVisiblePageNumbers() {
    if (_totalPages <= 3) {
      // Jika total halaman 3 atau kurang, tampilkan semua
      return List.generate(_totalPages, (i) => i + 1);
    }

    if (_currentPage <= 2) {
      // Jika halaman saat ini 1 atau 2, tampilkan 1, 2, 3
      return [1, 2, 3];
    } else if (_currentPage >= _totalPages - 1) {
      // Jika halaman saat ini adalah salah satu dari 2 halaman terakhir
      return [_totalPages - 2, _totalPages - 1, _totalPages];
    } else {
      // Halaman saat ini di tengah, tampilkan current-1, current, current+1
      return [_currentPage - 1, _currentPage, _currentPage + 1];
    }
  }

  // Tambahkan metode untuk mengecek apakah halaman berikutnya tersedia
  bool hasNextPage() {
    return _currentPage < _totalPages;
  }

  // Tambahkan metode untuk mengecek apakah ada halaman sebelumnya
  bool hasPreviousPage() {
    return _currentPage > 1;
  }

  // Getter untuk menghitung notifikasi yang belum dibaca
  int get unreadNotificationsCount {
    if (modelFetchNotifikasi?.data == null) return 0;

    return modelFetchNotifikasi!.data
        .where((notification) => !notification.isRead)
        .length;
  }

  // Metode untuk memastikan hitungan diperbarui saat status dibaca berubah
  void updateNotificationReadStatus(int notifId, bool isRead) {
    if (modelFetchNotifikasi != null) {
      bool dataUpdated = false;

      // Update di seluruh data notifikasi
      for (var notif in modelFetchNotifikasi!.data) {
        if (notif.id == notifId) {
          notif.isRead = isRead;
          dataUpdated = true;
          break;
        }
      }

      // Update di paginated data
      for (var notif in _paginatedData) {
        if (notif.id == notifId) {
          notif.isRead = isRead;
          dataUpdated = true;
          break;
        }
      }

      // Hanya notifyListeners jika data berubah
      if (dataUpdated) {
        notifyListeners();
      }
    }
  }
}

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  bool isRead;
  final Map<String, String>? payload;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.payload,
  });
}
