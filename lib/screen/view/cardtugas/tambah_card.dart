// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:projectmanagementstmiktime/screen/view/board/board.dart';
// import 'package:projectmanagementstmiktime/screen/widget/alert.dart';
// import 'package:projectmanagementstmiktime/screen/widget/formfield.dart';
// import 'package:projectmanagementstmiktime/view_model/cardtugas/view_model_card_tugas.dart';
// import 'package:projectmanagementstmiktime/view_model/sign_in_sign_up/view_model_signin.dart';
// import 'package:provider/provider.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// // import 'package:skeletonizer/skeletonizer.dart';

// class TambahCardScreen extends StatefulWidget {
//   const TambahCardScreen({super.key});

//   @override
//   State<TambahCardScreen> createState() => _TambahCardScreenState();
// }

// class _TambahCardScreenState extends State<TambahCardScreen> {
//   late CardTugasViewModel cardTugasViewModel;
//   late SignInViewModel sp;
//   @override
//   void initState() {
//     super.initState();
//     cardTugasViewModel =
//         Provider.of<CardTugasViewModel>(context, listen: false);
//     sp = Provider.of<SignInViewModel>(context, listen: false);
//     final token = sp.tokenSharedPreference;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       cardTugasViewModel.getCardTugasList(token: token);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: const Text(
//           'Card',
//           style: TextStyle(
//             color: Color(0xFF293066),
//             fontFamily: 'Helvetica',
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.close,
//             color: Color(0xff293066),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Consumer<CardTugasViewModel>(builder: (context, viewModel, child) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                   child: Form(
//                 key: viewModel.formKey,
//                 child: customTextFormField(
//                     controller: viewModel.namaTugas,
//                     titleText: "Nama Tugas",
//                     labelText: "Masukkan Judul Tugas Anda",
//                     validator: (value) => viewModel.validateNamaTugas(value!)),
//               )),
//               Padding(
//                 padding: EdgeInsets.only(bottom: size.height * 0.02),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         width: size.width * .4,
//                         height: size.width * .12,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: const Color(0xff293066),
//                             width: 3,
//                           ),
//                         ),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           style: ButtonStyle(
//                             backgroundColor:
//                                 WidgetStateProperty.all(Colors.transparent),
//                             shadowColor:
//                                 WidgetStateProperty.all(Colors.transparent),
//                           ),
//                           child: const Text(
//                             "Batal",
//                             style: TextStyle(
//                               fontFamily: 'Helvetica',
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                               color: Color(0xff293066),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: size.width * .4,
//                       height: size.width * .12,
//                       decoration: BoxDecoration(
//                         color: const Color(0xff293066),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           final token = sp.tokenSharedPreference;
//                           if (viewModel.formKey.currentState!.validate()) {
//                             // ✅ Tampilkan loading alert sebelum login
//                             customAlert(
//                               alertType: QuickAlertType.loading,
//                               text: "Mohon tunggu...",
//                             );
//                             FocusScope.of(context).unfocus();
//                             try {
//                               final response =
//                                   await viewModel.tambahTugasCard(token: token);

//                               if (!context.mounted) return;
//                               Navigator.pop(context); // Tutup loading alert

//                               if (response == 200) {
//                                 customAlert(
//                                   alertType: QuickAlertType.success,
//                                   title: viewModel.successMessage ??
//                                       "Tugas berhasil ditambahkan",
//                                   afterDelay: () {
//                                     Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             const BoardScreen(),
//                                       ),
//                                     );
//                                   },
//                                 );
//                                 viewModel.namaTugas.clear();
//                               } else {
//                                 customAlert(
//                                   alertType: QuickAlertType.error,
//                                   text: 'Terjadi kesalahan. Coba lagi nanti.',
//                                 );
//                               }
//                             } on SocketException catch (_) {
//                               customAlert(
//                                 alertType: QuickAlertType.warning,
//                                 text:
//                                     'Tidak ada koneksi internet. Periksa jaringan Anda.',
//                               );
//                             } catch (e) {
//                               customAlert(
//                                 alertType: QuickAlertType.error,
//                                 text: 'Terjadi kesalahan: ${e.toString()}',
//                               );
//                             }
//                           }
//                         }, // Gunakan callback onPressed
//                         style: ButtonStyle(
//                           backgroundColor:
//                               WidgetStateProperty.all(Colors.transparent),
//                           shadowColor:
//                               WidgetStateProperty.all(Colors.transparent),
//                         ),
//                         child: const Text(
//                           "Tambah",
//                           style: TextStyle(
//                             fontFamily: 'Helvetica',
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
