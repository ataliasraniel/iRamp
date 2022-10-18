import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/core/assets_index.dart';
import '../../shared/core/db/firestore_db_manager.dart';
import '../../shared/core/entities/ramp_model.dart';

class HomeScreenController with ChangeNotifier {
  Completer<GoogleMapController> mapController =
      Completer();

  List<Marker> customMarkers = [];
  final FirestoreDatabaseManager db =
      FirestoreDatabaseManager();
  //list of markers
  void startMaps() async {
    log('starting maps');
    // customMarkers.add(Marker(
    //   //add first marker
    //   markerId: MarkerId('asdasd2'),
    //   position: LatLng(-8.904058702404086,
    //       -36.48719616892984), //position of marker
    //   infoWindow: InfoWindow(
    //     //popup info
    //     title: 'Rampa 2',
    //     snippet: 'Rampa em Garanhuns',
    //   ),
    //   icon: await BitmapDescriptor.fromAssetImage(
    //       const ImageConfiguration(),
    //       'assets/png/green.png'), //Icon for Marker
    // ));
    db.getRamps().then((value) {
      makeMarkers(value);
    });
  }

  String refineIcon(int type) {
    switch (type) {
      case 0:
        return 'assets/png/green.png';
      case 1:
        return 'assets/png/yellow.png';
      case 2:
        return 'assets/png/red.png';
      default:
        return '';
    }
  }

  makeMarkers(List<RampModel> model) async {
    for (var i = 0; i < model.length; i++) {
      customMarkers.add(Marker(
        //add first marker
        markerId: MarkerId('asdasd$i'),
        position: LatLng(model[i].lat,
            model[i].long), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Rampa $i',
          snippet: 'Rampa em Garanhuns',
        ),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            refineIcon(model[i].type)), //Icon for Marker
      ));
      notifyListeners();
    }
    log(customMarkers.toString());
  }

  Future<void> goToPostionInMap(
    CameraPosition position,
  ) async {
    final GoogleMapController controller =
        await mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(position));
    notifyListeners();
  }
//   void requestUserGalleryPermission() async {
//     var status = await Permission.camera.status;
//     if (status.isDenied) {
//       // We didn't ask for permission yet or the permission has been denied before but not permanently.
//       log('user has denied access, try again');
//     }

// // You can can also directly ask the permission about its status.
//     if (await Permission.mediaLibrary.request().isGranted) {
//       log('User has granted access');
//       // The OS restricts access, for example because of parental controls.
//     }
//   }
}
