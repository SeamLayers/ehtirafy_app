import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/models/service_model.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/models/review_model.dart';

class FreelancerModel extends FreelancerEntity {
  const FreelancerModel({
    required super.id,
    required super.name,
    required super.title,
    required super.location,
    required super.bio,
    required super.rating,
    required super.reviewsCount,
    required super.projectsCount,
    required super.responseTime,
    required super.memberSince,
    required super.imageUrl,
    required List<PortfolioItemModel> super.portfolio,
    List<ServiceModel> super.services = const [],
    List<ReviewModel> super.reviews = const [],
  });

  factory FreelancerModel.fromJson(Map<String, dynamic> json) {
    var rawPortfolio = json['our_works'] ?? json['portfolio'];
    var rawServices = json['advertisements'] ?? json['services'];
    var rawReviews = json['reviews'];

    // Parse member since from created_at
    String memberSince = '';
    final createdAt = json['created_at'] ?? json['memberSince'];
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt.toString());
        memberSince = '${date.year}';
      } catch (e) {
        memberSince = createdAt.toString();
      }
    }

    // Build location from country_code
    String location = '';
    if (json['country_code'] != null) {
      location = '+${json['country_code']}';
    }
    if (json['location'] != null && json['location'].toString().isNotEmpty) {
      location = json['location'].toString();
    }

    // Title from user_type or job_title
    String title = json['title'] ?? json['job_title'] ?? '';
    if (title.isEmpty && json['user_type'] != null) {
      final userType = json['user_type'].toString();
      if (userType == 'user' || userType == 'freelancer') {
        title = 'مصور محترف'; // Professional Photographer
      } else {
        title = userType;
      }
    }

    return FreelancerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      title: title,
      location: location,
      bio: json['bio']?.toString() ?? json['about']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount:
          json['reviews_count'] as int? ?? json['reviewsCount'] as int? ?? 0,
      projectsCount:
          json['projects_count'] as int? ?? json['projectsCount'] as int? ?? 0,
      responseTime:
          json['response_time']?.toString() ??
          json['responseTime']?.toString() ??
          'سريع',
      memberSince: memberSince,
      imageUrl:
          json['avatar']?.toString() ?? json['imageUrl']?.toString() ?? '',
      portfolio: rawPortfolio != null && rawPortfolio is List
          ? rawPortfolio.map((e) => PortfolioItemModel.fromJson(e)).toList()
          : [],
      services: rawServices != null && rawServices is List
          ? rawServices.map((e) => ServiceModel.fromJson(e)).toList()
          : [],
      reviews: rawReviews != null && rawReviews is List
          ? rawReviews.map((e) => ReviewModel.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'location': location,
      'bio': bio,
      'rating': rating,
      'reviews_count': reviewsCount,
      'projects_count': projectsCount,
      'response_time': responseTime,
      'created_at': memberSince,
      'avatar': imageUrl,
      'our_works': portfolio
          .map((e) => (e as PortfolioItemModel).toJson())
          .toList(),
      'advertisements': services
          .map((e) => (e as ServiceModel).toJson())
          .toList(),
      'reviews': reviews.map((e) => (e as ReviewModel).toJson()).toList(),
    };
  }
}

class PortfolioItemModel extends PortfolioItemEntity {
  const PortfolioItemModel({
    required super.id,
    required super.title,
    required super.category,
    required super.imageUrl,
  });

  factory PortfolioItemModel.fromJson(Map<String, dynamic> json) {
    // Handle images array
    String imageUrl = '';
    final images = json['images'];
    if (images != null && images is List && images.isNotEmpty) {
      // Get first image from images array
      final firstImage = images.first;
      if (firstImage is Map) {
        imageUrl =
            firstImage['url']?.toString() ??
            firstImage['image']?.toString() ??
            '';
      } else if (firstImage is String) {
        imageUrl = firstImage;
      }
    } else {
      imageUrl =
          json['image']?.toString() ?? json['imageUrl']?.toString() ?? '';
    }

    // Handle localized title
    String title = '';
    final titleData = json['title'];
    if (titleData is Map) {
      title = titleData['ar']?.toString() ?? titleData['en']?.toString() ?? '';
    } else if (titleData != null) {
      title = titleData.toString();
    }

    return PortfolioItemModel(
      id: json['id']?.toString() ?? '',
      title: title,
      category: json['category']?.toString() ?? '',
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'category': category, 'image': imageUrl};
  }
}
