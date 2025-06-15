import 'package:firebase_core/firebase_core.dart' show Firebase;
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/app.dart';
import 'package:offgrid_nation_app/core/navigation/global_navigator.dart';
// import 'package:offgrid_nation_app/core/services/notification_listener_service.dart';
import 'package:offgrid_nation_app/core/services/pusher_service.dart';
// import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/firebase_options.dart'
    show DefaultFirebaseOptions;
import 'package:offgrid_nation_app/injection_container.dart' as di;
import 'package:uni_links/uni_links.dart';
// import 'package:device_preview/device_preview.dart';

Future<void> initDeepLinks() async {
  uriLinkStream.listen((Uri? uri) {
    if (uri == null) return;
    final path = uri.path;

    if (path.contains('/stripe/success')) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/home',
        (route) => false,
        arguments: {'initialTab': 4},
      );
    }

    if (path.contains('/stripe/cancel')) {
      navigatorKey.currentState?.pushNamed('/payment-failed');
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordError(
  //     errorDetails.exception,
  //     errorDetails.stack,
  //   );
  // };
  await di.init();

  const pusherKey = '15fb3af3b13dcd9b4924';
  const pusherCluster = 'us3';

  await PusherService().initPusher(apiKey: pusherKey, cluster: pusherCluster);

  await initDeepLinks();

  // Initialize local notifications
  // await NotificationListenerService().initLocalNotifications();
  // final authSession = di.sl<AuthSession>();
  // final isLoggedIn = await authSession.isLoggedIn();
  // if (isLoggedIn) {
  //   final userId = await authSession.getCurrentUserId();
  //   if (userId != null) {
  //     NotificationListenerService().startListening(userId);
  //   }
  // }

  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     tools: const [...DevicePreview.defaultTools],
  //     builder: (context) => const App(),
  //   ),
  // );
  runApp(const App());
}
