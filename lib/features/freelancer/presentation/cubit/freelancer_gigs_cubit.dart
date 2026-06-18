import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/freelancer_gigs_repository.dart';
import '../../domain/entities/gig_entity.dart';
import 'freelancer_gigs_state.dart';

class FreelancerGigsCubit extends Cubit<FreelancerGigsState> {
  final FreelancerGigsRepository repository;

  FreelancerGigsCubit({required this.repository})
    : super(FreelancerGigsInitial());

  Future<void> loadGigs() async {
    emit(FreelancerGigsLoading());

    // Fetch gigs and categories in parallel, handling failures independently
    final results = await Future.wait([
      repository.getGigs().then(
        (result) => result.fold((l) => <dynamic>[], (r) => r),
      ),
      repository.getCategories().then(
        (result) => result.fold((l) => <dynamic>[], (r) => r),
      ),
    ]);

    final gigs = results[0];
    final categories = results[1];

    // Always emit Loaded state - the create form needs categories even if gigs fail
    emit(
      FreelancerGigsLoaded(gigs: gigs.cast(), categories: categories.cast()),
    );
  }

  Future<void> loadGigDetails(String id) async {
    emit(FreelancerGigsLoading());

    // We also need categories for the edit form
    final results = await Future.wait([
      repository.getGigById(id).then((r) => r.fold((l) => null, (r) => r)),
      repository.getCategories().then(
        (r) => r.fold((l) => <dynamic>[], (r) => r),
      ),
    ]);

    final gig = results[0] as GigEntity?;
    final categories = results[1] as List<dynamic>;

    if (gig != null) {
      emit(FreelancerGigDetailsLoaded(gig: gig, categories: categories.cast()));
    } else {
      emit(const FreelancerGigsError('فشل في جلب تفاصيل الخدمة'));
    }
  }

  Future<void> addGig({
    required String title,
    required String description,
    required double price,
    required String category,
    required String cityAr,
    required String cityEn,
    String? coverImage,
    List<String> availability = const [],
    List<String> images = const [],
  }) async {
    emit(FreelancerGigAdding());

    final result = await repository.addGig(
      title: title,
      description: description,
      price: price,
      category: category,
      cityAr: cityAr,
      cityEn: cityEn,
      coverImage: coverImage,
      availability: availability,
      images: images,
    );

    result.fold((failure) => emit(FreelancerGigAddError(failure.message)), (
      gig,
    ) {
      emit(FreelancerGigAdded(gig));
      // Reload gigs list to refresh cached data
      loadGigs();
    });
  }

  Future<void> updateGig({
    required String id,
    required String title,
    required String description,
    required double price,
    required String category,
    required String cityAr,
    required String cityEn,
    String? coverImage,
    List<String> availability = const [],
    List<String> images = const [],
  }) async {
    emit(FreelancerGigUpdating());

    final result = await repository.updateGig(
      id: id,
      title: title,
      description: description,
      price: price,
      category: category,
      cityAr: cityAr,
      cityEn: cityEn,
      coverImage: coverImage,
      availability: availability,
      images: images,
    );

    result.fold((failure) => emit(FreelancerGigUpdateError(failure.message)), (
      gig,
    ) {
      emit(FreelancerGigUpdated(gig));
      // Reload gigs list to refresh cached data
      loadGigs();
    });
  }

  Future<void> deleteGig(String gigId) async {
    if (state is FreelancerGigsLoaded) {
      final currentState = state as FreelancerGigsLoaded;

      final result = await repository.deleteGig(gigId);

      result.fold((failure) => emit(FreelancerGigsError(failure.message)), (_) {
        final updatedGigs = currentState.gigs
            .where((gig) => gig.id != gigId)
            .toList();
        emit(currentState.copyWith(gigs: updatedGigs));
      });
    }
  }
}
