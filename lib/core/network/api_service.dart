// lib/core/network/api_service.dart

import 'package:tads/api/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_URL'] ?? '',
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path == Endpoints.login) {
            return handler.next(options);
          }
          
          const storage = FlutterSecureStorage();
          final token = await storage.read(key: 'authToken');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) {
          if (e.response != null) {
            final statusCode = e.response?.statusCode;
            final responseType = e.response?.data['type'] ?? 'error';
            final responseMessage =
                e.response?.data['error'] ?? 'Error desconocido';

            switch (statusCode) {
              case 400:
              case 401:
              case 403:
                if (responseType == 'info') {
                  log('API Info: $responseMessage');
                } else if (responseType == 'error') {
                  log('API Error: $responseMessage');
                }
                break;
              case 500:
                log('Error del servidor');
                break;
              default:
                log('Error: $responseMessage');
            }
          } else {
            if (kDebugMode) {
              log('Error de conexión: ${e.message}');
            }
            if (e.type == DioExceptionType.connectionError) {
              log(
                'No se puede conectar al servidor. Verifica tu conexión. ${dotenv.env['API_URL']}',
              );
            } else if (e.type == DioExceptionType.connectionTimeout) {
              log('Tiempo de conexión agotado');
            } else {
              log('Error de conexión');
            }
          }

          return handler.reject(e);
        },
      ),
    );
  }

  // =======================================================
  // MÉTODOS WRAPPER PARA EL DATA SOURCE
  // =======================================================

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(
          path,
          queryParameters: queryParameters
      );
      return response.data;
    } on DioException catch (e) {
      // --- CORRECCIÓN ---
      // Si la API devuelve 404 para la lista de estudiantes (porque está vacía),
      // lo interpretamos como una lista vacía, no como un error.
      if (e.response?.statusCode == 404 && path == Endpoints.students) {
        log('ApiService: Capturado 404 en GET /students. Devolviendo lista vacía.');
        return []; // Devuelve una lista vacía en lugar de lanzar un error.
      }
      // Para cualquier otro error, lo relanzamos para que sea manejado como un error real.
      rethrow;
    }
  }

  Future<dynamic> post(String path, {required Map<String, dynamic> data}) async {
    final response = await dio.post(
        path,
        data: data
    );
    return response.data;
  }

  Future<dynamic> patch(String path, {required Map<String, dynamic> data}) async {
    final response = await dio.patch(
        path,
        data: data
    );
    return response.data;
  }
  
  Future<dynamic> put(String path, {required Map<String, dynamic> data}) async {
    final response = await dio.put(
        path,
        data: data
    );
    return response.data;
  }
}
