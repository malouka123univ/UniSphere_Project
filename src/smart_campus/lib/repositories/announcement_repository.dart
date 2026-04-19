import '../entities/announcement_entity.dart';

abstract class AnnouncementRepository {
  Future<List<AnnouncementEntity>> getAnnouncements();
}
