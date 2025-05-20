import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/view/detailtugas/detail_tugas_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
import 'package:projectmanagementstmiktime/screen/widget/notifikasi/buildpagination.dart';
import 'package:projectmanagementstmiktime/screen/widget/notifikasi/skeleton_notification.dart';
import 'package:projectmanagementstmiktime/view_model/notification/view_model_notification.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationViewModel notificationViewModel;
  late SignInViewModel sp;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notificationViewModel =
        Provider.of<NotificationViewModel>(context, listen: false);
    sp = Provider.of<SignInViewModel>(context, listen: false);
    final token = sp.tokenSharedPreference;

    // Add scroll listener for pagination
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationViewModel.getNotificationList(token: token);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll listener to detect when user reaches the bottom
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // User is near the bottom, load more data
      notificationViewModel.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF293066),
            fontFamily: 'Helvetica',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer<NotificationViewModel>(builder: (context, viewModel, child) {
            return PopupMenuButton<String>(
              icon: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.more_vert,
                  color: Color(0xff293066),
                ),
              ),
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                if (value == 'marknotif') {
                  try {
                    // Call view model method to update checklist status
                    final response = await viewModel.markNotificationAll(
                        token: sp.tokenSharedPreference);

                    if (response == 200) {
                      // Refresh task data to show updated checklists
                      await viewModel.refreshNotificationList(
                        token: sp.tokenSharedPreference,
                      );
                    } else {
                      customAlert(
                        alertType: QuickAlertType.error,
                        text: viewModel.errorMessages ??
                            "Gagal Menandain Notifikasi",
                      );
                    }
                  } catch (e) {
                    navigatorKey.currentState?.pop();
                    customAlert(
                      alertType: QuickAlertType.error,
                      text: "Terjadi kesalahan Silahkan Coba Lagi",
                    );
                  }
                } else if (value == 'delete') {
                  try {
                    // Call view model method to update checklist status
                    final response = await viewModel.deleteNotif(
                        token: sp.tokenSharedPreference);

                    if (response == 200) {
                      // Refresh task data to show updated checklists
                      await viewModel.refreshNotificationList(
                        token: sp.tokenSharedPreference,
                      );
                    } else {
                      customAlert(
                        alertType: QuickAlertType.error,
                        text: viewModel.errorMessages ??
                            "Gagal Menghapus Notifikasi",
                      );
                    }
                  } catch (e) {
                    navigatorKey.currentState?.pop();
                    customAlert(
                      alertType: QuickAlertType.error,
                      text: "Terjadi kesalahan Silahkan Coba Lagi",
                    );
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'marknotif',
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/doublechecklist.svg",
                        height: size.height * 0.02,
                        colorFilter: const ColorFilter.mode(
                          Colors.blue,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Tandai Semua',
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Helvetica',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/tongsampah.svg",
                        height: size.height * 0.02,
                        colorFilter: const ColorFilter.mode(
                          Colors.red,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Hapus',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Helvetica',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          })
        ],
      ),
      body: _buildNotificationList(),
    );
  }

  Widget _buildNotificationList() {
    return Consumer<NotificationViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return customNotifikasiSkeleton();
              },
            ),
          );
        }

        // Tambahkan widget RefreshIndicator sebagai parent untuk konten
        return RefreshIndicator(
          onRefresh: () async {
            // Panggil method refresh saat pengguna menarik layar ke bawah
            return await viewModel.refreshNotificationList(
              token: sp.tokenSharedPreference,
            );
          },
          color: const Color(0xFF293066), // Warna indicator yang sesuai tema
          child: viewModel.modelFetchNotifikasi?.data == null ||
                  viewModel.modelFetchNotifikasi!.data.isEmpty
              ? ListView(
                  // Gunakan ListView untuk memungkinkan pull-to-refresh bekerja pada layar kosong
                  children: [
                    // Tambahkan widget notifikasi kosong di sini
                    Container(
                      height: MediaQuery.of(context).size.height - 150,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada notifikasi',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    // Notification list yang dapat di-scroll
                    Expanded(
                      child: ListView.builder(
                        physics:
                            const AlwaysScrollableScrollPhysics(), // Penting untuk RefreshIndicator
                        itemCount: viewModel.paginatedData.length,
                        itemBuilder: (context, index) {
                          final item = viewModel.paginatedData[index];
                          return viewModel.buildNotificationItem(
                            message: item.message,
                            time: item.createdAt,
                            isRead: item.isRead,
                            size: MediaQuery.of(context).size,
                            onTap: () async {
                              final notifId = item.id;

                              if (item.isRead == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailTugasScreen(taskId: item.taskId),
                                  ),
                                );
                              }
                              try {
                                // Call view model method to update checklist status
                                final response =
                                    await viewModel.markNotification(
                                        token: sp.tokenSharedPreference,
                                        notifId: notifId);

                                if (response == 200) {
                                  // Refresh tidak perlu lagi di sini karena sudah ditangani di dalam markNotification
                                  // await viewModel.refreshNotificationList(token: sp.tokenSharedPreference);
                                } else {
                                  customAlert(
                                    alertType: QuickAlertType.error,
                                    text: viewModel.errorMessages ??
                                        "Gagal Menandai Notifikasi",
                                  );
                                }
                              } catch (e) {
                                navigatorKey.currentState?.pop();
                                customAlert(
                                  alertType: QuickAlertType.error,
                                  text: "Terjadi kesalahan Silahkan Coba Lagi",
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),

                    // Pagination indicator with sliding effect
                    if (viewModel.totalPages > 1)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Previous button
                            buildPaginationButton(
                              icon: Icons.chevron_left,
                              onTap: viewModel.hasPreviousPage()
                                  ? () {
                                      viewModel.previousPage();
                                    }
                                  : null,
                              isActive: false,
                              isSelected: false,
                            ),

                            // Dynamic page numbers with sliding effect
                            ...viewModel.getVisiblePageNumbers().map(
                                  (i) => buildPaginationButton(
                                    text: i.toString(),
                                    onTap: () {
                                      viewModel.goToPage(i);
                                    },
                                    isActive: true,
                                    isSelected: i == viewModel.currentPage,
                                  ),
                                ),

                            // Next button
                            buildPaginationButton(
                              icon: Icons.chevron_right,
                              onTap: viewModel.hasNextPage()
                                  ? () {
                                      viewModel.nextPage();
                                    }
                                  : null,
                              isActive: false,
                              isSelected: false,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}
