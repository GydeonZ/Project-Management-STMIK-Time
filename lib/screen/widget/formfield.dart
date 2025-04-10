import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customTextFormField({
  required TextEditingController controller,
  bool? status,
  Widget? prefixIcon,
  String? titleText,
  Widget? suffixIcon,
  String? labelText,
  GlobalKey? keyForm,
  bool? obscureText,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
  TextCapitalization textCapitalization = TextCapitalization.none,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(
          titleText!,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Form(
        key: keyForm,
        child: TextFormField(
          enabled: status ?? true,
          textCapitalization: textCapitalization,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          controller: controller,
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(top: 8, left: 20, right: 8),
            filled: true,
            fillColor: const Color(0xFFECECEC),
            hintText: labelText,
            hintStyle: const TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
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
                width: 2,
                color: Color(0xff293066),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                width: 2,
                color: Color(0xff293066),
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
        ),
      ),
      const SizedBox(height: 18),
    ],
  );
}
