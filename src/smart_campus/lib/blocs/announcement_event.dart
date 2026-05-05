import 'package:equatable/equatable.dart';
import '../entities/announcement_entity.dart';
// La classe de base pour tous les événements liés aux annonces
abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();

  // Equatable permet d'éviter de déclencher le même événement plusieurs fois par erreur
  @override
  List<Object?> get props => [];
}

// L'événement spécifique qui déclenche le chargement des données
// On l'appelle quand l'utilisateur ouvre l'écran ou tire pour rafraîchir (Pull-to-refresh)
class LoadAnnouncements extends AnnouncementEvent {
  const LoadAnnouncements();
}
class AddAnnouncement extends AnnouncementEvent {
  final AnnouncementEntity announcement;
  const AddAnnouncement(this.announcement);

  @override
  List<Object?> get props => [announcement];
}
