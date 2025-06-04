import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

Future customShowDialog({
  required BuildContext context,
  Widget? customWidget,
  GlobalKey<FormState>? formKey,
  VoidCallback? onPressedBtnL,
  VoidCallback? onPressedBtnR,
  String? text1,
  String? text2,
  String? txtButtonL,
  String? txtButtonR,
  bool useForm = true,
}) {
  Size size = MediaQuery.of(context).size;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: useForm == true
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: formKey,
                  child: customWidget!,
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text1 ?? '',
                  style: GoogleFonts.figtree(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  text2 ?? '',
                  style: GoogleFonts.figtree(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
      icon: useForm == false // Tampilkan ikon hanya jika useForm bernilai false
          ? Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
                top: 10,
              ),
              child: Transform.scale(
                scale: 1.3,
                child: SvgPicture.asset('assets/mingcute_warning_fill.svg'),
              ),
            )
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: size.width * .25,
                  height: size.width * .12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xff293066),
                      width: 3,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: onPressedBtnL,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                      shadowColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Text(
                      txtButtonL!,
                      style: GoogleFonts.figtree(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: const Color(0xff293066),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width * .25,
                height: size.width * .12,
                decoration: BoxDecoration(
                  color: const Color(0xff293066),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: onPressedBtnR, // Gunakan callback onPressed
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.transparent),
                    shadowColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  child: Text(
                    txtButtonR!,
                    style: GoogleFonts.figtree(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Future customShowDialogDeskripsi({
  required BuildContext context,
  GlobalKey<FormState>? formKey,
  VoidCallback? onPressedBtnL,
  VoidCallback? onPressedBtnR,
  TextEditingController? controller,
  String? text1,
  String? txtButtonL,
  String? txtButtonR,
  bool useForm = true,
  bool roleChecker = false,
  String? Function(String?)? validator,
}) {
  Size size = MediaQuery.of(context).size;
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: useForm == true
          ? Form(
              key: formKey,
              child: TextFormField(
                maxLines: 5,
                controller: controller,
                decoration: InputDecoration(
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
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xff293066), width: 2),
              ),
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.02),
                child: Text(
                  text1 ?? '',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.figtree(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.02),
          child: Builder(builder: (context) {
            return roleChecker == false
                ? Center(
                    child: Container(
                      width: size.width * .25,
                      height: size.width * .12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xff293066),
                          width: 3,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: onPressedBtnL,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          shadowColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                        child: Text(
                          txtButtonL!,
                          style: GoogleFonts.figtree(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: const Color(0xff293066),
                          ),
                        ),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: size.width * .25,
                        height: size.width * .12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xff293066),
                            width: 3,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: onPressedBtnL,
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.transparent),
                            shadowColor:
                                WidgetStateProperty.all(Colors.transparent),
                          ),
                          child: Text(
                            txtButtonL!,
                            style: GoogleFonts.figtree(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: const Color(0xff293066),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * .25,
                        height: size.width * .12,
                        decoration: BoxDecoration(
                          color: const Color(0xff293066),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          onPressed: onPressedBtnR,
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.transparent),
                            shadowColor:
                                WidgetStateProperty.all(Colors.transparent),
                          ),
                          child: Text(
                            txtButtonR!,
                            style: GoogleFonts.figtree(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
          }),
        )
      ],
    ),
  );
}
