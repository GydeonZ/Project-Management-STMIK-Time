import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectmanagementstmiktime/screen/view/board/board.dart';
import 'package:projectmanagementstmiktime/screen/view/notification/notification_screen.dart';
import 'package:projectmanagementstmiktime/screen/view/profile/profile_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    const BoardScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      // Jika tidak berada di halaman utama, kembali ke halaman utama
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    } else {
      // Jika di halaman utama, tampilkan dialog konfirmasi
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Keluar dari Aplikasi?'),
              content: const Text('Apakah Anda yakin ingin keluar?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Keluar'),
                ),
              ],
            ),
          ) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final result = await _onWillPop();
        if (result && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFFF4F6FA),
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xFF293066),
              unselectedItemColor: const Color(0xFF293066).withOpacity(0.5),
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavIcon("assets/dashboard.svg", 0),
                  label: 'Board',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon("assets/notifikasi.svg", 1),
                  label: 'Notifikasi',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon("assets/akun.svg", 2),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(String iconPath, int index) {
    return Column(
      children: [
        SizedBox(height: 8),
        SvgPicture.asset(
          iconPath,
          height: 25,
          width: 25,
          colorFilter: ColorFilter.mode(
            index == _selectedIndex
                ? const Color(0xFF293066)
                : const Color(0xFF293066).withOpacity(0.5),
            BlendMode.srcIn,
          ),
        ),
        SizedBox(height: 5),
        index == _selectedIndex
            ? Container(
                margin: const EdgeInsets.only(top: 3),
                height: 3,
                width: 25,
                decoration: BoxDecoration(
                  color: const Color(0xFF293066),
                  borderRadius: BorderRadius.circular(5),
                ),
              )
            : const SizedBox(height: 6),
      ],
    );
  }
}
