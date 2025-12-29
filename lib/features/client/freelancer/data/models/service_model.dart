import 'dart:convert';
import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    super.imageUrl,
    super.daysAvailability,
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

    // Handle images
    String imageUrl = '';

    // Check fields in order of valid usage
    // 1. cover_image
    // 2. image
    // 3. first item in images array if present

    if (json['cover_image'] != null &&
        json['cover_image'].toString().isNotEmpty) {
      imageUrl = json['cover_image'].toString();
    } else if (json['image'] != null && json['image'].toString().isNotEmpty) {
      imageUrl = json['image'].toString();
    } else {
      // Check images array
      final images = json['images'];
      if (images != null && images is List && images.isNotEmpty) {
        final first = images.first;
        if (first is Map) {
          imageUrl =
              first['url']?.toString() ?? first['image']?.toString() ?? '';
        } else {
          imageUrl = first.toString();
        }
      }
    }

    // Handle days availability as JSON string or list
    List<String> daysAvailability = [];
    final daysData = json['days_availability'];
    if (daysData is String) {
      try {
        final decoded = jsonDecode(daysData);
        if (decoded is List) {
          daysAvailability = decoded.map((e) => e.toString()).toList();
        }
      } catch (e) {
        // If not valid JSON, try splitting by comma
        daysAvailability = daysData.split(',').map((e) => e.trim()).toList();
      }
    } else if (daysData is List) {
      daysAvailability = daysData.map((e) => e.toString()).toList();
    }

    return ServiceModel(
      id: json['id']?.toString() ?? '',
      title: title,
      price: price,
      description: description,
      imageUrl: imageUrl,
      daysAvailability: daysAvailability,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'cover_image': imageUrl,
      'days_availability': daysAvailability,
    };
  }
}
