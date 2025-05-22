import 'package:flutter/material.dart';

Widget bottomSheetAddCard({
  required BuildContext context,
  String? judulBtn,
  VoidCallback? onTap,
}) {
  Size size = MediaQuery.of(context).size;
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: size.height * 0.075,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Color(0xff293066),
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Tambah $judulBtn",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    ),
  );
}
