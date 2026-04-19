import '../entities/announcement_entity.dart';
import '../repositories/announcement_repository.dart';

class GetAnnouncementsUseCase {
  final AnnouncementRepository repository;

  const GetAnnouncementsUseCase({required this.repository});

  Future<List<AnnouncementEntity>> call() async {
    return await repository.getAnnouncements();
  }
}
