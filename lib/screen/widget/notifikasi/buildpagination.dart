import 'package:flutter/material.dart';

Widget buildPaginationButton({
  String? text,
  IconData? icon,
  VoidCallback? onTap,
  required bool isActive,
  required bool isSelected,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    margin: const EdgeInsets.symmetric(horizontal: 4.0),
    child: Material(
      color: isSelected ? const Color(0xFF293066) : Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 2.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          child: text != null
              ? Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF293066),
                  ),
                )
              : Icon(
                  icon,
                  color: onTap != null
                      ? const Color(0xFF293066)
                      : Colors.grey[400],
                ),
        ),
      ),
    ),
  );
}
