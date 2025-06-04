import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customCardAnggotaList({
  required BuildContext context,
  bool? canEdit,
  bool? addAnggota,
  String? namaUser,
  String? emailUser,
  String? roleUser,
  String? nomorIndukuser,
  String? levelUser,
  VoidCallback? onTap,
  VoidCallback? onTapIcon,
}) {
  Size size = MediaQuery.of(context).size;
  return addAnggota == true
      ? SizedBox(
          height: size.height * 0.1,
          child: GestureDetector(
            onTap: onTap,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.04),
                    child: Text(
                      namaUser ?? "",
                      style: GoogleFonts.figtree(
                        fontWeight: FontWeight.bold,
                        
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      : Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // Remove the Expanded widget here
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      // Add Expanded here to make the text take available space
                      child: Text(
                        namaUser ?? "",
                        style: GoogleFonts.figtree(
                          fontWeight: FontWeight.bold,
                          
                          fontSize: 17,
                        ),
                      ),
                    ),
                    canEdit == false
                        ? const SizedBox()
                        : IconButton(
                            onPressed: onTapIcon,
                            icon: SvgPicture.asset(
                              'assets/tongsampah.svg',
                              height: size.height * 0.02,
                              width: size.width * 0.02,
                            )),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      // Add Expanded here to make the column take available space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roleUser ?? "",
                            style: GoogleFonts.figtree(
                              
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: size.height * 0.009),
                          Text(
                            emailUser ?? "",
                            style: GoogleFonts.figtree(
                              
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: size.height * 0.009),
                          Text(
                            nomorIndukuser ?? "",
                            style: GoogleFonts.figtree(
                              
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.035),
                        child: canEdit == true
                            ? RichText(
                                text: TextSpan(
                                  text: levelUser,
                                  style: GoogleFonts.figtree(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = onTap,
                                ),
                              )
                            : Text(
                                levelUser ?? "",
                                style: GoogleFonts.figtree(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  
                                ),
                              ))
                  ],
                ),
              ],
            ),
          ),
        );
}
