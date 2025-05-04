import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget customCardBoard({
  required String title,
  required String subtitle,
  required Color color,
  required BuildContext context,
  int? boardId,
  required String? nickname,
  PopupMenuItemSelected<String>? onTap,
  bool canEdit = true,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                  )),
            ],
          ),
        ),
      ),
      if (canEdit)
        Positioned(
          right: size.width * 0.006,
          child: _buildBoardDropdown(context, boardId ?? 0, size, onTap),
        ),
    ],
  );
}

Widget _buildBoardDropdown(
  BuildContext context,
  int boardId,
  Size size,
  PopupMenuItemSelected<String>? onTap,
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
    itemBuilder: (context) => [
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
            const Text(
              'Ubah',
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
            const Text(
              'Anggota',
              style: TextStyle(
                color: Colors.purple,
                fontFamily: 'Helvetica',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
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
            const Text(
              'Duplikat',
              style: TextStyle(
                color: Colors.green,
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
}
