import 'dart:convert';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  static final PusherService _singleton = PusherService._internal();
  factory PusherService() => _singleton;

  PusherService._internal(); // FIXED: missing constructor

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  bool _initialized = false;

  Future<void> initPusher({
    required String apiKey,
    required String cluster,
  }) async {
    if (_initialized) return;

    try {
      await _pusher.init(
        apiKey: apiKey,
        cluster: cluster,
        onConnectionStateChange: (currentState, previousState) {
          print('Pusher connection state: $currentState');
        },
        onError: (message, code, e) {
          print('Pusher error: $message (code: $code), Exception: $e');
        },
      );

      await _pusher.connect();
      _initialized = true;
    } catch (e) {
      print('Pusher init failed: $e');
    }
  }

  Future<void> subscribeChatChannel({
    required String conversationId,
    required Function(Map<String, dynamic>) onNewMessage,
    Function(String)? onMessageRead,
  }) async {
    if (!_initialized) return;
    final channelName = 'direct.$conversationId';

    await _pusher.subscribe(
      channelName: channelName,
      onEvent: (event) {
        if (event.eventName == 'new-message') {
          final data = jsonDecode(event.data);
          onNewMessage(data);
        } else if (event.eventName == 'message-read') {
          final data = jsonDecode(event.data);
          final convId = data['conversationId'];
          if (convId == conversationId && onMessageRead != null) {
            onMessageRead(convId);
          }
        }
      },
    );
  }

  Future<void> unsubscribeChatChannel(String conversationId) async {
    if (!_initialized) return;

    final channelName = 'direct.$conversationId';
    await _pusher.unsubscribe(channelName: channelName); // FIXED: correct call
  }

  Future<void> subscribeNotifications({
    required String userId,
    required Function(Map<String, dynamic>) onPushNotification,
  }) async {
    final channelName = 'notifications.$userId';

    await _pusher.subscribe(
      channelName: channelName,
      onEvent: (event) {
        if (event.eventName == 'push-noti') {
          final data = jsonDecode(event.data);
          onPushNotification(data);
        }
      },
    );
  }

  Future<void> unsubscribeNotifications(String userId) async {
    if (!_initialized) return;

    final channelName = 'notifications.$userId';
    try {
      await _pusher.unsubscribe(channelName: channelName);
    } catch (e) {
      print('Pusher unsubscribe failed for $channelName: $e');
    }
  }
}
