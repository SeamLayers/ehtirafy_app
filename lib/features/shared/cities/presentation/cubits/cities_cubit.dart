import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import 'cities_state.dart';

class CitiesCubit extends Cubit<CitiesState> {
  final GetCitiesUseCase getCitiesUseCase;

  CitiesCubit({required this.getCitiesUseCase}) : super(CitiesInitial());

  Future<void> loadCities() async {
    if (state is CitiesLoading) return;
    emit(CitiesLoading());
    final result = await getCitiesUseCase();
    result.fold(
      (failure) => emit(CitiesError(failure.message)),
      (cities) => emit(CitiesLoaded(cities)),
    );
  }
}
