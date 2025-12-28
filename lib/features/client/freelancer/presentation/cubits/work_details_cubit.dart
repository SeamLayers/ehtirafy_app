import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/usecases/get_work_details_usecase.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/work_details_state.dart';

class WorkDetailsCubit extends Cubit<WorkDetailsState> {
  final GetWorkDetailsUseCase getWorkDetailsUseCase;

  WorkDetailsCubit({required this.getWorkDetailsUseCase})
    : super(WorkDetailsInitial());

  Future<void> loadWorkDetails(String id) async {
    emit(WorkDetailsLoading());

    final result = await getWorkDetailsUseCase(id);

    result.fold(
      (failure) => emit(WorkDetailsError(failure.message)),
      (workDetails) => emit(WorkDetailsLoaded(workDetails)),
    );
  }
}
