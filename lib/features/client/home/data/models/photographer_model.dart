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
  });

  factory PhotographerModel.fromJson(Map<String, dynamic> json) {
    // Parse nested user object
    final user = json['user'] as Map<String, dynamic>?;
    final advertisement = json['advertisement'] as Map<String, dynamic>?;

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
    final ratingValue = json['rate'];
    double rating = 0.0;
    if (ratingValue is num) {
      rating = ratingValue.toDouble();
    } else if (ratingValue is String) {
      rating = double.tryParse(ratingValue) ?? 0.0;
    }

    // Get price from advertisement or root json
    int price = 0;
    final priceValue = advertisement?['price'] ?? json['price'];
    if (priceValue is num) {
      price = priceValue.toInt();
    } else if (priceValue is String) {
      price = double.tryParse(priceValue)?.toInt() ?? 0;
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

    return PhotographerModel(
      id: entityId,
      name: name,
      category: category,
      rating: rating,
      reviewsCount: 0,
      location: location,
      price: price,
      imageUrl: imageUrl,
      daysAvailability: daysAvailability,
      freelancerId: userId,
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
