import 'package:equatable/equatable.dart';

enum RequestStatus { active, underReview, completed, cancelled }

class RequestEntity extends Equatable {
  final String id;
  final String serviceName;
  final String photographerName;
  final String photographerId;
  final String advertisementId;
  final String photographerImage;
  final RequestStatus status;
  final double price;
  final DateTime date;
  final bool isPaymentRequired;
  final DateTime? approvedDate;

  const RequestEntity({
    required this.id,
    required this.serviceName,
    required this.photographerName,
    required this.photographerId,
    required this.advertisementId,
    required this.photographerImage,
    required this.status,
    required this.price,
    required this.date,
    this.isPaymentRequired = false,
    this.approvedDate,
  });

  @override
  List<Object?> get props => [
    id,
    serviceName,
    photographerName,
    photographerId,
    advertisementId,
    photographerImage,
    status,
    price,
    date,
    isPaymentRequired,
    approvedDate,
  ];
}
