import '../entities/announcement_entity.dart';
import '../repositories/announcement_repository.dart';
import '../services/api_service.dart';
import '../models/announcement_model.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final ApiService apiService;

  const AnnouncementRepositoryImpl({required this.apiService});

  @override
  Future<List<AnnouncementEntity>> getAnnouncements() async {
    final List<dynamic> jsonList = await apiService.fetchPosts();

    final List<AnnouncementModel> models = jsonList
        .map((json) => AnnouncementModel.fromJson(json as Map<String, dynamic>))
        .toList();

    final List<AnnouncementEntity> entities = models
        .map(
          (model) => AnnouncementEntity(
            id: model.id,
            title: model.title,
            body: model.body,
          ),
        )
        .toList();

    return entities;
  }
}
