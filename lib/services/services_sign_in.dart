import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_sign_in.dart';
import '../utils/utils.dart';

class SignInService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500; // ✅ Jangan anggap 401 sebagai error
    },
  ));

  Future<ModelSignIn?> signInAccount({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        Urls.login, // ✅ Jangan tambahkan baseUrl lagi
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return ModelSignIn.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw Exception("401: Password salah");
      } else if (response.statusCode == 403) {
        throw Exception("403: Email belum diverifikasi");
      } else {
        throw Exception(
            "❌ Error ${response.statusCode}: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          throw Exception("401: Password salah");
        } else if (e.response!.statusCode == 403) {
          throw Exception("403: Email belum diverifikasi");
        }
      }
      throw Exception("⚠️ Kesalahan jaringan: ${e.message}");
    }
  }
}
