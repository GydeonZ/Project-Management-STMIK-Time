import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customNotifikasiSkeleton() {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    elevation: 3,
    child: ListTile(
      title: const Text(
        'title',
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('message'),
          const SizedBox(height: 4),
          Text(
            '1 jam yang lalu',
            style: GoogleFonts.figtree(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );
}
