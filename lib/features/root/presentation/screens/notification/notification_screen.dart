import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/notification_entity.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/notification_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/notification_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/states/notification_state.dart';
import 'package:offgrid_nation_app/injection_container.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationBloc>()..add(const FetchNotificationsRequested()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Notifications")),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              final now = DateTime.now();
              final last24h = state.notifications
                  .where((n) => now.difference(n.createdAt).inHours < 24)
                  .toList();
              final older = state.notifications
                  .where((n) => now.difference(n.createdAt).inHours >= 24)
                  .toList();

              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  if (last24h.isNotEmpty) _sectionTitle("Last 24 Hours"),
                  ...last24h.map(_buildItem),

                  if (older.isNotEmpty) _sectionTitle("Earlier"),
                  ...older.map(_buildItem),
                ],
              );
            } else if (state is NotificationError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildItem(NotificationEntity entity) {
    return ListTile(
      leading: entity.profilePicture != null && entity.profilePicture!.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(entity.profilePicture!),
            )
          : const CircleAvatar(backgroundColor: Colors.blue, radius: 20),
      title: Text(
        entity.message ?? 'You have a new notification',
        style: const TextStyle(fontSize: 15),
      ),
      trailing: Text(
        _timeAgo(entity.createdAt),
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
