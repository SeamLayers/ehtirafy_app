import 'dart:convert';
import '../../domain/entities/advertisement_details_entity.dart';

class AdvertisementDetailsModel extends AdvertisementDetailsEntity {
  const AdvertisementDetailsModel({
    required super.id,
    required super.categoryId,
    required super.title,
    required super.description,
    required super.viewerCount,
    required super.status,
    required super.price,
    required super.userId,
    required super.createdAt,
    super.daysAvailability,
    super.images,
  });

  factory AdvertisementDetailsModel.fromJson(Map<String, dynamic> json) {
    // Handle localized title
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

    // Handle viewer count
    int viewerCount = 0;
    final viewerData = json['count_viewer'];
    if (viewerData is num) {
      viewerCount = viewerData.toInt();
    } else if (viewerData is String) {
      viewerCount = int.tryParse(viewerData) ?? 0;
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

    // Handle images array
    List<String> images = [];
    final imagesData = json['images'];
    if (imagesData != null && imagesData is List) {
      images = imagesData
          .map((e) {
            if (e is Map) {
              return e['url']?.toString() ?? e['image']?.toString() ?? '';
            }
            return e.toString();
          })
          .where((s) => s.isNotEmpty)
          .toList();
    }

    // Format created date
    String formattedDate = '';
    final createdAt = json['created_at'];
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt.toString());
        formattedDate =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } catch (e) {
        formattedDate = createdAt.toString();
      }
    }

    return AdvertisementDetailsModel(
      id: json['id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      title: title,
      description: description,
      viewerCount: viewerCount,
      status: json['status']?.toString() ?? '',
      price: price,
      userId: json['user_id']?.toString() ?? '',
      createdAt: formattedDate,
      daysAvailability: daysAvailability,
      images: images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'count_viewer': viewerCount,
      'status': status,
      'price': price,
      'user_id': userId,
      'created_at': createdAt,
      'days_availability': daysAvailability,
      'images': images,
    };
  }
}
