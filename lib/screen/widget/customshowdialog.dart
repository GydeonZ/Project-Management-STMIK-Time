import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                  style: const TextStyle(
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  text2 ?? '',
                  style: const TextStyle(
                    fontFamily: 'Helvetica',
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
                      style: const TextStyle(
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xff293066),
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
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
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
