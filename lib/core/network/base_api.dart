import 'package:flutter/foundation.dart';
import 'package:fuvekonmobile/core/errors/exceptions.dart';
import 'package:fuvekonmobile/core/network/api_client.dart';
import 'package:fuvekonmobile/core/network/api_response.dart';

typedef JsonMap = Map<String, dynamic>;

/// Shared HTTP helpers for Fuvekon general API (`/api/general/v1`).
abstract class BaseApi {
  BaseApi(this._client);

  final ApiClient _client;

  @protected
  ApiClient get apiClient => _client;

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T? Function(dynamic value)? mapData,
    bool throwOnFailure = true,
  }) {
    return _envelope(
      _client.get<JsonMap>(path, queryParameters: queryParameters),
      mapData: mapData,
      throwOnFailure: throwOnFailure,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T? Function(dynamic value)? mapData,
    bool throwOnFailure = true,
  }) {
    return _envelope(
      _client.post<JsonMap>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
      mapData: mapData,
      throwOnFailure: throwOnFailure,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T? Function(dynamic value)? mapData,
    bool throwOnFailure = true,
  }) {
    return _envelope(
      _client.put<JsonMap>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
      mapData: mapData,
      throwOnFailure: throwOnFailure,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T? Function(dynamic value)? mapData,
    bool throwOnFailure = true,
  }) {
    return _envelope(
      _client.patch<JsonMap>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
      mapData: mapData,
      throwOnFailure: throwOnFailure,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T? Function(dynamic value)? mapData,
    bool throwOnFailure = true,
  }) {
    return _envelope(
      _client.delete<JsonMap>(
        path,
        data: data,
        queryParameters: queryParameters,
      ),
      mapData: mapData,
      throwOnFailure: throwOnFailure,
    );
  }

  /// Endpoints that return a raw JSON body (e.g. some conbook routes).
  Future<T> postRaw<T>(
    String path, {
    Object? data,
    required T Function(JsonMap json) map,
  }) async {
    final response = await _client.post<JsonMap>(path, data: data);
    final body = response.data;
    if (body == null) {
      throw const ServerException('Empty response');
    }
    return map(body);
  }

  Future<T> putRaw<T>(
    String path, {
    Object? data,
    required T Function(JsonMap json) map,
  }) async {
    final response = await _client.put<JsonMap>(path, data: data);
    final body = response.data;
    if (body == null) {
      throw const ServerException('Empty response');
    }
    return map(body);
  }

  Future<T> deleteRaw<T>(
    String path, {
    required T Function(JsonMap json) map,
  }) async {
    final response = await _client.delete<JsonMap>(path);
    final body = response.data;
    if (body == null) {
      throw const ServerException('Empty response');
    }
    return map(body);
  }

  Future<ApiResponse<T>> _envelope<T>(
    Future<dynamic> request, {
    T? Function(dynamic value)? mapData,
    required bool throwOnFailure,
  }) async {
    final response = await request;
    final body = response.data as JsonMap?;
    if (body == null) {
      final statusCode = response.statusCode as int?;
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        return ApiResponse<T>(
          isSuccess: true,
          message: 'Success',
          statusCode: statusCode,
        );
      }
      throw const ServerException('Empty response');
    }

    final parsed = ApiResponse<T>.fromJson(body, mapData: mapData);
    if (throwOnFailure && !parsed.isSuccess) {
      throw ServerException(
        parsed.errorMessage ?? parsed.message,
      );
    }
    return parsed;
  }
}

/// Builds query strings matching Fuvekon web `URLSearchParams` usage.
Map<String, dynamic> buildQuery(Map<String, dynamic> params) {
  final result = <String, dynamic>{};
  for (final entry in params.entries) {
    final value = entry.value;
    if (value == null) continue;
    if (value is String && value.trim().isEmpty) continue;
    result[entry.key] = value;
  }
  return result;
}

List<dynamic> mapJsonList(dynamic value) {
  if (value is! List) return [];
  return value;
}

JsonMap? mapJsonObject(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}
