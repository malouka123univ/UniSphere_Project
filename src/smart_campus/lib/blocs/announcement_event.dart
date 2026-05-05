import 'package:equatable/equatable.dart';
import '../entities/announcement_entity.dart';

// La classe de base pour tous les événements liés aux annonces
abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();
  @override
  List<Object?> get props => [];
}

class LoadAnnouncements extends AnnouncementEvent {
  const LoadAnnouncements();
}

class FilterChanged extends AnnouncementEvent {
  final String filter;
  const FilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}
