import '../../domain/entities/work_details_entity.dart';

class WorkDetailsModel extends WorkDetailsEntity {
  const WorkDetailsModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    super.images,
  });

  factory WorkDetailsModel.fromJson(Map<String, dynamic> json) {
    // Handle localized title
    String title = '';
    final titleData = json['title'];
    if (titleData is Map) {
      title = titleData['ar']?.toString() ?? titleData['en']?.toString() ?? '';
    } else if (titleData != null) {
      title = titleData.toString();
    }

    // Handle localized description
    String description = '';
    final descData = json['description'];
    if (descData is Map) {
      description =
          descData['ar']?.toString() ?? descData['en']?.toString() ?? '';
    } else if (descData != null) {
      description = descData.toString();
    }

    // Handle images array
    List<String> images = [];
    final imagesData = json['images'];
    if (imagesData != null && imagesData is List) {
      images = imagesData
          .map((e) {
            if (e is Map) {
              return e['url']?.toString() ?? e['image']?.toString() ?? '';
            }
            return e.toString();
          })
          .where((s) => s.isNotEmpty)
          .toList();
    }

    // Format created date
    String formattedDate = '';
    final createdAt = json['created_at'];
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt.toString());
        formattedDate =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } catch (e) {
        formattedDate = createdAt.toString();
      }
    }

    String updatedDate = '';
    final updatedAt = json['updated_at'];
    if (updatedAt != null) {
      try {
        final date = DateTime.parse(updatedAt.toString());
        updatedDate =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } catch (e) {
        updatedDate = updatedAt.toString();
      }
    }

    return WorkDetailsModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      title: title,
      description: description,
      createdAt: formattedDate,
      updatedAt: updatedDate,
      images: images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'images': images,
    };
  }
}
