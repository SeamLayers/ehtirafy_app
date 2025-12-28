import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE5E5E5))),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.attach_file, color: Colors.grey),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F5),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: AppStrings.chatInputHint.tr(),
                  hintStyle: TextStyle(
                    color: const Color(0xFF717182),
                    fontSize: 16.sp,
                    fontFamily: 'Cairo',
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFC8A44F),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: Colors.white, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}
