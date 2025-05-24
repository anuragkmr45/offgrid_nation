import 'package:intl/intl.dart';

String formatPostTime(String rawDateTime) {
  final postTime = DateTime.parse(rawDateTime);
  final now = DateTime.now();
  final diff = now.difference(postTime);

  if (diff.inSeconds < 60) {
    return '${diff.inSeconds}s ago';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes}m ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours}h ago';
  } else {
    return DateFormat('MMM d').format(postTime); // Example: May 5
  }
}
