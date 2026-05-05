import 'package:flutter_bloc/flutter_bloc.dart';
import 'announcement_event.dart';
import 'announcement_state.dart';
import '../usecases/get_announcements.dart';
import '../network/network_info.dart';

/// Il orchestre la transformation des événements utilisateur en états d'interface
class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final GetAnnouncementsUseCase getAnnouncementsUseCase;
  final NetworkInfo networkInfo;

  AnnouncementBloc({
    required this.getAnnouncementsUseCase,
    required this.networkInfo,
  }) : super(const AnnouncementInitial()) {
    //le premier state is announcemet initial
    // Enregistrement du gestionnaire pour l'événement de chargement.
    on<LoadAnnouncements>(_onLoad);
  }

  /// Gère la logique lors de la réception de l'événement LoadAnnouncement
  Future<void> _onLoad(
    LoadAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    // 1. Émet l'état de chargement pour afficher un indicateur visuel (Spinner)[cite: 45].
    emit(const AnnouncementLoading());

    try {
      // 2. Exécute le cas d'utilisation (UseCase) de manière asynchrone[cite: 53].
      // Cela récupère les données via le Repository (API ou SQLite)[cite: 97, 126].
      final announcements = await getAnnouncementsUseCase();

      // 3. Vérifie l'état du réseau après la récupération (Async State Consistency)[cite: 130].
      // Cela garantit que l'indicateur reflète la réalité technique actuelle[cite: 131].
      final isOnline = await networkInfo.isConnected;

      // 4. Émet l'état de succès avec le flag 'isFromCache'[cite: 110, 128].
      // Si l'appareil est hors ligne (!isOnline), isFromCache sera vrai[cite: 128].
      emit(
        AnnouncementLoaded(
          announcements: announcements,
          isFromCache: !isOnline,
        ),
      );
    } catch (error) {
      // 5. En cas d'échec, capture l'exception et émet un état d'erreur explicite[cite: 47].
      emit(const AnnouncementError(message: 'Error in loading'));
    }
  }
}
