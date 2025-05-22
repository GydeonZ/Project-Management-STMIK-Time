import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_update_profile.dart';
import '../utils/utils.dart';

class UpdateProfileService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500; // ✅ Jangan anggap 401 sebagai error
    },
  ));

  Future<ModelUpdateProfile?> hitUpdateProfile({
    required String token,
    required String nameUser,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': nameUser,
      });

      final response = await _dio.post(
        Urls.updateProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelUpdateProfile.fromJson(response.data);
      }  else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          message: "Terjadi kesalahan: ${response.statusMessage}",
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      // ✅ Pastikan error dari API tetap ditampilkan
      if (e.response != null) {
        rethrow; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions: RequestOptions(path: Urls.updateProfile),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }
}
