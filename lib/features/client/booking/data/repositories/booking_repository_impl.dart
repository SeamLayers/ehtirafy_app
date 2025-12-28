import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/features/client/booking/domain/repositories/booking_repository.dart';
import 'package:ehtirafy_app/features/client/contract/data/datasources/contract_remote_data_source.dart';
import 'package:ehtirafy_app/features/client/contract/data/models/contract_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of BookingRepository
///
/// Handles booking requests by creating initial contracts via the API.
/// Uses ContractRemoteDataSource for the actual API calls.
class BookingRepositoryImpl implements BookingRepository {
  final ContractRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, ContractModel>> submitBookingRequest({
    required String advertisementId,
    required String photographerId,
    required double price,
    String? date,
    String? time,
    String? notes,
  }) async {
    try {
      // Get current user ID from cached_user JSON object
      String clientId = '';
      final userJson = sharedPreferences.getString('cached_user');
      if (userJson != null) {
        try {
          final userData = json.decode(userJson);
          clientId = userData['id']?.toString() ?? '';
        } catch (e) {
          // JSON parsing failed
        }
      }

      if (clientId.isEmpty) {
        return const Left(ServerFailure('User not authenticated'));
      }

      // Create request body using ContractModel helper
      // API mapping: photographer → freelancer (uses publisher_id field), client → customer
      final body = ContractModel.createRequestBody(
        advertisementId: advertisementId,
        photographerId: photographerId, // Will be sent as publisher_id
        clientId: clientId, // Will be sent as customer_id
        amount: price.toString(),
      );

      // Create the initial contract
      final contract = await remoteDataSource.createInitialContract(body);

      return Right(contract);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
