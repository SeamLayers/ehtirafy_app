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
  });

  factory PhotographerModel.fromJson(Map<String, dynamic> json) {
    // Parse nested user object
    final user = json['user'] as Map<String, dynamic>?;
    final advertisement = json['advertisement'] as Map<String, dynamic>?;

    // Get user ID - prefer user_id, then nested user.id
    final userId =
        json['user_id']?.toString() ??
        user?['id']?.toString() ??
        json['id']?.toString() ??
        '';

    // Get name from nested user object
    final name = user?['name']?.toString() ?? json['name']?.toString() ?? '';

    // Parse localized title from advertisement
    String category = '';
    if (advertisement != null) {
      final title = advertisement['title'];
      if (title is Map) {
        // Prefer Arabic, fallback to English
        category = title['ar']?.toString() ?? title['en']?.toString() ?? '';
      } else if (title != null) {
        category = title.toString();
      }
    }

    // Get rating from rate field
    final ratingValue = json['rate'];
    double rating = 0.0;
    if (ratingValue is num) {
      rating = ratingValue.toDouble();
    } else if (ratingValue is String) {
      rating = double.tryParse(ratingValue) ?? 0.0;
    }

    // Get price from advertisement
    int price = 0;
    if (advertisement != null) {
      final priceValue = advertisement['price'];
      if (priceValue is num) {
        price = priceValue.toInt();
      } else if (priceValue is String) {
        price = double.tryParse(priceValue)?.toInt() ?? 0;
      }
    }

    // Location is not in the API, use empty or country_code from user
    final location = user?['country_code']?.toString() ?? '';

    // Image URL - check for avatar in user object
    // Note: Current API doesn't return avatars, using placeholder
    final imageUrl =
        user?['avatar']?.toString() ??
        json['avatar']?.toString() ??
        json['imageUrl']?.toString() ??
        '';

    return PhotographerModel(
      id: userId,
      name: name,
      category: category,
      rating: rating,
      reviewsCount: 0, // Not provided in this API
      location: location,
      price: price,
      imageUrl: imageUrl,
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
