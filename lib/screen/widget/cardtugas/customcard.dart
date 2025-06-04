import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customCard({
  required BuildContext context,
  int? cardId,
  required String cardTitle,
  required ValueKey<String> valueKey,
  required VoidCallback onTapTambahTugas,
  required VoidCallback onTapEdit,
  required VoidCallback onTapDelete,
  required bool Function(Map<String, dynamic>?) onWillAccept,
  required void Function(Map<String, dynamic>) onAccept,
  required Function(int, int) onReorder,
  required List<Widget> forDrag,
  bool canEdit = true,
}) {
  Size size = MediaQuery.of(context).size;
  return Card(
    key: valueKey,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  cardTitle,
                  style: GoogleFonts.figtree(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              Row(
                children: [
                  if (canEdit)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '+ Tambah Tugas',
                            style: GoogleFonts.figtree(
                              color: const Color(0xff293066),
                              fontSize: 13,
                              
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = onTapTambahTugas,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),

          // Container for tasks that can accept drops from other cards
          DragTarget<Map<String, dynamic>>(
            onWillAccept: onWillAccept,
            onAccept: onAccept,
            builder: (context, candidateData, rejectedData) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: candidateData.isNotEmpty
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.05),
                ),
                child: Column(
                  children: [
                    // Reorderable list for tasks in this card
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: onReorder,
                      children: forDrag,
                    ),

                    // Empty drop area at the bottom of each list
                    if (candidateData.isNotEmpty)
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(8),
                        color: const Color(0xff293066),
                        strokeWidth: 2,
                        dashPattern: const [6, 3],
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "Letakkan tugas di sini",
                              style: GoogleFonts.figtree(
                                color: const Color(0xff293066),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          if (canEdit)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onTapEdit,
                  icon: SvgPicture.asset(
                    "assets/pencil.svg",
                    height: size.height * 0.025,
                  ),
                ),
                IconButton(
                  onPressed: onTapDelete,
                  icon: SvgPicture.asset(
                    "assets/tongsampah.svg",
                    height: size.height * 0.025,
                  ),
                )
              ],
            )
        ],
      ),
    ),
  );
}

Widget buildCardDropdown(
  BuildContext context,
  int cardId,
  Size size,
  PopupMenuItemSelected<String>? onTap,
) {
  // Hapus deklarasi duplikat size
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
            Text(
              'Anggota',
              style: GoogleFonts.figtree(
                color: Colors.purple,
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
    ],
  );
}
