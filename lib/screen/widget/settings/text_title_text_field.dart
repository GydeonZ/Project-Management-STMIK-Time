import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textSetting({
  required String text,
}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: GoogleFonts.figtree(
        color: const Color(0xff293066),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
