import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/notification_entity.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/notification_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/notification_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/states/notification_state.dart';
import 'package:offgrid_nation_app/injection_container.dart';
import '../../widget/notifications/suggested_user_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              sl<NotificationBloc>()..add(const FetchNotificationsRequested()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Notifications")),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationLoaded) {
              final today = _filterByDate(state.notifications, DateTime.now());
              final yesterday = _filterByDate(
                state.notifications,
                DateTime.now().subtract(const Duration(days: 1)),
              );
              final last7 =
                  state.notifications.where((n) {
                    final diff = DateTime.now().difference(n.createdAt).inDays;
                    return diff >= 2 && diff <= 7;
                  }).toList();

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (today.isNotEmpty) _sectionTitle("Today"),
                  ...today.map(_buildItem),

                  if (yesterday.isNotEmpty) _sectionTitle("Yesterday"),
                  ...yesterday.map(_buildItem),

                  if (last7.isNotEmpty) _sectionTitle("Last 7 Days"),
                  ...last7.map(_buildItem),

                  _sectionTitle("Suggested for you"),
                  SuggestedUserTile(
                    name: "Lorna Alvarado",
                    username: "@lovie34",
                    avatar: 'assets/avatar3.png',
                  ),
                  SuggestedUserTile(
                    name: "Olivia Wilson",
                    username: "@low_9000",
                    avatar: 'assets/avatar4.png',
                  ),
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

  List<NotificationEntity> _filterByDate(
    List<NotificationEntity> list,
    DateTime date,
  ) {
    return list
        .where(
          (n) =>
              n.createdAt.year == date.year &&
              n.createdAt.month == date.month &&
              n.createdAt.day == date.day,
        )
        .toList();
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildItem(NotificationEntity entity) => ListTile(
    leading: const CircleAvatar(
      backgroundImage: AssetImage('assets/avatar1.png'),
    ),
    title: RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: entity.fromUserId ?? 'Someone',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ' '),
          TextSpan(text: _mapActionText(entity.type)),
        ],
      ),
    ),
    trailing: Text(
      _timeAgo(entity.createdAt),
      style: const TextStyle(color: Colors.grey),
    ),
  );

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _mapActionText(String type) {
    switch (type) {
      case 'follow':
        return 'started following you.';
      case 'like':
        return 'liked your post.';
      default:
        return 'sent a notification.';
    }
  }
}
