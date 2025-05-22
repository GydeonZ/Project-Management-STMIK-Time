import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectmanagementstmiktime/services/service_comment.dart';

class CommentViewModel with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  bool isLoading = false;
  bool isSukses = false;
  final service = CommentService();
  String? successMessage;
  String? errorMessages;
  
  Future<int> postCommentTask({
    required String token,
    required int taskId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await service.hitPostComment(
        token: token,
        comment: commentController.text,
        taskId: taskId,
      );

      isLoading = false;

      if (response != null) {
        successMessage = response.message;
        errorMessages = null;
        isSukses = true;
        commentController.clear();
        notifyListeners();
        return 200;
      } else {
        isSukses = false;
        notifyListeners();
        return 500;
      }
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      if (e.response != null && e.response!.statusCode == 400) {
        errorMessages = e.message; // ✅ Ambil langsung message dari DioException
        return 400;
      }

      errorMessages = "Terjadi kesalahan: ${e.message}";
      return 500;
    }
  }
}
