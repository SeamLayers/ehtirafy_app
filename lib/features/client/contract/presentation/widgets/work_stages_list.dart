import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/backend_contract_status_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// State of a single node in the vertical work-stages stepper.
enum _StageState { done, active, future }

/// An elegant vertical stepper of the photography work stages:
/// Confirm Booking -> Event Shooting -> Delivering Photos.
///
/// Progress is derived from the canonical backend contract status so the visual
/// always reflects the real lifecycle. Done nodes use a gold check, the active
/// node is a filled gold ring, and future nodes are grey outlines. Completed
/// connector segments use a gold gradient; upcoming ones stay grey.
class WorkStagesList extends StatelessWidget {
  final ContractDetailsEntity contract;

  const WorkStagesList({super.key, required this.contract});

  /// Index of the currently active stage (0-based). Anything before it is done,
  /// anything after it is in the future. A fully closed contract returns a value
  /// past the last stage so every node renders as done.
  int get _progressIndex {
    final canonical =
        canonicalBackendContractStatus(contract.contractStatus);
    switch (canonical) {
      case 'Approved':
        return 1; // booking confirmed, shooting up next
      case 'InProgress':
        return 2; // shooting done, delivering photos
      case 'Closed':
        return 3; // everything complete
      case 'Initiate':
      default:
        return 0; // awaiting booking confirmation
    }
  }

  @override
  Widget build(BuildContext context) {
    if (contract.notes.isEmpty) {
      return const SizedBox.shrink();
    }

    final int progress = _progressIndex;
    final stages = <String>[
      AppStrings.contractStageConfirmBooking.tr(),
      AppStrings.contractStageShooting.tr(),
      AppStrings.contractStageDeliveringPhotos.tr(),
    ];

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
            spreadRadius: -2.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Header: rounded gold icon badge + label ----
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.timeline_rounded,
                  color: AppColors.gold,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: AppSpacing.sm + 2.w),
              Expanded(
                child: Text(
                  AppStrings.contractWorkStagesLabel.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: 'Cairo',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),

          // ---- Vertical stepper ----
          for (int i = 0; i < stages.length; i++)
            _buildStage(
              label: stages[i],
              state: i < progress
                  ? _StageState.done
                  : (i == progress ? _StageState.active : _StageState.future),
              isLast: i == stages.length - 1,
              // The connector below a node is "complete" (gold) when the next
              // stage has already been reached.
              connectorComplete: (i + 1) <= progress,
            ),
        ],
      ),
    );
  }

  Widget _buildStage({
    required String label,
    required _StageState state,
    required bool isLast,
    required bool connectorComplete,
  }) {
    final bool isDone = state == _StageState.done;
    final bool isActive = state == _StageState.active;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---- Node + connector column ----
          SizedBox(
            width: 28.w,
            child: Column(
              children: [
                _buildNode(state),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 3.w,
                      margin: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.r),
                        gradient: connectorComplete
                            ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.gold,
                                  AppColors.gold.withValues(alpha: 0.55),
                                ],
                              )
                            : null,
                        color: connectorComplete ? null : AppColors.grey200,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm + 4.w),

          // ---- Label / state text ----
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 2.h,
                bottom: isLast ? 0 : AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: (isDone || isActive)
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontFamily: 'Cairo',
                      fontSize: 14.sp,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _stateLabel(state, isArabic: _isArabicLabel(label)),
                    style: TextStyle(
                      color: isActive
                          ? AppColors.gold
                          : (isDone
                              ? AppColors.success
                              : AppColors.grey400),
                      fontFamily: 'Cairo',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The circular node for a stage. Done = gold filled with white check,
  /// active = larger gold filled ring with pulse-style glow, future = grey
  /// outline.
  Widget _buildNode(_StageState state) {
    switch (state) {
      case _StageState.done:
        return Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: AppColors.gold,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.30),
                blurRadius: 6.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 15.r,
          ),
        );
      case _StageState.active:
        return Container(
          width: 26.w,
          height: 26.w,
          decoration: BoxDecoration(
            color: AppColors.gold,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.25),
              width: 4.w,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.40),
                blurRadius: 10.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      case _StageState.future:
        return Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.grey200, width: 2.w),
          ),
        );
    }
  }

  /// Bilingual short status word under each stage label.
  String _stateLabel(_StageState state, {required bool isArabic}) {
    switch (state) {
      case _StageState.done:
        return isArabic ? 'مكتمل' : 'Completed';
      case _StageState.active:
        return isArabic ? 'قيد التنفيذ' : 'In progress';
      case _StageState.future:
        return isArabic ? 'قريباً' : 'Upcoming';
    }
  }

  /// The localized stage labels are already resolved via .tr(); detect Arabic
  /// from the resolved content so the small state caption matches the locale.
  bool _isArabicLabel(String label) {
    return label.runes.any((r) => r >= 0x0600 && r <= 0x06FF);
  }
}
