import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectmanagementstmiktime/screen/view/onboarding/onboarding.dart';
import 'package:projectmanagementstmiktime/screen/view/profile/profile_change_password_screen.dart';
import 'package:projectmanagementstmiktime/screen/widget/notifikasi/banner.dart';
import 'package:projectmanagementstmiktime/view_model/navigation/view_model_navigation.dart';
import 'package:projectmanagementstmiktime/view_model/profile/view_model_profile.dart';
import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // final token = sp.tokenSharedPreference;
    nav = Provider.of<NavigationProvider>(context, listen: false);
    sp.setSudahLogin();
    // viewModel.fetchProfile(
    //   accessToken: accessToken,
    //   refreshToken: refreshToken,
    // );
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Color(0xFF293066),
            fontFamily: 'Helvetica',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Color(0xff293066),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                      const Text(
                        'Akun',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica',
                          color: Color(0xff293066),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Oh tidak! Anda pergi...',
                                    style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Apa kamu yakin?',
                                    style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 20,
                                  top: 10,
                                ),
                                child: Transform.scale(
                                  scale: 1.3,
                                  child: SvgPicture.asset(
                                      'assets/mingcute_warning_fill.svg'),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              actions: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: size.width * .25,
                                          height: size.width * .12,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: const Color(0xff293066),
                                              width: 3,
                                            ),
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                            ),
                                            child: const Text(
                                              'Batal',
                                              style: TextStyle(
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            logindata.setBool('login', true);
                                            viewModel.keluar();
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const OnboardingScreen(),
                                              ),
                                              (route) => false,
                                            );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                          ),
                                          child: const Text(
                                            'Ya, Tentu',
                                            style: TextStyle(
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
                              size.height * 0.014,
                              0,
                              0,
                            ),
                            child: Text(
                              'Keluar',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GantiPasswordScreen()),
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
                            padding:
                                EdgeInsetsDirectional.fromSTEB(
                              size.width * 0.04,
                              size.height * 0.014,
                              0,
                              0,
                            ),
                            child: const Text(
                              'Ubah Kata Sandi',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Helvetica',
                              ),
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
