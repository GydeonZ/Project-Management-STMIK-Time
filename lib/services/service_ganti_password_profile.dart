import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_ganti_password_profile.dart';
import '../utils/utils.dart';

class GantiPasswordProfileService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500; // ✅ Jangan anggap 401 sebagai error
    },
  ));

  Future<ModelGantiPasswordProfile?> hitGantiPasswordProfile({
    required String token,
    required String pwdSekarang,
    required String password,
    required String pwdConfirm,
  }) async {
    try {
      final formData = FormData.fromMap({
        'current_password': pwdSekarang,
        'password': password,
        'password_confirmation': pwdConfirm,
      });

      final response = await _dio.post(
        Urls.gantiPasswordProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelGantiPasswordProfile.fromJson(response.data);
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
            message: "Password Lama salah.",
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
        throw e; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions: RequestOptions(path: Urls.gantiPasswordProfile),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }
}
