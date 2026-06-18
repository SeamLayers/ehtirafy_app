import '../../domain/entities/city_entity.dart';

class CityModel extends CityEntity {
  const CityModel({required super.nameAr, required super.nameEn});

  /// Parses a city item from GET /cities. Each item is `{ "name": { "en", "ar" } }`.
  /// Tolerant to a plain-string name or a flat `{en,ar}`/`{name_en,name_ar}` shape.
  factory CityModel.fromJson(Map<String, dynamic> json) {
    final nameData = json['name'];
    String nameAr = '';
    String nameEn = '';

    if (nameData is Map) {
      nameAr = nameData['ar']?.toString() ?? '';
      nameEn = nameData['en']?.toString() ?? '';
    } else if (nameData is String) {
      nameAr = nameData;
      nameEn = nameData;
    } else {
      // Fallbacks if the city object is flat.
      nameAr = json['ar']?.toString() ?? json['name_ar']?.toString() ?? '';
      nameEn = json['en']?.toString() ?? json['name_en']?.toString() ?? '';
    }

    // If only one localization came back, mirror it so neither side is blank.
    if (nameAr.isEmpty) nameAr = nameEn;
    if (nameEn.isEmpty) nameEn = nameAr;

    return CityModel(nameAr: nameAr, nameEn: nameEn);
  }
}
