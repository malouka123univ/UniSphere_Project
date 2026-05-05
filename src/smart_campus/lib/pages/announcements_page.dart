import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../entities/announcement_entity.dart';
import '../blocs/announcement_bloc.dart';
import '../blocs/announcement_event.dart';
import '../blocs/announcement_state.dart';
import '../models/announcement_ui_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/announcement_card.dart';
import '../widgets/skeleton_card.dart';
// أضف استيراد صفحة الخريطة هنا

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _skeletonController;
  final List<String> _filters = ['All', 'Academic', 'Events', 'Safety'];

  @override
  void initState() {
    super.initState();
    _skeletonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _skeletonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<AnnouncementBloc, AnnouncementState>(
          listener: (context, state) {
            if (state is AnnouncementInitial) {
              context.read<AnnouncementBloc>().add(const LoadAnnouncements());
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    SliverToBoxAdapter(child: _buildHeader()),
                    SliverToBoxAdapter(child: _buildFilterChips(state)),
                    _buildContent(state),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
                _buildTopAppBar(),
                _buildBottomNavBar(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Announcements', style: AppTypography.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Stay updated with the latest campus news',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(AnnouncementState state) {
    final selectedFilter = state is AnnouncementLoaded
        ? state.selectedFilter
        : 'All';

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.only(bottom: 24),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = selectedFilter == filter;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.read<AnnouncementBloc>().add(FilterChanged(filter));
              },
              borderRadius: BorderRadius.circular(9999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  filter,
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(AnnouncementState state) {
    if (state is AnnouncementLoading || state is AnnouncementInitial) {
      return SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'CHECKING FOR UPDATES...',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SkeletonCard(controller: _skeletonController),
          ],
        ),
      );
    }

    if (state is AnnouncementError) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(state.message),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<AnnouncementBloc>().add(const LoadAnnouncements());
                },
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is AnnouncementLoaded) {
      // Filter logic: derived from entity.id % category count
      final allAnnouncements = state.announcements;
      final filtered = state.selectedFilter == 'All'
          ? allAnnouncements
          : allAnnouncements.where((e) {
              final categories = ['Safety', 'Academic', 'Events', 'General'];
              return categories[e.id % categories.length] == state.selectedFilter;
            }).toList();

      if (filtered.isEmpty) {
        return SliverToBoxAdapter(
          child: _buildEmptyState(state.selectedFilter),
        );
      }

      final uiModels = filtered
          .map((e) => AnnouncementUiModel.fromEntity(e))
          .toList();

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AnnouncementCard(model: uiModels[index]),
            ),
            childCount: uiModels.length,
          ),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildEmptyState(String currentFilter) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerHigh,
                  ),
                  child: const Icon(
                    Icons.campaign_outlined,
                    size: 48,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.tertiaryFixedDim,
                    ),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No announcements here yet.',
            style: AppTypography.headlineSmall.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "We couldn't find any events matching your current filter. Check back later!",
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              context.read<AnnouncementBloc>().add(const FilterChanged('All'));
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: AppTypography.labelMedium.copyWith(
                decoration: TextDecoration.underline,
                decorationThickness: 2,
              ),
            ),
            child: const Text('Clear all filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withOpacity(0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.school_outlined, color: AppColors.primary, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'UniSphere',
                      style: TextStyle(
                        fontFamily: AppTypography.headlineFont,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerHighest,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.05),
                      width: 2,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withOpacity(0.06),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, 'Home', false),
                _buildNavItem(Icons.campaign, 'Updates', true),
                _buildNavItem(Icons.calendar_today_outlined, 'Schedule', false),
                _buildNavItem(Icons.settings_outlined, 'Settings', false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryFixedDim.withOpacity(0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: isActive ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isActive ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}