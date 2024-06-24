import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() {
    return _LocationPickerState();
  }
}

class _LocationPickerState extends State<LocationPicker> {
  final Completer<GoogleMapController> _controller = Completer();
  double initZoom = 15;
  LatLng? initCoordinates;
  Position? position;
  LatLng? value;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getLocation() async {
    position = await _determinePosition();
    initCoordinates = LatLng(position!.latitude, position!.longitude);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.seleccionarLocalizacao),
      ),
      body: FutureBuilder<void>(
        future: _getLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).canvasColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context)!.ocorreuErro),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: largura * 0.02, vertical: altura * 0.02),
              child: Container(
                height: altura * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).canvasColor),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: largura * 0.02, vertical: altura * 0.02),
                  child: Column(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          var maxWidth = largura * 0.9;
                          var maxHeight = altura * 0.67;

                          return Stack(
                            children: <Widget>[
                              SizedBox(
                                height: maxHeight,
                                width: maxWidth,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: initCoordinates!,
                                    zoom: initZoom,
                                  ),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                  onCameraMove: (CameraPosition newPosition) {
                                    value = newPosition.target;
                                  },
                                  mapType: MapType.normal,
                                  myLocationButtonEnabled: true,
                                  myLocationEnabled: false,
                                  zoomGesturesEnabled: true,
                                  padding: const EdgeInsets.all(0),
                                  buildingsEnabled: true,
                                  cameraTargetBounds:
                                      CameraTargetBounds.unbounded,
                                  compassEnabled: true,
                                  indoorViewEnabled: false,
                                  mapToolbarEnabled: true,
                                  minMaxZoomPreference:
                                      MinMaxZoomPreference.unbounded,
                                  rotateGesturesEnabled: true,
                                  scrollGesturesEnabled: true,
                                  tiltGesturesEnabled: true,
                                  trafficEnabled: false,
                                ),
                              ),
                              Positioned(
                                bottom: maxHeight / 2,
                                right: (maxWidth - 30) / 2,
                                child: Icon(
                                  FontAwesomeIcons.locationDot,
                                  size: 30,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: altura * 0.02),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FilledButton(
                            onPressed: () async {
                              var position = await _determinePosition();
                              final GoogleMapController controller =
                                  await _controller.future;
                              controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                        position.latitude, position.longitude),
                                    zoom: initZoom,
                                  ),
                                ),
                              );
                            },
                            child: const Icon(Icons.my_location),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, null);
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.cancelar),
                              ),
                              SizedBox(width: largura * 0.02),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context, value);
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.seleccionar),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
