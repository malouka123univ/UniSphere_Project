import 'package:flutter_bloc/flutter_bloc.dart';
import 'announcement_event.dart';
import 'announcement_state.dart';
import '../usecases/get_announcements.dart';
import '../network/network_info.dart';
import '../entities/announcement_entity.dart'; // Import ajouté

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final GetAnnouncementsUseCase getAnnouncementsUseCase;
  final NetworkInfo networkInfo;

  AnnouncementBloc({
    required this.getAnnouncementsUseCase,
    required this.networkInfo,
  }) : super(const AnnouncementInitial()) {

    // Enregistrement des gestionnaires d'événements
    on<LoadAnnouncements>(_onLoad);
    on<AddAnnouncement>(_onAddAnnouncement); // Déplacé ici
  }

  Future<void> _onLoad(LoadAnnouncements event, Emitter<AnnouncementState> emit) async {
    emit(const AnnouncementLoading());
    try {
      final announcements = await getAnnouncementsUseCase();
      final isOnline = await networkInfo.isConnected;
      emit(AnnouncementLoaded(
        announcements: announcements,
        isFromCache: !isOnline,
      ));
    } catch (error) {
      emit(const AnnouncementError(message: 'Error in loading'));
    }
  }

  void _onAddAnnouncement(AddAnnouncement event, Emitter<AnnouncementState> emit) {
    if (state is AnnouncementLoaded) {
      final currentState = state as AnnouncementLoaded;
      // Création d'une nouvelle liste avec l'élément ajouté au début
      final updatedList = List<AnnouncementEntity>.from(currentState.announcements)
        ..insert(0, event.announcement);

      emit(AnnouncementLoaded(
        announcements: updatedList,
        isFromCache: currentState.isFromCache,
      ));
    }
  }
}