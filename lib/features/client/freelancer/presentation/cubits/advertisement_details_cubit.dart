import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/usecases/get_advertisement_details_usecase.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/advertisement_details_state.dart';

class AdvertisementDetailsCubit extends Cubit<AdvertisementDetailsState> {
  final GetAdvertisementDetailsUseCase getAdvertisementDetailsUseCase;

  AdvertisementDetailsCubit({required this.getAdvertisementDetailsUseCase})
    : super(AdvertisementDetailsInitial());

  Future<void> loadAdvertisementDetails(String id) async {
    emit(AdvertisementDetailsLoading());

    final result = await getAdvertisementDetailsUseCase(id);

    result.fold(
      (failure) => emit(AdvertisementDetailsError(failure.message)),
      (details) => emit(AdvertisementDetailsLoaded(details)),
    );
  }
}
