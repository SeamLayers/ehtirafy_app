import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';

class PhotographerModel extends PhotographerEntity {
  const PhotographerModel({
    required super.id,
    required super.name,
    required super.category,
    required super.rating,
    required super.reviewsCount,
    required super.location,
    required super.price,
    required super.imageUrl,
    super.daysAvailability,
    required super.freelancerId,
    super.cityAr,
    super.cityEn,
  });

  factory PhotographerModel.fromJson(Map<String, dynamic> json) {
    // Parse nested user object
    final userRaw = json['user'];
    final user =
        userRaw is Map ? Map<String, dynamic>.from(userRaw) : null;
    final advertisementRaw = json['advertisement'];
    final advertisement = advertisementRaw is Map
        ? Map<String, dynamic>.from(advertisementRaw)
        : null;

    // Get user ID (Freelancer ID)
    final userId =
        json['user_id']?.toString() ??
        user?['id']?.toString() ??
        json['id']?.toString() ??
        '';

    // Get Entity ID (Advertisement ID or User ID depending on context)
    // If it's an advertisement response, use advertisement ID or root ID
    // If it's a user response, it will reuse json['id'] which matches userId
    final entityId =
        advertisement?['id']?.toString() ?? json['id']?.toString() ?? userId;

    // Get name from nested user object
    final name = user?['name']?.toString() ?? json['name']?.toString() ?? '';

    // Parse localized title from advertisement or root json
    String category = '';
    final title = advertisement?['title'] ?? json['title'];
    if (title is Map) {
      // Prefer Arabic, fallback to English
      category = title['ar']?.toString() ?? title['en']?.toString() ?? '';
    } else if (title != null) {
      category = title.toString();
    }

    // Get rating from rate field
    final double rating = _asDouble(json['rate']);

    // Get price from advertisement or root json
    final int price = _asInt(advertisement?['price'] ?? json['price']);

    // Location is not in the API, use empty or country_code from user
    final location = user?['country_code']?.toString() ?? '';

    // Image URL - check for avatar in user object
    // Note: Current API doesn't return avatars, using placeholder
    // Image URL - check for advertisement image first, then user avatar
    final imageUrl =
        advertisement?['cover_image']?.toString() ??
        advertisement?['image']?.toString() ??
        json['cover_image']?.toString() ??
        json['image']?.toString() ??
        user?['avatar']?.toString() ??
        json['avatar']?.toString() ??
        json['imageUrl']?.toString() ??
        '';

    // Fallback to first image from images list if imageUrl is empty
    String finalImageUrl = imageUrl;
    if (finalImageUrl.isEmpty) {
      final imagesList = advertisement?['images'] ?? json['images'];
      if (imagesList is List && imagesList.isNotEmpty) {
        finalImageUrl = imagesList.first.toString();
      }
    }

    // Parse days availability
    List<String> daysAvailability = [];
    final daysString =
        advertisement?['days_availability']?.toString() ??
        json['days_availability']?.toString();

    if (daysString != null) {
      try {
        // Handle stringified JSON array: "["sat","sun"]"
        if (daysString.startsWith('[') && daysString.endsWith(']')) {
          final cleanString = daysString.substring(1, daysString.length - 1);
          if (cleanString.isNotEmpty) {
            daysAvailability = cleanString
                .split(',')
                .map((e) => e.trim().replaceAll('"', '').replaceAll("'", ""))
                .toList();
          }
        }
      } catch (e) {
        // Fallback or log error if needed
      }
    }

    // City may be a {ar,en} object at the row root (new /front/advertisements
    // feed) or on the nested advertisement; tolerate a plain string or null.
    String cityAr = '';
    String cityEn = '';
    final cityRaw = json['city'] ?? advertisement?['city'];
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

    return PhotographerModel(
      id: entityId,
      name: name,
      category: category,
      rating: rating,
      reviewsCount: 0,
      location: location,
      price: price,
      imageUrl: finalImageUrl,
      daysAvailability: daysAvailability,
      freelancerId: userId,
      cityAr: cityAr,
      cityEn: cityEn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'location': location,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

/// Tolerantly parses a dynamic API value into an [int], returning 0 on failure.
int _asInt(dynamic v) {
  if (v is num) return v.toInt();
  final s = v?.toString();
  if (s == null) return 0;
  return int.tryParse(s) ?? double.tryParse(s)?.toInt() ?? 0;
}

/// Tolerantly parses a dynamic API value into a [double], returning 0.0 on failure.
double _asDouble(dynamic v) {
  if (v is num) return v.toDouble();
  return double.tryParse(v?.toString() ?? '') ?? 0.0;
}
