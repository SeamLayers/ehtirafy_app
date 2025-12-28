import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import '../../domain/entities/gig_entity.dart';
import '../../domain/repositories/freelancer_gigs_repository.dart';
import '../datasources/freelancer_gigs_remote_data_source.dart';

class FreelancerGigsRepositoryImpl implements FreelancerGigsRepository {
  final FreelancerGigsRemoteDataSource remoteDataSource;

  FreelancerGigsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<GigEntity>>> getGigs() async {
    try {
      final gigs = await remoteDataSource.getGigs();
      return Right(gigs);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('فشل في جلب الخدمات'));
    }
  }

  @override
  Future<Either<Failure, GigEntity>> addGig({
    required String title,
    required String description,
    required double price,
    required String category,
    String? coverImage,
    List<String> availability = const [],
    List<String> images = const [],
  }) async {
    try {
      final data = {
        'ar_title': title,
        'en_title': title,
        'ar_description': description,
        'en_description': description,
        'category_id': category,
        'price': price,
      };

      // Pass image paths directly to RemoteDataSource to handle conversion
      if (images.isNotEmpty) {
        data['images'] = images;
      }

      if (availability.isNotEmpty) {
        data['days_availability'] = availability;
      }

      final gig = await remoteDataSource.addGig(data);
      return Right(gig);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('فشل في إضافة الخدمة'));
    }
  }

  @override
  Future<Either<Failure, GigEntity>> updateGig({
    required String id,
    required String title,
    required String description,
    required double price,
    required String category,
    String? coverImage,
    List<String> availability = const [],
    List<String> images = const [],
  }) async {
    try {
      final data = {
        'ar_title': title,
        'en_title': title,
        'ar_description': description,
        'en_description': description,
        'category_id': category,
        'price': price,
      };

      if (images.isNotEmpty) {
        data['images'] = images;
      }

      if (availability.isNotEmpty) {
        data['days_availability'] = availability;
      }

      final updatedGig = await remoteDataSource.updateGig(id, data);
      return Right(updatedGig);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('فشل في تحديث الخدمة'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGig(String gigId) async {
    try {
      await remoteDataSource.deleteGig(gigId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('فشل في حذف الخدمة'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('فشل في جلب التصنيفات'));
    }
  }
}
