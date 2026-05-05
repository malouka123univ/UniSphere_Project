import '../entities/announcement_entity.dart';

abstract class AnnouncementRepository {
  //chaque claase de announcement il feaut contien cette methode
  Future<List<AnnouncementEntity>> getAnnouncements();
}
