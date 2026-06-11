import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/financial_pledge_section.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/rtl_back_button.dart';
import '../../../../../core/widgets/user_avatar.dart';
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
  final List<String> availableDays;

  const RequestBookingScreen({
    super.key,
    required this.advertisementId,
    required this.photographerId,
    required this.photographerName,
    required this.serviceName,
    required this.price,
    this.availableDays = const [],
  });

  @override
  State<RequestBookingScreen> createState() => _RequestBookingScreenState();
}

class _RequestBookingScreenState extends State<RequestBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();
  bool _hasAcceptedPledge = false;

  Widget _buildSummaryCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.textLight,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Row(
        children: [
          UserAvatar(name: widget.photographerName, size: 54),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.serviceName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 15.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        widget.photographerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.sm + 2.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sell_rounded,
                        size: 15.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        widget.price.toStringAsFixed(0),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.primary),
        SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    OutlineInputBorder border(Color color, {double width = 1.2}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14.sp,
        fontFamily: 'Cairo',
      ),
      filled: true,
      fillColor: AppColors.textLight,
      suffixIcon: suffixIcon,
      suffixIconColor: AppColors.primary,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14.h,
      ),
      enabledBorder: border(AppColors.grey200),
      border: border(AppColors.grey200),
      focusedBorder: border(AppColors.gold, width: 1.6),
      errorBorder: border(AppColors.error),
      focusedErrorBorder: border(AppColors.error, width: 1.6),
    );
  }

  bool _isDayAvailable(DateTime day) {
    if (widget.availableDays.isEmpty) return true;

    // Map weekday number to day name
    // DateTime.monday = 1, ... DateTime.sunday = 7
    final dayName = _getDayName(day.weekday);
    return widget.availableDays.any(
      (availableDay) => availableDay.toLowerCase() == dayName.toLowerCase(),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
        return 'sunday';
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      default:
        return '';
    }
  }

  DateTime _getInitialDate() {
    final now = DateTime.now();
    if (widget.availableDays.isEmpty) return now;

    for (int i = 0; i < 365; i++) {
      final day = now.add(Duration(days: i));
      if (_isDayAvailable(day)) {
        return day;
      }
    }
    return now;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => sl<BookingCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: RtlBackButton(onPressed: () => context.pop()),
          title: Text(
            AppStrings.bookingRequestTitle.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(
              height: 1.h,
              color: AppColors.grey200,
            ),
          ),
        ),
        body: BlocConsumer<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingSuccess) {
              context.go('/my-requests');
            } else if (state is BookingError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final bool isLoading = state is BookingLoading;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(theme),
                    SizedBox(height: AppSpacing.lg),
                    _buildSectionLabel(
                      theme,
                      Icons.event_note_rounded,
                      AppStrings.bookingDateLabel.tr(),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _dateController,
                      decoration: _fieldDecoration(
                        hint: AppStrings.bookingDateLabel.tr(),
                        suffixIcon: const Icon(Icons.calendar_today_rounded),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final initialDate = _getInitialDate();
                        final date = await showDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          selectableDayPredicate: _isDayAvailable,
                        );
                        if (!context.mounted) return;
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
                    SizedBox(height: AppSpacing.md),
                    _buildSectionLabel(
                      theme,
                      Icons.schedule_rounded,
                      AppStrings.bookingTimeLabel.tr(),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _timeController,
                      decoration: _fieldDecoration(
                        hint: AppStrings.bookingTimeLabel.tr(),
                        suffixIcon: const Icon(Icons.access_time_rounded),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (!context.mounted) return;
                        if (time != null) {
                          _timeController.text = time.format(context);
                        }
                      },
                      validator: (value) => value!.isEmpty
                          ? AppStrings.validationRequired.tr()
                          : null,
                    ),
                    SizedBox(height: AppSpacing.md),
                    _buildSectionLabel(
                      theme,
                      Icons.notes_rounded,
                      AppStrings.bookingNotesLabel.tr(),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: _fieldDecoration(
                        hint: AppStrings.bookingNotesLabel.tr(),
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),
                    FinancialPledgeSection(
                      role: FinancialPledgeRole.client,
                      accepted: _hasAcceptedPledge,
                      agreementAr:
                          'أقر وأوافق على هذا التعهد المالي قبل إنشاء العقد.',
                      agreementEn:
                          'I confirm and agree to this financial pledge before creating the contract.',
                      onAcceptedChanged: (value) {
                        setState(() => _hasAcceptedPledge = value);
                      },
                    ),
                    SizedBox(height: AppSpacing.lg),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: !isLoading && !_hasAcceptedPledge ? 0.55 : 1,
                      child: IgnorePointer(
                        ignoring: isLoading || !_hasAcceptedPledge,
                        child: PrimaryButton(
                          text: AppStrings.bookingSubmitButton.tr(),
                          isLoading: isLoading,
                          onPressed: () {
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
