import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectmanagementstmiktime/screen/view/onboarding/onboarding.dart';
import 'package:projectmanagementstmiktime/screen/view/profile/profile_change_password_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/customshowdialog.dart';
import 'package:projectmanagementstmiktime/screen/widget/settings/banner.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';
import 'package:projectmanagementstmiktime/view_model/navigation/view_model_navigation.dart';
import 'package:projectmanagementstmiktime/view_model/profile/view_model_profile.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel viewModel;
  late SharedPreferences logindata;
  late SignInViewModel sp;
  late NavigationProvider nav;

  @override
  void initState() {
    viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    sp = Provider.of<SignInViewModel>(context, listen: false);
    nav = Provider.of<NavigationProvider>(context, listen: false);
    sp.setSudahLogin();
    super.initState();
    initial();
  }

  Future<void> launchURL() async {
    String url = Urls.contactSupport;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Tetap false karena dihandle oleh navigation bar
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.figtree(
            color: const Color(0xFF293066),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Hapus tombol close, karena kita menggunakan bottom navigation
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<SignInViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const BannerSetting(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Akun',
                        style: GoogleFonts.figtree(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff293066),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GantiPasswordScreen()),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color(0xff293066),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              size.width * 0.04,
                              0,
                              0,
                              0,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/pencil.svg',
                                  width: size.width * 0.05,
                                  height: size.height * 0.02,
                                ),
                                SizedBox(width: size.width * 0.04),
                                Text(
                                  'Ubah Kata Sandi',
                                  style: GoogleFonts.figtree(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          launchURL();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color(0xff293066),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              size.width * 0.04,
                              0,
                              0,
                              0,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/Phone.svg',
                                  width: size.width * 0.05,
                                  height: size.height * 0.02,
                                ),
                                SizedBox(width: size.width * 0.04),
                                Text(
                                  'Layanan Bantuan',
                                  style: GoogleFonts.figtree(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          customShowDialog(
                            context: context,
                            useForm: false,
                            text1: 'Oh tidak! Anda pergi...',
                            text2: 'Apa kamu yakin?',
                            txtButtonL: 'Batal',
                            txtButtonR: 'Ya, Tentu',
                            onPressedBtnL: () {
                              Navigator.pop(context);
                            },
                            onPressedBtnR: () {
                              logindata.setBool('login', true);
                              viewModel.keluar();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OnboardingScreen(),
                                ),
                                (route) => false,
                              );
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color(0xff293066),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              size.width * 0.04,
                              0,
                              0,
                              0,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/logout.svg',
                                  width: size.width * 0.05,
                                  height: size.height * 0.02,
                                ),
                                SizedBox(width: size.width * 0.04),
                                Text(
                                  'Keluar',
                                  style: GoogleFonts.figtree(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
