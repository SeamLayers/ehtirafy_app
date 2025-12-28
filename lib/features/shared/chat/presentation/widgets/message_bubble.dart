import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFC8A44F) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF2B2B2B),
                fontSize: 16.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: isMe ? const Color(0xB2FFFEFE) : const Color(0xFF888888),
                fontSize: 12.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
