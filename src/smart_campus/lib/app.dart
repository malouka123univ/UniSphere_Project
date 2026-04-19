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
    final apiService = ApiService();
    final repository = AnnouncementRepositoryImpl(apiService: apiService);
    final getAnnouncementsUseCase = GetAnnouncementsUseCase(
      repository: repository,
    );

    return BlocProvider(
      create: (_) =>
          AnnouncementBloc(getAnnouncementsUseCase: getAnnouncementsUseCase),
      child: MaterialApp(
        title: 'Smart Campus',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const AnnouncementsPage(),
      ),
    );
  }
}
