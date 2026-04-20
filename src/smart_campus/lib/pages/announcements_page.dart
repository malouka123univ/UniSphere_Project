import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/announcement_bloc.dart';
import '../blocs/announcement_event.dart';
import '../blocs/announcement_state.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('University advertisements')),
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
            return ListView.builder(
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
    );
  }
}
