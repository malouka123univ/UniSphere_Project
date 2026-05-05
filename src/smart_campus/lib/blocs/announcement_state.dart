import 'package:equatable/equatable.dart';
import '../entities/announcement_entity.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();
  @override
  List<Object?> get props => [];
}

class AnnouncementInitial extends AnnouncementState {
  const AnnouncementInitial();
}

class AnnouncementLoading extends AnnouncementState {
  const AnnouncementLoading();
}

class AnnouncementLoaded extends AnnouncementState {
  final List<AnnouncementEntity> announcements;
  final String selectedFilter;

  const AnnouncementLoaded({
    required this.announcements,
    this.selectedFilter = 'All',
  });

  @override
  List<Object?> get props => [announcements, selectedFilter];
}

class AnnouncementError extends AnnouncementState {
  final String message;
  const AnnouncementError({required this.message});
  @override
  List<Object?> get props => [message];
}