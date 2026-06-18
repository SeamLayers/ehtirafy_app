import 'package:ehtirafy_app/features/client/search/domain/entities/search_result_entity.dart';

class SearchResultModel extends SearchResultEntity {
  const SearchResultModel({
    required super.id,
    required super.title,
    required super.type,
    super.imageUrl,
    super.rating,
    super.category,
    super.reviewsCount,
    super.freelancerId,
    super.price,
  });

  /// Create from API response. [type] is one of 'freelancer', 'service',
  /// 'work' and is carried through onto the entity so the UI can route to the
  /// correct destination per item.
  factory SearchResultModel.fromJson(
    Map<String, dynamic> json, {
    required String type,
  }) {
    final userRaw = json['user'];
    final user = userRaw is Map ? Map<String, dynamic>.from(userRaw) : null;
    final advertisementRaw = json['advertisement'];
    final advertisement = advertisementRaw is Map
        ? Map<String, dynamic>.from(advertisementRaw)
        : null;

    // Routing freelancer id: prefer user_id, then nested user.id, then
    // freelancer_id. Used to navigate services to their owning freelancer.
    final freelancerId =
        json['user_id']?.toString() ??
        user?['id']?.toString() ??
        json['freelancer_id']?.toString();

    // Primary id depends on the result type.
    String id;
    switch (type) {
      case 'freelancer':
        id =
            json['user_id']?.toString() ??
            user?['id']?.toString() ??
            json['id']?.toString() ??
            '';
        break;
      case 'service':
        id =
            json['id']?.toString() ??
            json['advertisement_id']?.toString() ??
            advertisement?['id']?.toString() ??
            '';
        break;
      case 'work':
      default:
        id = json['id']?.toString() ?? '';
        break;
    }

    // Title: localized {ar,en} map, or plain string, across several keys.
    final title = _localizedString(
          json['name'] ?? json['title'] ?? advertisement?['title'],
        ) ??
        json['ar_title']?.toString() ??
        json['en_title']?.toString() ??
        user?['name']?.toString() ??
        '';

    // Image URL: defensive fallback chain.
    String imageUrl =
        json['cover_image']?.toString() ??
        json['image']?.toString() ??
        json['avatar']?.toString() ??
        _firstImage(json['images']) ??
        advertisement?['cover_image']?.toString() ??
        advertisement?['image']?.toString() ??
        _firstImage(advertisement?['images']) ??
        user?['avatar']?.toString() ??
        '';

    final double rating = _asDouble(json['rate'] ?? json['rating']);

    // Category: localized title map (advertisement or root) or plain category.
    final category =
        _localizedString(advertisement?['title'] ?? json['title']) ??
        json['category']?.toString();

    final int price = _asInt(json['price'] ?? advertisement?['price']);

    final int reviewsCount = _asInt(
      json['reviews_count'] ?? json['reviewsCount'],
    );

    return SearchResultModel(
      id: id,
      title: title,
      type: type,
      imageUrl: imageUrl.isEmpty ? null : imageUrl,
      rating: rating == 0.0 ? null : rating,
      category: (category != null && category.isNotEmpty) ? category : null,
      reviewsCount: reviewsCount,
      freelancerId: freelancerId,
      price: price == 0 ? null : price,
    );
  }

  /// Create from local history entry
  factory SearchResultModel.fromHistory(String query) {
    return SearchResultModel(id: query, title: query, type: 'history');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'imageUrl': imageUrl,
      'rating': rating,
      'category': category,
      'reviewsCount': reviewsCount,
      'freelancerId': freelancerId,
      'price': price,
    };
  }
}

/// Reads a localized {ar,en} map (preferring Arabic) or returns the plain
/// string form. Returns null when [v] is null.
String? _localizedString(dynamic v) {
  if (v == null) return null;
  if (v is Map) {
    return v['ar']?.toString() ?? v['en']?.toString();
  }
  return v.toString();
}

/// Returns the first usable image URL from a list of either String or Map
/// (with url/image keys) entries. Returns null when none is available.
String? _firstImage(dynamic v) {
  if (v is List && v.isNotEmpty) {
    for (final e in v) {
      if (e is Map) {
        final s = e['url']?.toString() ?? e['image']?.toString();
        if (s != null && s.isNotEmpty) return s;
      } else {
        final s = e.toString();
        if (s.isNotEmpty) return s;
      }
    }
  }
  return null;
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
