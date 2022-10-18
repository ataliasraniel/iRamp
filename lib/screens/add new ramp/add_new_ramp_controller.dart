import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thunderapp/screens/screens_index.dart';
import 'package:thunderapp/shared/core/db/firestore_db_manager.dart';
import 'package:thunderapp/shared/core/navigator.dart';

import '../../shared/constants/app_enums.dart';
import '../../shared/core/toast/app_notification_manager.dart';

enum RampType { good, bad, median }

class AddNewRampController with ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  RampType type = RampType.good;
  final FirestoreDatabaseManager db =
      FirestoreDatabaseManager();
  final TextEditingController referenceController =
      TextEditingController();
  final TextEditingController descriptionController =
      TextEditingController();
  String reference = '';
  String description = '';
  double latitude = 0;
  double longitude = 0;
  XFile? pickedImage;

  void getLocation() async {
    _determinePosition().then((value) {
      AppSnackbarManager.showSimpleNotification(
          NotificationType.success,
          'Sua localização foi capturada. 🆗👆');
      latitude = value.latitude;
      longitude = value.longitude;
      notifyListeners();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    log('getting location');

    // Test if location services are enabled.
    serviceEnabled =
        await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error(
          'Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
            'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy:
            LocationAccuracy.bestForNavigation);
  }

  void pickImage() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera);
    pickedImage = photo;
    notifyListeners();
  }

  void setReference(String value) {
    reference = value;
  }

  void setDescription(String value) {
    description = value;
  }

  void finishCreation() {
    int rank = 0;
    switch (type) {
      case RampType.bad:
        rank = 2;
        break;
      case RampType.median:
        rank = 1;
        break;
      case RampType.good:
        rank = 0;
        break;
      default:
        rank = 0;
    }
    db
        .createNewRampInDb(
            referenceController.text,
            descriptionController.text,
            rank,
            latitude,
            longitude)
        .then((value) => navigatorKey.currentState!
            .popAndPushNamed(Screens.finished));
  }
}
