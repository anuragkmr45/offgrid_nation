import 'package:firebase_core/firebase_core.dart' show Firebase;
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/app.dart';
import 'package:offgrid_nation_app/firebase_options.dart'
    show DefaultFirebaseOptions;
import 'package:offgrid_nation_app/injection_container.dart' as di;
// import 'package:device_preview/device_preview.dart';

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

  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     tools: const [...DevicePreview.defaultTools],
  //     builder: (context) => const App(),
  //   ),
  // );
  runApp(const App());
}
