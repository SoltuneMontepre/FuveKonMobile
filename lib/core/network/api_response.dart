/// Matches Fuvekon web `ApiResponse<T>` (`src/types/api/response.d.ts`).
class ApiResponse<T> {
  const ApiResponse({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
    this.errorMessage,
    this.errorCode,
    this.data,
    this.meta,
  });

  final bool isSuccess;
  final String message;
  final String? errorMessage;
  final String? errorCode;
  final T? data;
  final dynamic meta;
  final int statusCode;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T? Function(dynamic value)? mapData,
  }) {
    final rawData = json['data'];
    return ApiResponse<T>(
      isSuccess: json['isSuccess'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      errorMessage: json['errorMessage'] as String?,
      errorCode: json['errorCode'] as String?,
      data: mapData != null ? mapData(rawData) : rawData as T?,
      meta: json['meta'],
      statusCode: json['statusCode'] as int? ?? 0,
    );
  }
}
