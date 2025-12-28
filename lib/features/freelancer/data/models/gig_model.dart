import '../../domain/entities/gig_entity.dart';

class GigModel extends GigEntity {
  const GigModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.category,
    super.categoryName,
    required super.status,
    required super.coverImage,
    super.createdAt,
    super.availability,
    super.images,
  });

  factory GigModel.fromJson(Map<String, dynamic> json) {
    // API might return 'title' directly or 'ar_title', 'en_title'
    // Handle both formats for compatibility
    String parseTitle() {
      if (json['title'] != null) return json['title'].toString();
      return json['en_title']?.toString() ?? json['ar_title']?.toString() ?? '';
    }

    String parseDescription() {
      if (json['description'] != null) return json['description'].toString();
      return json['en_description']?.toString() ??
          json['ar_description']?.toString() ??
          '';
    }

    // Extract cover image from images array
    String parseCoverImage() {
      if (json['images'] != null &&
          json['images'] is List &&
          (json['images'] as List).isNotEmpty) {
        return json['images'][0].toString();
      }
      return '';
    }

    // Parse category object: {"id": 3, "name": {"en": "sessions", "ar": "سشنات"}}
    String parseCategoryName() {
      final category = json['category'];
      if (category is Map && category['name'] != null) {
        final name = category['name'];
        if (name is Map) {
          // Prefer Arabic name, fallback to English
          return name['ar']?.toString() ?? name['en']?.toString() ?? '';
        }
        return name.toString();
      }
      return '';
    }

    // Handle days_availability which can be List OR Map (object)
    // API returns: [saturday] or {0: saturday, 2: sunday}
    List<String> parseAvailability() {
      final daysAvail = json['days_availability'];
      if (daysAvail == null) return [];

      if (daysAvail is List) {
        return daysAvail.map((e) => e.toString()).toList();
      } else if (daysAvail is Map) {
        // Convert map values to list: {0: "saturday", 2: "sunday"} -> ["saturday", "sunday"]
        return daysAvail.values.map((e) => e.toString()).toList();
      }
      return [];
    }

    // Parse images which should be a list
    List<String> parseImages() {
      final images = json['images'];
      if (images == null) return [];

      if (images is List) {
        return images.map((e) => e.toString()).toList();
      }
      return [];
    }

    return GigModel(
      id: json['id']?.toString() ?? '',
      title: parseTitle(),
      description: parseDescription(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      category: json['category_id']?.toString() ?? '',
      categoryName: parseCategoryName(),
      status: _parseStatus(json['status']?.toString() ?? ''),
      coverImage: parseCoverImage(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : DateTime.now(),
      availability: parseAvailability(),
      images: parseImages(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'categoryName': categoryName,
      'status': _statusToString(status),
      'coverImage': coverImage,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  static GigStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'published': // API uses 'published' for active gigs
        return GigStatus.active;
      case 'pending':
      case 'draft':
        return GigStatus.pending;
      case 'inactive':
      case 'unpublished':
        return GigStatus.inactive;
      default:
        return GigStatus.pending;
    }
  }

  static String _statusToString(GigStatus status) {
    switch (status) {
      case GigStatus.active:
        return 'active';
      case GigStatus.pending:
        return 'pending';
      case GigStatus.inactive:
        return 'inactive';
    }
  }
}
