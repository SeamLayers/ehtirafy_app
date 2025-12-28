import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../cubit/booking_cubit.dart';

/// Screen for creating a booking request (initial contract)
///
/// Required parameters:
/// - [advertisementId]: The Gig ID being booked
/// - [photographerId]: The photographer (publisher) ID receiving the request
/// - [photographerName]: Display name of the photographer
/// - [serviceName]: Name of the service/gig being booked
/// - [price]: Service price (requested_amount and actual_amount)
class RequestBookingScreen extends StatefulWidget {
  final String advertisementId;
  final String photographerId;
  final String photographerName;
  final String serviceName;
  final double price;

  const RequestBookingScreen({
    super.key,
    required this.advertisementId,
    required this.photographerId,
    required this.photographerName,
    required this.serviceName,
    required this.price,
  });

  @override
  State<RequestBookingScreen> createState() => _RequestBookingScreenState();
}

class _RequestBookingScreenState extends State<RequestBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BookingCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: Text(
            AppStrings.bookingRequestTitle.tr(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              context.go('/booking/success');
            } else if (state is BookingError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppStrings.bookingServiceLabel.tr()}: ${widget.serviceName}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${AppStrings.bookingPhotographerLabel.tr()}: ${widget.photographerName}',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 24.h),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: AppStrings.bookingDateLabel.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) {
                          _dateController.text = DateFormat(
                            'yyyy-MM-dd',
                          ).format(date);
                        }
                      },
                      validator: (value) => value!.isEmpty
                          ? AppStrings.validationRequired.tr()
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        labelText: AppStrings.bookingTimeLabel.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        suffixIcon: const Icon(Icons.access_time),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          _timeController.text = time.format(context);
                        }
                      },
                      validator: (value) => value!.isEmpty
                          ? AppStrings.validationRequired.tr()
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: AppStrings.bookingNotesLabel.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: state is BookingLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<BookingCubit>().submitBooking(
                                    advertisementId: widget.advertisementId,
                                    photographerId: widget.photographerId,
                                    price: widget.price,
                                    date: _dateController.text,
                                    time: _timeController.text,
                                    notes: _notesController.text,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: state is BookingLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                AppStrings.bookingSubmitButton.tr(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
