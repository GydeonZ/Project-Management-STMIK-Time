import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textFieldSetting({
  required TextEditingController controller,
  String? labelText,
  bool? obscureText,
  bool? enable,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
  TextCapitalization textCapitalization = TextCapitalization.none,
  Color? fill,
  Color? colorhintext,
}) {
  return TextFormField(
    enabled: enable,
    cursorColor: Colors.black,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    controller: controller,
    decoration: InputDecoration(
      fillColor: fill,
      hintText: labelText,
      hintStyle: GoogleFonts.figtree(
        color: colorhintext,
      ),
      labelStyle: GoogleFonts.figtree(
        color: Colors.blueGrey,
      ),
      border: InputBorder.none,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
    ),
    validator: validator,
  );
}
