import '../../domain/entities/portfolio_item_entity.dart';

class PortfolioItemModel extends PortfolioItemEntity {
  const PortfolioItemModel({
    required super.id,
    required super.title,
    required super.description,
    super.image,
    required super.createdAt,
  });

  factory PortfolioItemModel.fromJson(Map<String, dynamic> json) {
    // Parse title and description which might be objects {ar:..., en:...} or strings
    String parseLocalized(dynamic val) {
      if (val is Map) {
        return val['en']?.toString() ?? val['ar']?.toString() ?? '';
      }
      return val?.toString() ?? '';
    }

    return PortfolioItemModel(
      id: json['id']?.toString() ?? '',
      title: parseLocalized(json['title']),
      description: parseLocalized(json['description']),
      image: json['images'] != null && (json['images'] as List).isNotEmpty
          ? json['images'][0]?.toString()
          : (json['image']?.toString()), // Fallback
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
