import '../../domain/entities/request_entity.dart';

class RequestModel extends RequestEntity {
  const RequestModel({
    required super.id,
    required super.serviceName,
    required super.photographerName,
    required super.photographerId,
    required super.advertisementId,
    required super.photographerImage,
    required super.status,
    required super.price,
    required super.date,
    super.isPaymentRequired,
    super.approvedDate,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? '',
      photographerName: json['photographerName']?.toString() ?? '',
      photographerId: json['photographerId']?.toString() ?? '',
      advertisementId: json['advertisementId']?.toString() ?? '',
      photographerImage: json['photographerImage']?.toString() ?? '',
      status: RequestStatus.values.firstWhere(
        (e) => e.toString() == 'RequestStatus.${json['status']}',
        orElse: () => RequestStatus.underReview,
      ),
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      isPaymentRequired: json['isPaymentRequired'] is bool
          ? json['isPaymentRequired'] as bool
          : false,
      approvedDate: json['approvedDate'] != null
          ? DateTime.tryParse(json['approvedDate'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'photographerName': photographerName,
      'photographerId': photographerId,
      'advertisementId': advertisementId,
      'photographerImage': photographerImage,
      'status': status.name,
      'price': price,
      'date': date.toIso8601String(),
      'isPaymentRequired': isPaymentRequired,
      'approvedDate': approvedDate?.toIso8601String(),
    };
  }
}
