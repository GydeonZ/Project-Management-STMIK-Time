import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:projectmanagementstmiktime/main.dart';

Future customAlert({
  required QuickAlertType alertType,
  bool autoClose = true,
  Duration autoCloseDuration = const Duration(seconds: 3),
  String? customAsset,
  String? text,
  String? title,
  VoidCallback? afterDelay,
}) async {
  final context = navigatorKey.currentState?.overlay?.context;
  if (context == null) return;

  QuickAlert.show(
    barrierDismissible: false,
    showCancelBtn: false,
    showConfirmBtn: false,
    animType: QuickAlertAnimType.slideInDown,
    backgroundColor: Colors.white,
    context: context,
    title: title ?? '',
    type: alertType,
    customAsset: customAsset,
    text: text,
    widget: const SizedBox(),
  );
  if (autoClose) {
    await Future.delayed(autoCloseDuration);
    afterDelay?.call();
    navigatorKey.currentState?.pop();
  }
}
