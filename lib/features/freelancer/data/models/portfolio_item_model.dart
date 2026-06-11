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

    final imgs = json['images'];
    return PortfolioItemModel(
      id: json['id']?.toString() ?? '',
      title: parseLocalized(json['title']),
      description: parseLocalized(json['description']),
      image: (imgs is List && imgs.isNotEmpty)
          ? imgs[0]?.toString()
          : (json['image']?.toString()), // Fallback
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
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
