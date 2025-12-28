import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/work_details_entity.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/advertisement_details_entity.dart';

abstract class FreelancerRepository {
  Future<Either<Failure, FreelancerEntity>> getFreelancerProfile(String id);
  Future<Either<Failure, WorkDetailsEntity>> getWorkDetails(String id);
  Future<Either<Failure, AdvertisementDetailsEntity>> getAdvertisementDetails(
    String id,
  );
}
