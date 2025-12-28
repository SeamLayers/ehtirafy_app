import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_all_freelancers_usecase.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/all_freelancers_state.dart';

class AllFreelancersCubit extends Cubit<AllFreelancersState> {
  final GetAllFreelancersUseCase getAllFreelancersUseCase;

  AllFreelancersCubit({required this.getAllFreelancersUseCase})
    : super(AllFreelancersInitial());

  Future<void> loadAllFreelancers() async {
    emit(AllFreelancersLoading());

    final result = await getAllFreelancersUseCase();

    result.fold(
      (failure) => emit(AllFreelancersError(failure.message)),
      (freelancers) => emit(AllFreelancersLoaded(freelancers)),
    );
  }
}
