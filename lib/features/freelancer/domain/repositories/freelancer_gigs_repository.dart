import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import '../entities/gig_entity.dart';

abstract class FreelancerGigsRepository {
  /// Get all gigs for the freelancer
  Future<Either<Failure, List<GigEntity>>> getGigs();

  /// Add a new gig
  Future<Either<Failure, GigEntity>> addGig({
    required String title,
    required String description,
    required double price,
    required String category,
    String? coverImage,
    List<String> availability = const [],
    List<String> images = const [],
  });

  /// Update an existing gig
  Future<Either<Failure, GigEntity>> updateGig({
    required String id,
    required String title,
    required String description,
    required double price,
    required String category,
    String? coverImage,
    List<String> availability = const [],
    List<String> images = const [],
  });

  /// Delete a gig
  Future<Either<Failure, void>> deleteGig(String gigId);

  /// Get available categories from API
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
