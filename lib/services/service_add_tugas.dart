import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_tambah_tugas.dart';
import '../utils/utils.dart';

class TambahTugasService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500; // Jangan anggap 401 sebagai error
    },
  ));

  Future<ModelTambahTugas?> hitTambahTugas({
    required String token,
    required String cardId,
    required String namaCard,
    required String? deskripsiTugas,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Format DateTime ke format yang diharapkan oleh API
      String formattedStartDate =
          "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')} ${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}:${startDate.second.toString().padLeft(2, '0')}";
      String formattedEndDate =
          "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')} ${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}:${endDate.second.toString().padLeft(2, '0')}";

      // Buat body sesuai format yang diharapkan
      final formData = FormData.fromMap({
        'card_id': cardId,
        'name': namaCard,
        'description': deskripsiTugas,
        'start_time': formattedStartDate,
        'end_time': formattedEndDate,
      });

      // Kirim request POST ke API
      final response = await _dio.post(
        Urls.apiTugas, // Endpoint API
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Sertakan token
          },
        ),
      );

      // Periksa status response
      if (response.statusCode == 200) {
        return ModelTambahTugas.fromJson(response.data);
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
          message: "Gagal menambahkan tugas: ${response.statusMessage}",
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
