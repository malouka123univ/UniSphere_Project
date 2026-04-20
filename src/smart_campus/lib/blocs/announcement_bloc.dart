import 'package:flutter_bloc/flutter_bloc.dart';
import 'announcement_event.dart';
import 'announcement_state.dart';
import '../usecases/get_announcements.dart';

import '../network/network_info.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final GetAnnouncementsUseCase getAnnouncementsUseCase;
  final NetworkInfo networkInfo;

  AnnouncementBloc({
    required this.getAnnouncementsUseCase,
    required this.networkInfo,
  }) : super(const AnnouncementInitial()) {
    on<LoadAnnouncements>(_onLoad);
  }

  Future<void> _onLoad(
    LoadAnnouncements event,
    Emitter<AnnouncementState> emit,
  ) async {
    emit(const AnnouncementLoading());

    try {
      final announcements = await getAnnouncementsUseCase();
      final isOnline = await networkInfo.isConnected;

      emit(
        AnnouncementLoaded(
          announcements: announcements,
          isFromCache: !isOnline,
        ),
      );
    } catch (error) {
      emit(const AnnouncementError(message: 'Error in loading'));
    }
  }
}
