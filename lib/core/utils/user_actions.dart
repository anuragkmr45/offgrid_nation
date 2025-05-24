import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/injection_container.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/update_toggle_follow_unfollow_usecase.dart';

class UserActions {
  static Future<bool> toggleFollow({
    required BuildContext context,
    required String username,
    required bool isBlocked,
  }) async {
    if (isBlocked) {
      debugPrint('Cannot follow: user is blocked');
      return false;
    }

    try {
      final result = await sl<UpdateToggleFollowUnfollowUsecase>().call(
        username,
      );
      final message = result['message'] ?? 'Updated';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      // Return true if user is now following, false if unfollowed/requested
      return message.toLowerCase().contains('followed');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update follow: $e')));
      return false;
    }
  }
}
