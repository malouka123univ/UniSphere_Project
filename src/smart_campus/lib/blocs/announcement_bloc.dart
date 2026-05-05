import 'package:flutter_bloc/flutter_bloc.dart';
import 'announcement_event.dart';
import 'announcement_state.dart';
import '../usecases/get_announcements.dart';
import '../network/network_info.dart';
import '../entities/announcement_entity.dart'; // Import ajouté

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final GetAnnouncementsUseCase getAnnouncementsUseCase;


  AnnouncementBloc({required this.getAnnouncementsUseCase})
    : super(const AnnouncementInitial()) {
    on<LoadAnnouncements>(_onLoadAnnouncements);
    on<FilterChanged>(_onFilterChanged);
  }

  Future<void> _onLoadAnnouncements(
    LoadAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(const AnnouncementLoading());
    try {
      final announcements = await getAnnouncementsUseCase();
      emit(AnnouncementLoaded(announcements: announcements));
    } catch (error) {
      emit(
        const AnnouncementError(
          message:
              'Failed to load announcements. Please check your connection.',
        ),
      );
    }
  }

  void _onFilterChanged(FilterChanged event, Emitter<AnnouncementState> emit) {
    if (state is AnnouncementLoaded) {
      final currentState = state as AnnouncementLoaded;
      emit(
        AnnouncementLoaded(
          announcements: currentState.announcements,
          selectedFilter: event.filter,
        ),
      );
    }

    final updatedList = [event.announcement, ...currentList];

    emit(AnnouncementLoaded(announcements: updatedList, isFromCache: true));
  }
}
