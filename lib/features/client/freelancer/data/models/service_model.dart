import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    // Handle localized title {ar: ..., en: ...}
    String title = '';
    final titleData = json['title'];
    if (titleData is Map) {
      title = titleData['ar']?.toString() ?? titleData['en']?.toString() ?? '';
    } else if (titleData != null) {
      title = titleData.toString();
    }

    // Handle localized description
    String description = '';
    final descData = json['description'];
    if (descData is Map) {
      description =
          descData['ar']?.toString() ?? descData['en']?.toString() ?? '';
    } else if (descData != null) {
      description = descData.toString();
    }

    // Handle price as string or number
    double price = 0.0;
    final priceData = json['price'];
    if (priceData is num) {
      price = priceData.toDouble();
    } else if (priceData is String) {
      price = double.tryParse(priceData) ?? 0.0;
    }

    return ServiceModel(
      id: json['id']?.toString() ?? '',
      title: title,
      price: price,
      description: description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
    };
  }
}
