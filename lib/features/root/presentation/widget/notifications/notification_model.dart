class AppNotification {
  final String name;
  final String action;
  final String time;
  final String avatar;
  final String section;

  AppNotification({
    required this.name,
    required this.action,
    required this.time,
    required this.avatar,
    required this.section,
  });

  // Simulated API data
  static List<AppNotification> get sampleData => [
        AppNotification(name: 'Claudia Alves', action: 'started following you.', time: '20min', avatar: 'assets/avatar1.png', section: 'today'),
        AppNotification(name: 'Avery Davis', action: 'and 17 others liked your post.', time: '21min', avatar: 'assets/avatar2.png', section: 'today'),
        AppNotification(name: 'Claudia Alves', action: 'started following you.', time: '20h', avatar: 'assets/avatar1.png', section: 'yesterday'),
        AppNotification(name: 'Avery Davis', action: 'and 17 others liked your post.', time: '17h', avatar: 'assets/avatar2.png', section: 'yesterday'),
        AppNotification(name: 'Claudia Alves', action: 'started following you.', time: '1d', avatar: 'assets/avatar1.png', section: 'last7'),AppNotification(name: 'Claudia Alves', action: 'started following you.', time: '20min', avatar: 'assets/avatar1.png', section: 'today'),
        AppNotification(name: 'Avery Davis', action: 'and 17 others liked your post.', time: '21min', avatar: 'assets/avatar2.png', section: 'today'),
        AppNotification(name: 'Claudia Alves', action: 'started following you.', time: '20h', avatar: 'assets/avatar1.png', section: 'yesterday'),
        AppNotification(name: 'Avery Davis', action: 'and 17 others liked your post.', time: '17h', avatar: 'assets/avatar2.png', section: 'yesterday'),
        AppNotification(name: 'Claudia Alves', action: 'started following you.', time: '1d', avatar: 'assets/avatar1.png', section: 'last7'),AppNotification(name: 'Claudia Alves', action: 'started following you.', time: '20min', avatar: 'assets/avatar1.png', section: 'today'),
        AppNotification(name: 'Avery Davis', action: 'and 17 others liked your post.', time: '21min', avatar: 'assets/avatar2.png', section: 'today'),
        AppNotification(name: 'Claudia Alves', action: 'started following you.', time: '20h', avatar: 'assets/avatar1.png', section: 'yesterday'),
        AppNotification(name: 'Avery Davis', action: 'and 17 others liked your post.', time: '17h', avatar: 'assets/avatar2.png', section: 'yesterday'),
        AppNotification(name: 'Claudia Alves', action: 'started following you.', time: '1d', avatar: 'assets/avatar1.png', section: 'last7'),
        AppNotification(name: 'Avery Davis', action: 'and 17 others liked your post.', time: '3d', avatar: 'assets/avatar2.png', section: 'last7'),
      ];
}
