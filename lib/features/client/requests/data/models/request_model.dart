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
      id: json['id'],
      serviceName: json['serviceName'],
      photographerName: json['photographerName'],
      photographerId: json['photographerId'] ?? '',
      advertisementId: json['advertisementId'] ?? '',
      photographerImage: json['photographerImage'],
      status: RequestStatus.values.firstWhere(
        (e) => e.toString() == 'RequestStatus.${json['status']}',
        orElse: () => RequestStatus.underReview,
      ),
      price: (json['price'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      isPaymentRequired: json['isPaymentRequired'] ?? false,
      approvedDate: json['approvedDate'] != null
          ? DateTime.parse(json['approvedDate'])
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
