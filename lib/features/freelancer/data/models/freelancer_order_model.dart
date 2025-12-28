import '../../domain/entities/freelancer_order_entity.dart';

class FreelancerOrderModel extends FreelancerOrderEntity {
  const FreelancerOrderModel({
    required super.id,
    required super.serviceTitle,
    required super.clientName,
    required super.clientImage,
    required super.status,
    required super.price,
    required super.location,
    required super.eventDate,
    required super.createdAt,
  });

  factory FreelancerOrderModel.fromJson(Map<String, dynamic> json) {
    return FreelancerOrderModel(
      id: json['id'] as String,
      serviceTitle: json['serviceTitle'] as String,
      clientName: json['clientName'] as String,
      clientImage: json['clientImage'] as String,
      status: _parseStatus(json['status'] as String),
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceTitle': serviceTitle,
      'clientName': clientName,
      'clientImage': clientImage,
      'status': _statusToString(status),
      'price': price,
      'location': location,
      'eventDate': eventDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  FreelancerOrderModel copyWith({
    String? id,
    String? serviceTitle,
    String? clientName,
    String? clientImage,
    FreelancerOrderStatus? status,
    double? price,
    String? location,
    DateTime? eventDate,
    DateTime? createdAt,
  }) {
    return FreelancerOrderModel(
      id: id ?? this.id,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      clientName: clientName ?? this.clientName,
      clientImage: clientImage ?? this.clientImage,
      status: status ?? this.status,
      price: price ?? this.price,
      location: location ?? this.location,
      eventDate: eventDate ?? this.eventDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static FreelancerOrderStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return FreelancerOrderStatus.pending;
      case 'inProgress':
        return FreelancerOrderStatus.inProgress;
      case 'completed':
        return FreelancerOrderStatus.completed;
      case 'cancelled':
        return FreelancerOrderStatus.cancelled;
      default:
        return FreelancerOrderStatus.pending;
    }
  }

  static String _statusToString(FreelancerOrderStatus status) {
    switch (status) {
      case FreelancerOrderStatus.pending:
        return 'pending';
      case FreelancerOrderStatus.inProgress:
        return 'inProgress';
      case FreelancerOrderStatus.completed:
        return 'completed';
      case FreelancerOrderStatus.cancelled:
        return 'cancelled';
    }
  }
}
