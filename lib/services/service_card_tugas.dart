// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_fetch_card_tugas.dart';
import 'package:projectmanagementstmiktime/utils/utils.dart';

class CardTugasService {
  final Dio _dio = Dio();

  Future<ModelFetchCardTugas> fetchCardTugas({
    required String token,
  }) async {
    try {
      final response = await _dio.get(
        Urls.baseUrls + Urls.fetchCardList,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print("API Response: ${response.data}"); // Debugging output
      return ModelFetchCardTugas.fromJson(response.data);
    } on DioException catch (_) {
      rethrow;
    }
  }
}
