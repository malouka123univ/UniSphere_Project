import 'package:flutter_bloc/flutter_bloc.dart';
import 'announcement_event.dart';
import 'announcement_state.dart';
import '../usecases/get_announcements.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final GetAnnouncementsUseCase getAnnouncementsUseCase;

  AnnouncementBloc({required this.getAnnouncementsUseCase})
    : super(const AnnouncementInitial()) {
    on<LoadAnnouncements>(_onLoadAnnouncements);
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
          message: 'Ad loading failed. Please verify your connection',
        ),
      );
    }
  }
}
