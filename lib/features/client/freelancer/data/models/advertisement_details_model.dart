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
    super.categoryName = '',
    super.daysAvailability,
    super.images,
    super.ownerPhone = '',
    super.cityAr = '',
    super.cityEn = '',
  });

  factory AdvertisementDetailsModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely get String from localized or simple field
    String getString(dynamic data) {
      if (data == null) return '';
      if (data is Map) {
        return data['ar']?.toString() ?? data['en']?.toString() ?? '';
      }
      return data.toString();
    }

    // Helper to safely parse localized category name
    String getCategoryName(dynamic categoryData) {
      if (categoryData == null) return '';
      if (categoryData is Map) {
        final nameData = categoryData['name'];
        return getString(nameData);
      }
      if (categoryData is String) return categoryData;
      return '';
    }

    // Safely parse double
    double getDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // Safely parse int
    int getInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // Safely parse formatted date
    String getFormattedDate(dynamic dateData) {
      if (dateData == null) return '';
      try {
        final date = DateTime.parse(dateData.toString());
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } catch (_) {
        return dateData.toString();
      }
    }

    // Safely parse list of strings
    List<String> getList(dynamic data) {
      if (data == null) return [];
      if (data is List) {
        return data
            .map((e) => e?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList();
      }
      if (data is String) {
        try {
          final decoded = jsonDecode(data);
          if (decoded is List) {
            return decoded
                .map((e) => e?.toString() ?? '')
                .where((s) => s.isNotEmpty)
                .toList();
          }
        } catch (_) {
          // Try splitting by comma if not JSON
          return data
              .split(',')
              .map((e) => e.trim())
              .where((s) => s.isNotEmpty)
              .toList();
        }
      }
      return [];
    }

    // Safely parse images
    List<String> getImages(dynamic data) {
      if (data == null) return [];
      if (data is List) {
        return data
            .map((e) {
              if (e is Map) {
                return e['url']?.toString() ?? e['image']?.toString() ?? '';
              }
              return e?.toString() ?? '';
            })
            .where((s) => s.isNotEmpty)
            .toList();
      }
      return [];
    }

    // Advertiser phone — parsed defensively from the common shapes the
    // backend may use (top-level, nested user, or alternate keys). Stays
    // empty until the API exposes it.
    String getPhone() {
      final candidates = <dynamic>[
        json['phone'],
        json['mobile'],
        json['phone_number'],
      ];
      final user = json['user'];
      if (user is Map) {
        candidates.addAll([
          user['phone'],
          user['mobile'],
          user['phone_number'],
        ]);
      }
      for (final c in candidates) {
        final value = c?.toString().trim() ?? '';
        if (value.isNotEmpty) return value;
      }
      return '';
    }

    // City may be a {ar,en} object, a plain string, or null/absent.
    String cityAr = '';
    String cityEn = '';
    final cityRaw = json['city'];
    if (cityRaw is Map) {
      cityAr = cityRaw['ar']?.toString() ?? '';
      cityEn = cityRaw['en']?.toString() ?? '';
    } else if (cityRaw != null) {
      final s = cityRaw.toString();
      if (s.isNotEmpty && s != 'null') {
        cityAr = s;
        cityEn = s;
      }
    }

    final images = getImages(json['images']);

    // Add cover_image to images if needed
    final coverImage =
        json['cover_image']?.toString() ?? json['image']?.toString();
    if (coverImage != null &&
        coverImage.isNotEmpty &&
        !images.contains(coverImage)) {
      images.insert(0, coverImage);
    }

    return AdvertisementDetailsModel(
      id: json['id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      title: getString(json['title']),
      description: getString(json['description']),
      viewerCount: getInt(json['count_viewer']),
      status: json['status']?.toString() ?? '',
      price: getDouble(json['price']),
      userId: json['user_id']?.toString() ?? '',
      createdAt: getFormattedDate(json['created_at']),
      categoryName: getCategoryName(json['category']),
      daysAvailability: getList(json['days_availability']),
      images: images,
      ownerPhone: getPhone(),
      cityAr: cityAr,
      cityEn: cityEn,
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
      'category_name': categoryName,
      'days_availability': daysAvailability,
      'images': images,
    };
  }
}
