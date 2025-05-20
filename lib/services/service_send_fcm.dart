import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_send_fcm.dart';
import '../utils/utils.dart';

class SendFCMTokenService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500; // ✅ Jangan anggap 401 sebagai error
    },
  ));

  Future<ModelSendFcm?> sendFCMTokenDevice({
    required String token,
    required String deviceToken,
    required String deviceType,
    
  }) async {
    try {
      final formData = FormData.fromMap({
        'device_token': deviceToken,
        'device_type': deviceType,
      });

      final response = await _dio.post(
        Urls.fcmToken,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelSendFcm.fromJson(response.data);
      } else {
        // Dapatkan pesan error dari respons API
        String errorMessage = "Terjadi kesalahan";
        if (response.data != null && response.data is Map) {
          errorMessage = response.data['message'] ?? errorMessage;
        }

        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          message: errorMessage, // Gunakan pesan dari API
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Ekstrak pesan error dari respons API
        String apiErrorMessage = "Terjadi kesalahan";
        if (e.response!.data != null && e.response!.data is Map) {
          apiErrorMessage = e.response!.data['message'] ?? apiErrorMessage;
        }

        throw DioException(
          response: e.response,
          requestOptions: e.requestOptions,
          message: apiErrorMessage, // Gunakan pesan dari API
          type: e.type,
        );
      }
      rethrow; // Re-throw jika tidak ada respons
    }
  }
}
