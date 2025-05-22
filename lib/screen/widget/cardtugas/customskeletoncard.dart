import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget customCardSkeleton({
  required BuildContext context,
  String? cardTitle,
  String? taskTitle,
  required int taskLength,
  final task,
  bool? icon = false,
  String? tambahTugas,
  Color? color,
  Color? taskColor,
  VoidCallback? ontapTambahTugas,
}) {
  Size size = MediaQuery.of(context).size;
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cardTitle ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: tambahTugas ?? '+ Tambah Task',
                      style: TextStyle(
                        color: taskColor ?? const Color(0xff0088D1),
                        fontSize: 13,
                        fontFamily: "Helvetica",
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = ontapTambahTugas,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          // Task List
          Column(
            children: List.generate(
              taskLength,
              (taskIndex) {
                task;
                return Card(
                  color: color ?? const Color(0xff293066),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.height * 0.013),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          taskTitle ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: "Helvetica",
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          icon == true
              ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "assets/pencil.svg",
                      height: size.height * 0.025,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "assets/tongsampah.svg",
                      height: size.height * 0.025,
                    ),
                  ),
                ])
              : Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.018, right: size.width * 0.023),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(width: size.width * 0.05),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                      ]),
                )
        ],
      ),
    ),
  );
}
