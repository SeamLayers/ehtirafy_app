import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    super.isActive,
    super.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // Parse name which is an object with 'ar' and 'en' keys
    final nameData = json['name'];
    String nameAr = '';
    String nameEn = '';

    if (nameData is Map<String, dynamic>) {
      nameAr = nameData['ar']?.toString() ?? '';
      nameEn = nameData['en']?.toString() ?? '';
    } else if (nameData is String) {
      // Fallback if name is a simple string
      nameAr = nameData;
      nameEn = nameData;
    }

    return CategoryModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      nameAr: nameAr,
      nameEn: nameEn,
      isActive:
          json['is_active'] == '1' ||
          json['is_active'] == 1 ||
          json['is_active'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': {'ar': nameAr, 'en': nameEn},
      'is_active': isActive ? '1' : '0',
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
