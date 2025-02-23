import 'package:flutter/material.dart';

Widget customButton(
    {String? labelText,
    Color? bgColor,
    Color? fntColor,
    Color? brdrColor,
    double? height,
    double? width,
    VoidCallback? onPressed,
    String? text}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: brdrColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: onPressed,
    child: SizedBox(
        width: width,
        height: height,
        child: Center(
            child: Text(
          text ?? "",
          style: TextStyle(
              color: fntColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: "Inter"),
        ))),
  );
}
