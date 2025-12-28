import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_entity.dart';

/// Repository for booking/contract creation operations
abstract class BookingRepository {
  /// Submit a booking request (create initial contract)
  ///
  /// Parameters:
  /// - [advertisementId]: The Gig ID
  /// - [photographerId]: The target photographer's ID (API: publisher_id)
  /// - [price]: The service price
  /// - [date]: Booking date (optional, for future use)
  /// - [time]: Booking time (optional, for future use)
  /// - [notes]: Additional notes (optional)
  Future<Either<Failure, ContractEntity>> submitBookingRequest({
    required String advertisementId,
    required String photographerId,
    required double price,
    String? date,
    String? time,
    String? notes,
  });
}
