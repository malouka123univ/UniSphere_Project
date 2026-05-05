import 'package:flutter/material.dart';
import '../entities/announcement_entity.dart';
import '../theme/app_colors.dart';

/// Pure presentation mapper: derives ALL visual properties from entity.id
/// No changes to entity. Deterministic mapping for consistent UI.
class AnnouncementUiModel {
  final String id;
  final String category;
  final String date;
  final String title;
  final String description;
  final bool isUnread;
  final Color categoryColor;
  final Color categoryBgColor;
  final Color categoryTextColor;
  final Color borderColor;

  AnnouncementUiModel({
    required this.id,
    required this.category,
    required this.date,
    required this.title,
    required this.description,
    required this.isUnread,
    required this.categoryColor,
    required this.categoryBgColor,
    required this.categoryTextColor,
    required this.borderColor,
  });

  /// Deterministic mapping: all visual properties derived from entity.id
  factory AnnouncementUiModel.fromEntity(AnnouncementEntity entity) {
    // Deterministic category from id hash
    final categories = ['Safety', 'Academic', 'Events', 'General'];
    final category = categories[entity.id % categories.length];

    // Deterministic date from id (cycles through recent dates)
    final daysAgo = (entity.id % 7) + 1;
    final date = _formatDateDaysAgo(daysAgo);

    // Deterministic unread status (30% chance based on id)
    final isUnread = (entity.id % 3) == 0;

    // Color mapping based on derived category
    final colorSet = _categoryColorMap[category]!;

    return AnnouncementUiModel(
      id: entity.id.toString(),
      category: category,
      date: date,
      title: entity.title,
      description: entity.body,
      isUnread: isUnread,
      categoryColor: colorSet.categoryColor,
      categoryBgColor: colorSet.categoryBgColor,
      categoryTextColor: colorSet.categoryTextColor,
      borderColor: colorSet.borderColor,
    );
  }

  static String _formatDateDaysAgo(int days) {
    final now = DateTime.now();
    final date = now.subtract(Duration(days: days));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  static final Map<String, _CategoryColorSet> _categoryColorMap = {
    'Safety': _CategoryColorSet(
      categoryColor: AppColors.error,
      categoryBgColor: AppColors.errorContainer,
      categoryTextColor: AppColors.onErrorContainer,
      borderColor: AppColors.error,
    ),
    'Academic': _CategoryColorSet(
      categoryColor: AppColors.secondary,
      categoryBgColor: AppColors.secondaryContainer,
      categoryTextColor: AppColors.onSecondaryContainer,
      borderColor: AppColors.primary,
    ),
    'Events': _CategoryColorSet(
      categoryColor: AppColors.tertiary,
      categoryBgColor: AppColors.tertiaryFixed,
      categoryTextColor: AppColors.onTertiaryContainer,
      borderColor: AppColors.tertiaryFixedDim,
    ),
    'General': _CategoryColorSet(
      categoryColor: AppColors.secondary,
      categoryBgColor: AppColors.secondaryContainer,
      categoryTextColor: AppColors.onSecondaryContainer,
      borderColor: AppColors.primary,
    ),
  };
}

class _CategoryColorSet {
  final Color categoryColor;
  final Color categoryBgColor;
  final Color categoryTextColor;
  final Color borderColor;
  _CategoryColorSet({
    required this.categoryColor,
    required this.categoryBgColor,
    required this.categoryTextColor,
    required this.borderColor,
  });
}
