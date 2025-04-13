import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

Widget customTextFormField({
  required TextEditingController controller,
  bool? status,
  bool? formTambahTugas = false,
  bool? butuhJudul = true,
  bool? requiredSpacing = true,
  double? widthIcon,
  double? heightIcon,
  Widget? prefixIcon,
  String? titleText,
  int? maxLine,
  String? iconPath,
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
      butuhJudul == true
          ? Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                titleText ?? "",
                style: const TextStyle(
                  fontFamily: "Helvetica",
                  fontSize: 14,
                ),
              ),
            )
          : const SizedBox(),
      Form(
        key: keyForm,
        child: formTambahTugas == false
            ? TextFormField(
                enabled: status ?? true,
                textCapitalization: textCapitalization,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                controller: controller,
                obscureText: obscureText ?? false,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(top: 8, left: 20, right: 8),
                  filled: true,
                  fillColor: const Color(0xFFECECEC),
                  hintText: labelText,
                  hintStyle: const TextStyle(
                    fontFamily: "Helvetica",
                    fontSize: 14,
                    color: Color(0xFFB0B0B0),
                  ),
                  labelStyle: const TextStyle(
                    color: Color(0xffBFBFBF),
                    fontFamily: "Helvetica",
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
              )
            : Column(
                children: [
                  TextFormField(
                    enabled: status ?? true,
                    textCapitalization: textCapitalization,
                    maxLines: maxLine,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    controller: controller,
                    obscureText: obscureText ?? false,
                    decoration: InputDecoration(
                      hintText: labelText,
                      hintStyle: const TextStyle(
                        fontFamily: "Helvetica",
                        fontSize: 14,
                        color: Color(0xFFB0B0B0),
                      ),
                      labelStyle: const TextStyle(
                        color: Color(0xffBFBFBF),
                        fontFamily: "Helvetica",
                      ),
                      // Tambahkan prefixIconConstraints untuk mengontrol ukuran area icon
                      prefixIconConstraints: BoxConstraints(
                        minWidth: widthIcon != null ? widthIcon + 30 : 60,
                      ),
                      // Ubah padding pada prefixIcon
                      prefixIcon: Padding(
                        // Tambahkan padding kanan untuk memberi jarak dengan text
                        padding: const EdgeInsets.only(left: 8, right: 15),
                        child: SvgPicture.asset(
                          iconPath ?? "",
                          width: widthIcon,
                          height: heightIcon,
                        ),
                      ),
                      suffixIcon: suffixIcon,
                      border: InputBorder.none,
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Color(0xffFF0000),
                        ),
                      ),
                    ),
                    validator: validator,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border(
                          top: BorderSide(color: Color(0xff293066), width: 3)),
                    ),
                  ),
                ],
              ),
      ),
      requiredSpacing == true
          ? const SizedBox(
              height: 18,
            )
          : const SizedBox(
              height: 0,
            ),
    ],
  );
}

Widget customFormDetailTugas({
  required BuildContext context,
  bool? listContainer = true,
  bool? textBold = true,
  String? iconPath,
  String? listDataTitle,
  Color? colorText,
  String? labelText,
  double? widthIcon,
  double? heightIcon,
  double? animatedTurn,
  double? maxHeightListData,
  double? opacityDataList,
  List<Widget>? itemDataList,
  ScrollPhysics? scrollListData,
  VoidCallback? containerOnTap,
  VoidCallback? onTapListContainer,
}) {
  Size size = MediaQuery.of(context).size;
  return Column(
    children: [
      // Hapus SizedBox dengan tinggi tetap
      listContainer == false
          ? InkWell(
              onTap: containerOnTap,
              child: SizedBox(
                height: size.height * 0.065,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SvgPicture.asset(
                        iconPath ?? "",
                        width: widthIcon ?? size.width * 0.07,
                        height: heightIcon ?? size.width * 0.07,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        labelText ?? "",
                        style: TextStyle(
                          fontFamily: "Helvetica",
                          fontSize: 14,
                          color: colorText ?? const Color(0xFFB0B0B0),
                          fontWeight: textBold == true
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Header yang bisa diklik
                InkWell(
                  onTap: onTapListContainer,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/listtugas.svg'),
                            SizedBox(width: size.width * 0.04),
                            Text(
                              listDataTitle ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AnimatedRotation(
                              turns: animatedTurn ?? 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: const Color(0xFF293066),
                                size: size.height * 0.03,
                              ),
                            ),
                            IconButton(
                              splashRadius: 1,
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'assets/plus.svg',
                                height: size.height * 0.02,
                                width: size.width * 0.02,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                // Content dinamis dengan animasi
                ClipRect(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    constraints: BoxConstraints(
                      maxHeight: maxHeightListData ?? double.infinity,
                      minHeight: 0,
                    ),
                    child: SingleChildScrollView(
                      physics: scrollListData,
                      child: Opacity(
                        opacity: opacityDataList ?? 1.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: itemDataList ??
                              [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Tidak ada data",
                                  style: TextStyle(
                                    fontFamily: "Helvetica",
                                    fontSize: 14,
                                    color: Color(0xFFB0B0B0),
                                  ),
                                ),
                              ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border(top: BorderSide(color: Color(0xff293066), width: 1.5)),
        ),
      ),
    ],
  );
}
