import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thunderapp/components/buttons/custom_text_button.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/screens/home/home_screen_controller.dart';
import 'package:thunderapp/screens/screens_index.dart';
import 'package:thunderapp/shared/constants/app_number_constants.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/navigator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => HomeScreenController(),
      builder: (context, child) =>
          Consumer<HomeScreenController>(
        builder: ((context, controller, child) => Scaffold(
              key: _scaffoldKey,
              // floatingActionButtonLocation:
              //     FloatingActionButtonLocation.endTop,
              // floatingActionButton: FloatingActionButton(
              //   backgroundColor: kPrimaryColor,
              //   mini: true,
              //   onPressed: () {},
              //   child: const Icon(Icons.add),
              // ),
              drawer: Drawer(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text(
                        FirebaseAuth
                            .instance.currentUser!.email
                            .toString(),
                        style: kBody3.copyWith(
                            color: kDarkTextColor),
                      ),
                    ),
                    ListTile(
                      title: Text('Sair da conta'),
                      trailing: Icon(Icons.exit_to_app),
                    )
                  ],
                ),
              ),
              // appBar: AppBar(
              //   automaticallyImplyLeading: true,
              //   title: const Text('Seja Bem-vindo'),
              // ),
              body: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.blue,
                      height: size.height,
                      child: Stack(
                        children: [
                          MapPage(size: size),
                          Column(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.all(
                                        kDefaultPadding),
                                child: Column(
                                  children: <Widget>[
                                    PrimaryButton(
                                        text:
                                            'Cadastrar nova rampa',
                                        onPressed: () {
                                          navigatorKey
                                              .currentState!
                                              .pushNamed(Screens
                                                  .addNewRamp);
                                        })
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                                    vertical: 28),
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                    color: kTextColor,
                                    onPressed: () {
                                      _scaffoldKey
                                          .currentState!
                                          .openDrawer();
                                    },
                                    icon: const Icon(
                                        Icons.menu))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static final CameraPosition _startingPosition =
      CameraPosition(
    target: LatLng(
      -8.903941400890043,
      -36.4870645273051,
    ),
    zoom: 14.4746,
  );

  static final CameraPosition _desiredPosition =
      CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(
            -8.903941400890043,
            -36.4870645273051,
          ),
          tilt: 59.440717697143555,
          zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();
    context.read<HomeScreenController>().startMaps();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height,
      child: GoogleMap(
          markers: context
              .read<HomeScreenController>()
              .customMarkers
              .toSet(),
          onMapCreated: (GoogleMapController controller) {
            context
                .read<HomeScreenController>()
                .mapController;
          },
          initialCameraPosition: _startingPosition),
    );
  }
}
