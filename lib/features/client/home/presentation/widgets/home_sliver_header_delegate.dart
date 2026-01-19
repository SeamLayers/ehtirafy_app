import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double topPadding;
  final String userName;

  HomeSliverHeaderDelegate({this.topPadding = 0.0, required this.userName});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double progress = shrinkOffset / (maxExtent - minExtent);
    final double fadeOpacity = (1 - progress).clamp(0.0, 1.0);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2B2B2B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Greeting and Logo (Fades out)
          Positioned(
            top: topPadding + 10,
            left: 24,
            right: 24,
            child: Opacity(
              opacity: fadeOpacity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Notification Icon
                  GestureDetector(
                    onTap: () => context.push('/notifications'),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Greeting and Logo
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFC8A44F),
                                      Color(0xFFB8944F),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'PRO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'احترافي',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'مساء الخير، $userName',
                            style: const TextStyle(
                              color: Color(0xB2FFFFFF),
                              fontSize: 14,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Search Bar (Always visible, moves up)
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: GestureDetector(
              onTap: () => context.push('/search'),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Color(0xFF717182),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'ابحث عن خدمات أو مصورين...',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF717182).withOpacity(0.8),
                          fontSize: 14,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => topPadding + 145.0;

  @override
  double get minExtent => topPadding + 85.0;

  @override
  bool shouldRebuild(covariant HomeSliverHeaderDelegate oldDelegate) {
    return oldDelegate.topPadding != topPadding ||
        oldDelegate.userName != userName;
  }
}
