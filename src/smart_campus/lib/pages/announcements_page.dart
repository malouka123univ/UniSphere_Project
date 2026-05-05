import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/announcement_bloc.dart';
import '../blocs/announcement_event.dart';
import '../blocs/announcement_state.dart';
import '../features/events/presentation/pages/add_event_page.dart';
import '../features/map/presentation/pages/campus_map_page.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  final bool isAdmin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Announcements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CampusMapPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AnnouncementBloc, AnnouncementState>(
        builder: (context, state) {
          if (state is AnnouncementInitial) {
            context.read<AnnouncementBloc>().add(const LoadAnnouncements());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnnouncementLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnnouncementLoaded) {
            return Column(
              children: [
                if (state.isFromCache)
                  Container(
                    width: double.infinity,
                    color: Colors.orange,
                    padding: const EdgeInsets.all(12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Offline Mode - Local Data Displayed',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.announcements.length,
                    itemBuilder: (context, index) {
                      final item = state.announcements[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(item.title),
                          subtitle: Text(
                            item.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          if (state is AnnouncementError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AnnouncementBloc>().add(
                        const LoadAnnouncements(),
                      );
                    },
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddEventPage()),
                );
              },
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.add_moderator),
            )
          : null,
    );
  }
}
