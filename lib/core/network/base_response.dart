class BaseResponse<T> {
  final int status;
  final String message;
  final T? data;

  BaseResponse({required this.status, required this.message, this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return BaseResponse<T>(
      status: json['status'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: _parseData(json['data'], fromJsonT),
    );
  }

  static T? _parseData<T>(Object? data, T Function(Object? json) fromJsonT) {
    if (data == null) return null;
    // Handle specific case where API returns empty list [] instead of null/object when error occurs
    if (data is List && data.isEmpty) return null;
    return fromJsonT(data);
  }
}
