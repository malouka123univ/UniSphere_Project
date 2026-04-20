/// ---------------------------------------------------------
/// إعداد التطبيق - الأسبوع الثاني
/// المسؤولية: ربط BLoC بالتطبيق + Dependency Injection
/// ---------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/api_service.dart';
import '/repositories/announcement_repository_impl.dart';
import '/usecases/get_announcements.dart';
import '/blocs/announcement_bloc.dart';
import '/pages/announcements_page.dart';

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- ÉTAPE 1 : Instanciation des couches (Dependency Injection) ---

    // Initialisation du service bas niveau (Réseau)
    final apiService = ApiService();

    // Liaison de la couche Data : on passe le service au dépôt
    final repository = AnnouncementRepositoryImpl(apiService: apiService);

    // Liaison de la couche Domain : on passe le dépôt au cas d'utilisation
    final getAnnouncementsUseCase = GetAnnouncementsUseCase(
      repository: repository,
    );

    // --- ÉTAPE 2 : Fournir le BLoC à l'application ---

    return BlocProvider(
      // 'create' est une méthode de fabrique (factory) lancée de manière paresseuse (lazy).
      // Elle instancie le BLoC au moment où l'application en a besoin.
      create: (_) =>
          // Injection de dépendance : On transmet le Use Case au constructeur du Bloc.
          // Cela lie officiellement la couche Presentation à la couche Domain.
          AnnouncementBloc(getAnnouncementsUseCase: getAnnouncementsUseCase),

      // MaterialApp définit la configuration globale de l'UI
      child: MaterialApp(
        title: 'Smart Campus',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

        // La page d'accueil qui pourra consommer le BLoC
        home: const AnnouncementsPage(),
      ),
    );
  }
}
