import '../entities/announcement_entity.dart';
import '../repositories/announcement_repository.dart';
import '../services/api_service.dart';
import '../models/announcement_model.dart';

// On définit une classe qui "implémente" le contrat (l'interface) AnnouncementRepository
class AnnouncementRepositoryImpl implements AnnouncementRepository {
  // On déclare le service API qui sera utilisé pour récupérer les données brutes
  final ApiService apiService;

  // Le constructeur : il exige qu'on lui fournisse un ApiService pour fonctionner
  const AnnouncementRepositoryImpl({required this.apiService});

  // On réécrit (@override) la méthode définie dans la classe abstraite
  @override
  Future<List<AnnouncementEntity>> getAnnouncements() async {
    // 1. On appelle le service pour récupérer la liste JSON brute depuis Internet
    // "await" met la fonction en pause jusqu'à ce que les données arrivent
    final List<dynamic> jsonList = await apiService.fetchPosts();

    // 2. Transformation : JSON brut -> AnnouncementModel (Couche Data)
    // .map() parcourt chaque élément de la liste pour le transformer
    final List<AnnouncementModel> models = jsonList
        .map((json) => AnnouncementModel.fromJson(json as Map<String, dynamic>))
        .toList(); // On reconvertit le résultat en une vraie Liste Dart

    // 3. Transformation : AnnouncementModel -> AnnouncementEntity (Couche Domain)
    // On convertit les modèles techniques en "Entités" pures pour l'application
    final List<AnnouncementEntity> entities = models
        .map(
          (model) => AnnouncementEntity(
            id: model.id,
            title: model.title,
            body: model.body,
          ),
        )
        .toList();

    // 4. On renvoie la liste finale d'entités, prête à être utilisée par le BLoC
    return entities;
  }
}
