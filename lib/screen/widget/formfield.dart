import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customTextFormField({
  required TextEditingController controller,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? labelText,
  bool? obscureText,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
  TextCapitalization textCapitalization = TextCapitalization.none,
}) {
  return TextFormField(
    textCapitalization: textCapitalization,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    controller: controller,
    obscureText: obscureText ?? false,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      filled: true,
      fillColor: Color(0xFFECECEC),
      hintText: labelText,
      hintStyle: const TextStyle(
        color: Color(0xFFB0B0B0),
      ),
      labelStyle: const TextStyle(
        color: Color(0xffBFBFBF),
        fontFamily: "Inter",
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: InputBorder.none,
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: Color(0xffECECEC),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: Color(0xffFF0000),
        ),
      ),
    ),
    validator: validator,
  );
}
