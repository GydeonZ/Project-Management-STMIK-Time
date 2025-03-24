import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_sign_up.dart';
import '../utils/utils.dart';

class SignUpService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500; // ✅ Jangan anggap 401 sebagai error
    },
  ));

  Future<ModelRegister?> signUpAccount({
    required String nameUser,
    required String emailUser,
    required String passwordUser,
    required String passwordConfirmationUser,
    required String roleUser,
    required String nimUser,
    required String nidnUser,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': nameUser,
        'email': emailUser,
        'password': passwordUser,
        'password_confirmation': passwordConfirmationUser,
        'role': roleUser,
        'nim': nimUser,
        'nidn': nidnUser,
      });

      final response = await _dio.post(
        Urls.register,
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelRegister.fromJson(response.data); // ✅ Berhasil daftar
      } else if (response.statusCode == 422) {
        // ✅ Ambil pesan error dari response API
        final errors = response.data['errors'];
        String errorMessage = "422: Validasi data gagal\n";

        if (errors.containsKey('email')) {
          errorMessage += "• Email: ${errors['email'][0]}\n";
        }
        if (errors.containsKey('nim')) {
          errorMessage += "• NIM: ${errors['nim'][0]}\n";
        }
        if (errors.containsKey('nidn')) {
          errorMessage += "• NIDN: ${errors['nidn'][0]}\n";
        }

        throw Exception(errorMessage);
      } else {
        throw Exception(
            "❌ Error ${response.statusCode}: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 422) {
        final errors = e.response!.data['errors'];
        String errorMessage = "422: Validasi data gagal\n";

        if (errors.containsKey('email')) {
          errorMessage += "• Email: ${errors['email'][0]}\n";
        }
        if (errors.containsKey('nim')) {
          errorMessage += "• NIM: ${errors['nim'][0]}\n";
        }
        if (errors.containsKey('nidn')) {
          errorMessage += "• NIDN: ${errors['nidn'][0]}\n";
        }

        throw Exception(errorMessage);
      }
      throw Exception("⚠️ Kesalahan jaringan: ${e.message}");
    }
  }
}
