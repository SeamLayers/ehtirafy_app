import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_entity.dart';
import '../../domain/usecases/submit_booking_request_usecase.dart';

part 'booking_state.dart';

/// Cubit for handling booking/contract creation
class BookingCubit extends Cubit<BookingState> {
  final SubmitBookingRequestUseCase submitBookingRequestUseCase;

  BookingCubit(this.submitBookingRequestUseCase) : super(BookingInitial());

  /// Submit a booking request
  ///
  /// Parameters:
  /// - [advertisementId]: The Gig ID
  /// - [photographerId]: The target photographer's ID (API: publisher_id)
  /// - [price]: The service price
  /// - [date]: Booking date (optional)
  /// - [time]: Booking time (optional)
  /// - [notes]: Additional notes (optional)
  Future<void> submitBooking({
    required String advertisementId,
    required String photographerId,
    required double price,
    String? date,
    String? time,
    String? notes,
  }) async {
    emit(BookingLoading());
    final result = await submitBookingRequestUseCase(
      advertisementId: advertisementId,
      photographerId: photographerId,
      price: price,
      date: date,
      time: time,
      notes: notes,
    );

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (contract) => emit(BookingSuccess(contract)),
    );
  }
}
