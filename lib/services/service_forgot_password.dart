import 'package:dio/dio.dart';
import 'package:projectmanagementstmiktime/model/model_ganti_password.dart';
import 'package:projectmanagementstmiktime/model/model_request_otp.dart';
import 'package:projectmanagementstmiktime/model/model_verifikasi_otp.dart';
import '../utils/utils.dart';

class ForgotPasswordService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Urls.baseUrls,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) {
      return status! < 500; // Jangan anggap 401 sebagai error
    },
  ));

  Future<ModelRequestOtp?> requestOTP({
    required String emailUser,
  }) async {
    try {
      final formData = FormData.fromMap({'email': emailUser});

      final response = await _dio.post(
        Urls.reqOTP,
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelRequestOtp.fromJson(response.data);
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
      } else if (response.statusCode == 429) {
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
            message: "Terlalu banyak permintaan OTP. Coba lagi nanti.",
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
      if (e.response != null && e.response!.statusCode == 400 ||
          e.response!.statusCode == 429) {
        rethrow; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions: RequestOptions(path: Urls.reqOTP),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }

  Future<ModelVerifikasiOtp?> hitVerifikasiOTP({
    required String emailUser,
    required String kodeOTP,
  }) async {
    try {
      final formData = FormData.fromMap({'email': emailUser, 'otp': kodeOTP});

      final response = await _dio.post(
        Urls.verifikasiOTP,
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelVerifikasiOtp.fromJson(response.data);
      } else if (response.statusCode == 422) {
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
            message: "OTP Tidak Valid.",
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
      if (e.response != null && e.response!.statusCode == 422) {
        rethrow; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions: RequestOptions(path: Urls.reqOTP),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }
  
  Future<ModelGantiPassword?> hitUbahPassword({
    required String emailUser,
    required String password,
    required String cnfrmPassword,
    required String token,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': emailUser,
        'password': password,
        'password_confirmation': cnfrmPassword,
        'token': token,
      });

      final response = await _dio.post(
        Urls.gantiPassword,
        data: formData,
      );

      if (response.statusCode == 200) {
        return ModelGantiPassword.fromJson(response.data);
      } else if (response.statusCode == 422) {
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
            message: "Token Tidak Valid.",
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
      if (e.response != null && e.response!.statusCode == 422) {
        rethrow; // Lempar kembali error untuk ditangani di ViewModel
      }
      throw DioException(
        requestOptions: RequestOptions(path: Urls.reqOTP),
        message: "Kesalahan jaringan: ${e.message}",
        type: DioExceptionType.connectionError,
      );
    }
  }
}