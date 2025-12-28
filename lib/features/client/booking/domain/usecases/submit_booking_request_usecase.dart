import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../../contract/domain/entities/contract_entity.dart';
import '../repositories/booking_repository.dart';

/// Use case for submitting a booking request
class SubmitBookingRequestUseCase {
  final BookingRepository repository;

  SubmitBookingRequestUseCase(this.repository);

  /// Execute the booking request
  ///
  /// Parameters:
  /// - [advertisementId]: The Gig ID
  /// - [photographerId]: The target photographer's ID (API: publisher_id)
  /// - [price]: The service price
  /// - [date]: Booking date (optional)
  /// - [time]: Booking time (optional)
  /// - [notes]: Additional notes (optional)
  Future<Either<Failure, ContractEntity>> call({
    required String advertisementId,
    required String photographerId,
    required double price,
    String? date,
    String? time,
    String? notes,
  }) async {
    return await repository.submitBookingRequest(
      advertisementId: advertisementId,
      photographerId: photographerId,
      price: price,
      date: date,
      time: time,
      notes: notes,
    );
  }
}
