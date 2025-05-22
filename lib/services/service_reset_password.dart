import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_reset_password.dart';
import '../utils/utils.dart';

class ResetPasswordService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500; // Jangan anggap 401 sebagai error
    },
  ));

  Future<ModelResetPassword?> resetPasswordUser({
    required String tokenLink, // ✅ Gunakan token dari URL
    required String emailLink, // ✅ Gunakan email dari URL
    required String passwordUser,
    required String cnfrmpasswordUser,
  }) async {
    try {
      final formData = FormData.fromMap({
        'token': tokenLink, // ✅ Token dari URL
        'email': emailLink, // ✅ Email dari URL
        'password': passwordUser,
        'password_confirmation': cnfrmpasswordUser,
      });

      final String url =
          '${Urls.baseUrls}${Urls.resetPassword}/$tokenLink?email=$emailLink';

      final response = await _dio.post(
        url, // ✅ Token & email dalam URL
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelResetPassword.fromJson(response.data);
      } else if (response.statusCode == 400) {
        // ✅ Pastikan response.data dalam bentuk Map
        if (response.data is Map<String, dynamic> &&
            response.data.containsKey("message")) {
          throw DioException(
            response: response,
            requestOptions: response.requestOptions,
            message: response.data["message"], // Kirim hanya "message"
            type: DioExceptionType.badResponse,
          );
        } else {
          throw DioException(
            response: response,
            requestOptions: response.requestOptions,
            message: "Email tidak ditemukan.",
            type: DioExceptionType.badResponse,
          );
        }
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          message: "Terjadi kesalahan: ${response.statusMessage}",
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      // ✅ Pastikan error dari API tetap ditampilkan
      if (e.response != null && e.response!.statusCode == 400) {
        rethrow; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions: RequestOptions(path: Urls.resetPassword),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }
}
