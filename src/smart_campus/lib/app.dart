import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import '../network/network_info.dart';
import '../services/database_helper.dart'; // تأكد من وجود الـ / قبل services
import '../repositories/announcement_repository_impl.dart';
import '../usecases/get_announcements.dart';
import '../blocs/announcement_bloc.dart';
import '../pages/announcements_page.dart';
import '../theme/app_theme.dart';

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final networkInfo = NetworkInfo();
    final databaseHelper = DatabaseHelper.instance;

    final repository = AnnouncementRepositoryImpl(
      apiService: apiService,
      networkInfo: networkInfo,
      databaseHelper: databaseHelper,
    );

    final getAnnouncementsUseCase = GetAnnouncementsUseCase(
      repository: repository,
    );

    return BlocProvider(
      create: (_) => AnnouncementBloc(
        getAnnouncementsUseCase: getAnnouncementsUseCase,
      ),
      child: MaterialApp(
        title: 'UniSphere',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AnnouncementsPage(),
      ),
    );
  }
}
