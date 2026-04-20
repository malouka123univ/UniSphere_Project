import '../entities/announcement_entity.dart';
import '../repositories/announcement_repository.dart';
import '../services/api_service.dart';
import '../models/announcement_model.dart';

// On définit une classe qui "implémente" le contrat (l'interface) AnnouncementRepository

import '../network/network_info.dart';
import '../../../../services/database_helper.dart';

/// Responsabilité : Décider d'où viennent les données (API ou SQLite)
/// Concept OS : Offline-First Architecture
class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final ApiService apiService;
  final NetworkInfo networkInfo; // ← Nouveau : vérifie la connexion
  final DatabaseHelper databaseHelper; // ← Nouveau : base de données locale

  const AnnouncementRepositoryImpl({
    required this.apiService,
    required this.networkInfo,
    required this.databaseHelper,
  });

  @override
  Future<List<AnnouncementEntity>> getAnnouncements() async {
    /// Étape 1 : Vérifier si l'appareil est connecté à Internet
    final isOnline = await networkInfo.isConnected;

    if (isOnline) {
      try {
        /// MODE EN LIGNE : Récupérer depuis l'API REST
        final List<dynamic> jsonList = await apiService.fetchPosts();
        final models = jsonList
            .map(
              (json) =>
                  AnnouncementModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();

        /// Stratégie Cache : Sauvegarder dans SQLite pour usage futur hors ligne
        await databaseHelper.cacheAnnouncements(models);

        /// Mapper les Models vers des Entities (propre, sans JSON)
        return models
            .map(
              (m) => AnnouncementEntity(id: m.id, title: m.title, body: m.body),
            )
            .toList();
      } catch (e) {
        /// Si l'API échoue malgré la connexion → Fallback sur le cache local
        return await _getFromCache();
      }
    } else {
      /// MODE HORS LIGNE : Lire uniquement depuis SQLite
      return await _getFromCache();
    }
  }

  /// Méthode privée : Récupérer les données depuis la base locale
  Future<List<AnnouncementEntity>> _getFromCache() async {
    final models = await databaseHelper.getCachedAnnouncements();
    return models
        .map((m) => AnnouncementEntity(id: m.id, title: m.title, body: m.body))
        .toList();
  }
}
