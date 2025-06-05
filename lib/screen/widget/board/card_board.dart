import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customCardBoard({
  required String title,
  required String subtitle,
  required Color color,
  required BuildContext context,
  int? boardId,
  required String? nickname,
  PopupMenuItemSelected<String>? onTap,
  bool canEdit = true,
  // Tambahkan parameter untuk visibilitas
  String visibility = "Public", // Default-nya public
}) {
  Size size = MediaQuery.of(context).size;
  return Stack(
    fit: StackFit.expand,
    children: [
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: size.height * 0.027,
                backgroundColor: color,
                child: Text(
                  nickname ?? '',
                  style: GoogleFonts.figtree(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.figtree(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: GoogleFonts.figtree(
                    color: Colors.grey,
                  )),
            ],
          ),
        ),
      ),
      // Dropdown menu
      Positioned(
        right: size.width * 0.006,
        child: _buildBoardDropdown(context, boardId ?? 0, size, onTap, canEdit),
      ),
      // Tambahkan ikon visibilitas di kanan bawah
      Positioned(
        right: size.width * 0.02,
        bottom: size.width * 0.02,
        child: _buildVisibilityIcon(visibility),
      ),
    ],
  );
}

// Tambahkan fungsi untuk membangun ikon visibilitas
Widget _buildVisibilityIcon(String visibility) {
  // Gunakan SvgPicture jika menggunakan SVG, atau Icon jika menggunakan Material Icons
  if (visibility.toLowerCase() == "private") {
    return const Icon(
      Icons.lock_outline,
      color: Colors.grey,
      size: 16,
    );
  } else {
    return const Icon(
      Icons.public,
      color: Colors.grey,
      size: 16,
    );
  }
}

Widget _buildBoardDropdown(
  BuildContext context,
  int boardId,
  Size size,
  PopupMenuItemSelected<String>? onTap,
  bool canEdit,
) {
  return PopupMenuButton<String>(
    icon: const Icon(
      Icons.more_vert,
      color: Colors.black,
      size: 20,
    ),
    offset: const Offset(0, 40),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    onSelected: onTap,
    itemBuilder: (context) {
      // Create the anggota menu item that will always be shown
      final anggotaMenuItem = PopupMenuItem<String>(
        value: 'anggota',
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/Two-user.svg",
              height: size.height * 0.02,
              colorFilter: const ColorFilter.mode(
                Colors.purple,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Anggota',
              style: GoogleFonts.figtree(
                color: Colors.purple,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );

      // If user can edit, show all options
      if (canEdit) {
        return [
          PopupMenuItem<String>(
            value: 'edit',
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/pencil.svg",
                  height: size.height * 0.02,
                  colorFilter: const ColorFilter.mode(
                    Colors.blue,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Ubah',
                  style: GoogleFonts.figtree(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          anggotaMenuItem, // Reuse the anggota menu item
          PopupMenuItem<String>(
            value: 'duplicate',
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/dupe.svg",
                  height: size.height * 0.02,
                  colorFilter: const ColorFilter.mode(
                    Colors.green,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Duplikat',
                  style: GoogleFonts.figtree(
                    color: Colors.green,
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
                Text(
                  'Hapus',
                  style: GoogleFonts.figtree(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ];
      } else {
        // If user cannot edit, show only anggota
        return [anggotaMenuItem];
      }
    },
  );
}
