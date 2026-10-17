import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initFirebase();
  runApp(const ProviderScope(child: VestaApp()));
}

/// Firebase is initialized here. The Firebase project and its config file
/// (google-services.json, never committed) are not set up yet, so a failure
/// is logged instead of crashing the app. Remove the try/catch once the
/// project is connected.
Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (error) {
    debugPrint('Firebase is not configured yet: $error');
  }
}
