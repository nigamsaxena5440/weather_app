import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../config/api_key.dart';

class RadarScreen extends StatefulWidget {
  final double lat;
  final double lon;

  const RadarScreen({
    super.key,
    required this.lat,
    required this.lon,
  });

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  late final MapController _mapController;

  /// TOGGLES
  bool showRadar = true;
  bool showHeatwave = true;
  bool showClouds = false;
  bool showWind = false;

  /// LOADING
  bool loading = true;

  /// DATA
  String? radarTileUrl;
  String? error;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();

    loadRadarData();
  }

  /// LOAD RAINVIEWER RADAR
  Future<void> loadRadarData() async {

    await Future.delayed(
      const Duration(seconds: 2),
    );

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.rainviewer.com/public/weather-maps.json',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List radarPast = data['radar']['past'];

        if (radarPast.isNotEmpty) {
          final latestFrame = radarPast.last;

          final String path = latestFrame['path'];

          setState(() {
            radarTileUrl =
            'https://tilecache.rainviewer.com$path/256/{z}/{x}/{y}/2/1_1.png';

            loading = false;
          });
        } else {
          setState(() {
            error = "No radar data available";
            loading = false;
          });
        }
      } else {
        setState(() {
          error = "Radar API Error";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : error != null
          ? Center(
        child: Text(
          error!,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      )
          : Stack(
        children: [

          /// MAP
          FlutterMap(
            mapController: _mapController,

            options: MapOptions(
              initialCenter:
              LatLng(widget.lat, widget.lon),

              initialZoom: 7,

              minZoom: 2,
              maxZoom: 22,
            ),

            children: [

              /// ==============================
              /// BASE MAP
              /// ==============================
              TileLayer(
                urlTemplate:
                'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=${ApiKeys.mapTilerKey}',

                userAgentPackageName:
                'com.example.weather',

                tileProvider:
                FMTCStore('mapStore').getTileProvider(),

                maxZoom: 22,

                panBuffer: 1,

                errorTileCallback:
                    (tile, error, stackTrace) {
                  debugPrint(
                      "Base Map Error: $error");
                },
              ),

              /// ==============================
              /// HEATWAVE LAYER
              /// ==============================
              if (showHeatwave)
                Opacity(
                  opacity: 0.95,

                  child: TileLayer(
                    urlTemplate:
                    'https://tile.openweathermap.org/map/temp_new/{z}/{x}/{y}.png?appid=${ApiKeys.weatherApiKey}',

                    userAgentPackageName:
                    'com.example.weather',

                    tileProvider:
                    FMTCStore('weather').getTileProvider(),

                    maxZoom: 18,

                    panBuffer: 1,
                  ),
                ),

              /// ==============================
              /// CLOUDS LAYER
              /// ==============================
              if (showClouds)
                Opacity(
                  opacity: 0.95,

                  child: TileLayer(
                    urlTemplate:
                    'https://tile.openweathermap.org/map/clouds_new/{z}/{x}/{y}.png?appid=${ApiKeys.weatherApiKey}',

                    userAgentPackageName:
                    'com.example.weather',

                    tileProvider:
                    FMTCStore('weather').getTileProvider(),

                    maxZoom: 18,
                  ),
                ),

              /// ==============================
              /// WIND LAYER
              /// ==============================
              if (showWind)
                Opacity(
                  opacity: 0.45,

                  child: TileLayer(
                    urlTemplate:
                    'https://tile.openweathermap.org/map/wind_new/{z}/{x}/{y}.png?appid=${ApiKeys.weatherApiKey}',

                    userAgentPackageName:
                    'com.example.weather',

                    tileProvider:
                    FMTCStore('weather').getTileProvider(),

                    maxZoom: 18,
                  ),
                ),

              /// ==============================
              /// RADAR LAYER
              /// ==============================
              if (showRadar &&
                  radarTileUrl != null)
                Opacity(
                  opacity: 0.55,

                  child: TileLayer(
                    urlTemplate: radarTileUrl!,

                    userAgentPackageName:
                    'com.example.weather',

                    tileProvider:
                    FMTCStore('radar').getTileProvider(),

                    maxZoom: 12,

                    panBuffer: 1,

                    errorTileCallback:
                        (tile, error, stackTrace) {
                      debugPrint(error.toString());
                    },
                  ),
                ),

              /// ==============================
              /// LOCATION MARKER
              /// ==============================
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      widget.lat,
                      widget.lon,
                    ),

                    width: 60,
                    height: 60,

                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red
                            .withOpacity(0.2),
                      ),

                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 45,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// ==============================
          /// TOP CONTROLS
          /// ==============================
          Positioned(
            top: 50,
            left: 15,
            right: 15,

            child: Column(
              children: [

                /// TITLE
                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.7),

                    borderRadius:
                    BorderRadius.circular(18),
                  ),

                  child: const Row(
                    children: [
                      Icon(
                        Icons.radar,
                        color: Colors.cyan,
                      ),

                      SizedBox(width: 10),

                      Text(
                        "Advanced Weather Radar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                /// TOGGLES
                SingleChildScrollView(
                  scrollDirection:
                  Axis.horizontal,

                  child: Row(
                    children: [

                      buildToggle(
                        title: "Radar",
                        active: showRadar,
                        onTap: () {
                          setState(() {
                            showRadar =
                            !showRadar;
                          });
                        },
                      ),

                      buildToggle(
                        title: "Heatwave",
                        active:
                        showHeatwave,
                        onTap: () {
                          setState(() {
                            showHeatwave =
                            !showHeatwave;
                          });
                        },
                      ),

                      buildToggle(
                        title: "Clouds",
                        active: showClouds,
                        onTap: () {
                          setState(() {
                            showClouds =
                            !showClouds;
                          });
                        },
                      ),

                      buildToggle(
                        title: "Wind",
                        active: showWind,
                        onTap: () {
                          setState(() {
                            showWind =
                            !showWind;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ==============================
          /// ZOOM BUTTONS
          /// ==============================
          Positioned(
            right: 15,
            bottom: 100,

            child: Column(
              children: [

                /// ZOOM IN
                FloatingActionButton(
                  mini: true,

                  heroTag: "zoomIn",

                  backgroundColor:
                  Colors.black,

                  onPressed: () {
                    final zoom =
                        _mapController
                            .camera.zoom;

                    _mapController.move(
                      _mapController
                          .camera.center,
                      zoom + 1,
                    );
                  },

                  child:
                  const Icon(Icons.add),
                ),

                const SizedBox(height: 10),

                /// ZOOM OUT
                FloatingActionButton(
                  mini: true,

                  heroTag: "zoomOut",

                  backgroundColor:
                  Colors.black,

                  onPressed: () {
                    final zoom =
                        _mapController
                            .camera.zoom;

                    _mapController.move(
                      _mapController
                          .camera.center,
                      zoom - 1,
                    );
                  },

                  child: const Icon(
                      Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// TOGGLE BUTTON
  Widget buildToggle({
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: GestureDetector(
        onTap: onTap,

        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),

          decoration: BoxDecoration(
            color: active
                ? Colors.cyan
                : Colors.black.withOpacity(0.7),

            borderRadius: BorderRadius.circular(14),
          ),

          child: Text(
            title,

            style: TextStyle(
              color: active
                  ? Colors.black
                  : Colors.white,

              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}