import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/conversation_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';

class ConversationTile extends StatelessWidget {
  final ConversationEntity conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: _AvatarImage(url: conversation.otherUserImage),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        conversation.otherUserName,
                        style: TextStyle(
                          color: const Color(0xFF2B2B2B),
                          fontSize: 16.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (conversation.unreadCount > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC8A44F),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            conversation.unreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    conversation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatTime(conversation.lastMessageTime),
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: 12.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 60) {
      return '${AppStrings.chatAgo.tr()} ${difference.inMinutes} ${AppStrings.chatMinute.tr()}';
    } else if (difference.inHours < 24) {
      return '${AppStrings.chatAgo.tr()} ${difference.inHours} ${AppStrings.chatHour.tr()}';
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }
}

class _AvatarImage extends StatelessWidget {
  final String url;
  const _AvatarImage({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return _fallback();
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFFF3F3F3),
      child: Icon(
        Icons.person_outline,
        color: const Color(0xFFBDBDBD),
        size: 28.r,
      ),
    );
  }
}
