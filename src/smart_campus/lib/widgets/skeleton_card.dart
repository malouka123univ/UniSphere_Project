import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SkeletonCard extends StatelessWidget {
  final AnimationController controller;
  const SkeletonCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final opacity = 0.5 + (controller.value * 0.5);
        return Opacity(
          opacity: opacity,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _skeletonBox(64, 16),
                    const SizedBox(width: 8),
                    _skeletonBox(48, 16),
                  ],
                ),
                const SizedBox(height: 12),
                _skeletonBox(MediaQuery.of(context).size.width * 0.6, 24),
                const SizedBox(height: 12),
                _skeletonBox(double.infinity, 16),
                const SizedBox(height: 8),
                _skeletonBox(MediaQuery.of(context).size.width * 0.5, 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _skeletonBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}