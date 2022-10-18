import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thunderapp/app.dart';
import 'package:thunderapp/screens/home/home_screen_controller.dart';
import 'package:thunderapp/shared/core/db/firestore_db_manager.dart';
import 'package:thunderapp/shared/core/selected_item.dart';
import 'package:timezone/data/latest_all.dart' as tz;

main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  Firebase.initializeApp();
  Logger.root.level = Level.ALL; // defaults to Level.INFO

  Logger.root.onRecord.listen((record) {});
  // SharedPreferences.getInstance()
  //     .then((value) => value.clear());

  runApp(DevicePreview(
      enabled:
          defaultTargetPlatform == TargetPlatform.android
              ? false
              : true,
      builder: (context) => const App()));
}
