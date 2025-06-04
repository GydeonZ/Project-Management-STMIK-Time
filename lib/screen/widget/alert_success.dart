import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectmanagementstmiktime/main.dart';
import 'package:projectmanagementstmiktime/screen/view/board/board.dart';

void showCustomDialog(BuildContext context, Size size) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Selamat!',
            style: GoogleFonts.figtree(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Board Berhasil dibuat',
            style: GoogleFonts.figtree(
              color: const Color(0xff4B4B4B),
            ),
          ),
        ],
      ),
      // content: const Text('This is a warning message.'),
      icon: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
          top: 10,
        ),
        child: Transform.scale(
          scale: size.width * .004,
          child: SvgPicture.asset('assets/ceklis_icon.svg'),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ).then((_) {
    // Setelah dialog ditutup, arahkan ke halaman beranda
    Navigator.pushReplacement(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => const BoardScreen(),
      ),
    );
  });
}
