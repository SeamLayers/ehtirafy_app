class BaseResponse<T> {
  final int status;
  final String message;
  final T? data;

  BaseResponse({required this.status, required this.message, this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    int status = json['status'] as int? ?? 0;
    // If status is missing (0) but success is true, assume 200
    if (status == 0) {
      final success = json['success'];
      if (success == true || success == 'true') {
        status = 200;
      }
    }

    return BaseResponse<T>(
      status: status,
      message: json['message'] as String? ?? '',
      data: _parseData(json['data'], fromJsonT),
    );
  }

  static T? _parseData<T>(Object? data, T Function(Object? json) fromJsonT) {
    if (data == null) return null;
    // If data is an empty list, we should return it as is if T expects a List,
    // otherwise return null.
    // However, the previous logic was:
    // if (data is List && data.isEmpty) return null;
    // This caused empty lists to be treated as null data, which might trigger "no data" errors
    // or prevent empty state handling if the repository expects a list.
    
    // If T is a List type, we want the empty list.
    // Since we can't easily check T at runtime against List<E>, we rely on fromJsonT
    // to handle the empty list if it expects one.
    
    // But wait, if fromJsonT expects a Map and we pass a List, it will crash.
    // If the API returns [] for "no data" where an Object is expected, we should return null.
    // If the API returns [] for "empty list" where a List is expected, we should return [].
    
    // The issue described is: "Contracts retrieved successfully", "data": []
    // And the user says "nothing happened".
    // This implies that the app might be treating this as an error or not updating the state correctly.
    
    // If the repository expects a List<Contract>, and we return null here, 
    // the repository might throw an exception or return a failure.
    
    // Let's modify this to allow empty lists to pass through to fromJsonT.
    // It is the responsibility of fromJsonT (or the caller) to handle the type.

    return fromJsonT(data);
  }
}
