import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final List<LatLng> coordinates;
  final List names;
  final List addreses;
  MapPage(
      {required this.coordinates, required this.names, required this.addreses});
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Set<Marker> _markers = {}; // Zbiór markerów do wyświetlenia na mapie

  @override
  void initState() {
    super.initState();
    _markers = _coordinatesToMarkers(
        widget.coordinates, widget.names, widget.addreses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(54.372158, 18.638306), // Początkowe położenie mapy
            zoom: 10, // Początkowy poziom przybliżenia mapy
          ),
          markers: _markers,
        ),
        Positioned(
          top: 30,
          left: 0,
          right: 0,
          child: _headWidget(),
        ),
      ]),
    );
  }

  Set<Marker> _coordinatesToMarkers(
      List<LatLng> coordinates, List names, List addresses) {
    Set<Marker> markers = {};

    for (int i = 0; i < coordinates.length; i++) {
      LatLng latLng = coordinates[i];

      final marker = Marker(
        markerId: MarkerId('marker_$i'),
        position: latLng,
        infoWindow: InfoWindow(title: names[i], snippet: addresses[i]),
      );

      markers.add(marker);
    }

    return markers;
  }

  Widget _headWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Check your customers',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: 30,
              )),
        ],
      ),
    );
  }
}
