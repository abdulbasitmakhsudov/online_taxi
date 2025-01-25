import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:online_taxi/config/routes/app_routes.dart';
import 'package:online_taxi/core/app_preferences/isar_helper.dart';
import 'package:online_taxi/core/extensions/common_extensions.dart';
import 'package:online_taxi/core/extensions/navigation_extension.dart';
import 'package:online_taxi/core/widgets/primary_under_widget.dart';
import 'package:online_taxi/features/weather/domain/entity/history_entity.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_fonts.dart';
import '../../../../../core/widgets/primary_floating_action_button.dart';
import '../../../../../core/widgets/under_save_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum PlaceType { start, end }

class _HomeScreenState extends State<HomeScreen> {
  late YandexMapController _controller;
  List<MapObject> _mapObjects = [];
  Point? _currentLocation;
  Point? _destinationPoint;
  String? _locationInfo;
  String? _travelTime;
  Timer? _timer;
  int _elapsedSeconds = 0;

  Future<void> _checkPermissionAndLocateUser() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
            Text('Location services are disabled. Please enable them.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    _locateUser();
  }

  Future<void> _locateUser() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final userPoint =
      Point(latitude: position.latitude, longitude: position.longitude);

      setState(() {
        _currentLocation = userPoint;
        if (_destinationPoint != null) {
          _requestRoutes();
        }
      });

      _updateMarkerAndInfo(userPoint);
      _controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: userPoint, zoom: 14),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error locating user: $e')),
      );
    }
  }

  Future<void> _updateMarkerAndInfo(Point point) async {
    setState(() {
      _mapObjects.removeWhere(
              (mapObject) => mapObject.mapId.value == 'selected_point');
      _mapObjects.add(
        PlacemarkMapObject(
          mapId: const MapObjectId('selected_point'),
          point: point,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage("ic_marker".pngIcon),
            ),
          ),
        ),
      );
    });
  }

  void _startTrip(Point destination) {
    setState(() {
      _destinationPoint = destination;
      _elapsedSeconds = 0;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
        _travelTime =
        "Travel time: ${_elapsedSeconds ~/ 60} min ${_elapsedSeconds % 60} sec";
      });
    });
  }

  void _endTrip() {
    _timer?.cancel();
    setState(() {
      _destinationPoint = null;
      _travelTime = null;
    });
  }

  final TextEditingController queryController = TextEditingController();

  List<SuggestItem> suggests = [];

  bool isDriving = false;

  Future<void> _suggest(String query) async {
    // final query = queryController.text;

    final resultWithSession = await YandexSuggest.getSuggestions(
        text: query,
        boundingBox: const BoundingBox(
            northEast: Point(latitude: 56.0421, longitude: 38.0284),
            southWest: Point(latitude: 55.5143, longitude: 37.24841)),
        suggestOptions: const SuggestOptions(
            suggestType: SuggestType.geo,
            suggestWords: true,
            userPosition: Point(latitude: 56.0321, longitude: 38)));

    final result = await resultWithSession.result;

    setState(() {
      suggests = result.items ?? [];
    });
    // await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => _SessionPage(
    //             query, resultWithSession.$1, resultWithSession.$2)));
  }

  void openBottomSheet(PlaceType placeType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      elevation: 0,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          Container(
            height: context.screenSize.height - 108,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TextField uchun konteyner
                42.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(placeType == PlaceType.start ? "Where from?" : "Where to?",
                    style: pmedium,),
                ),
                Container(
                  height: 56,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(left: 16, right: 16, top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.white,
                  ),
                  child: TextField(
                    controller: queryController,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    onSubmitted: _suggest,
                    style: pmedium.copyWith(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Search for a location',
                      hintStyle: pmedium.copyWith(
                        fontSize: 16,
                        color: AppColors.steelGrey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // Suggest elementlari uchun scrollable qism
                Expanded(
                  child: suggests.isEmpty
                      ? Center(
                    child: Lottie.asset(
                        'assets/lottie/empty.json',
                        width: 200.w,
                        height: 200.h,
                        repeat: false
                    ),
                  )
                      : getList(onTap: (item) {
                    suggests.clear();
                    queryController.clear();

                    setState(() {
                      if (PlaceType.start == placeType) {
                        _currentLocation = item.center;
                      } else {
                        _destinationPoint = item.center;
                      }
                    });
                    if (_destinationPoint != null &&
                        _currentLocation != null) {
                      _requestRoutes();
                    }
                    popDialog(context);
                  }),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _requestRoutes() async {
    final PlacemarkMapObject startPlacemark = PlacemarkMapObject(
      mapId: const MapObjectId('start_placemark'),
      point: _currentLocation!,
      icon: PlacemarkIcon.single(PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('ic_marker'.pngIcon),
          scale: 1)),
    );
    final PlacemarkMapObject endPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('end_placemark'),
        point: _destinationPoint!,
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('ic_marker'.pngIcon),
            scale: 1)));
    _mapObjects = [startPlacemark, endPlacemark];
    var resultWithSession = await YandexDriving.requestRoutes(
        points: [
          RequestPoint(
              point: _currentLocation!,
              requestPointType: RequestPointType.wayPoint),
          RequestPoint(
              point: _destinationPoint!,
              requestPointType: RequestPointType.wayPoint),
        ],
        drivingOptions: const DrivingOptions(
            initialAzimuth: 0, routesCount: 5, avoidTolls: true));
    final result = await resultWithSession.result;
    _handleResult(result);
  }

  Future<void> _handleResult(DrivingSessionResult result) async {
    // setState(() {
    //   _progress = false;
    // });

    if (result.error != null) {
      print('Error: ${result.error}');
      return;
    }

    setState(() {
      result.routes!.asMap().forEach((i, route) {
        _mapObjects.add(PolylineMapObject(
          mapId: MapObjectId('route_${i}_polyline'),
          polyline: Polyline(points: route.geometry),
          strokeColor:
          Colors.primaries[Random().nextInt(Colors.primaries.length)],
          strokeWidth: 3,
        ));
      });
    });
  }

  Widget getList({required Function(SuggestItem item) onTap}) {
    return ListView.separated(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  onTap(suggests[index]);
                },
                title: Text(
                  suggests[index].title,
                  style: pmedium,
                ),
                subtitle: Text(
                  suggests[index].subtitle ?? "",
                  style: pregular,
                ),
              ),
              Divider()
            ],
          ),
        );
      },
      separatorBuilder: (_, __) {
        return SizedBox(height: 8); // Vertical gap
      },
      itemCount: suggests.length,
    );
  }

  IsarHelper isarHelper = IsarHelper();

  void addDriveHistory() async {
    final from = await getLocationDetails(_currentLocation!);
    final to = await getLocationDetails(_destinationPoint!);

    await isarHelper.addHistory(
        HistoryModel(from: from, to: to, time: DateTime.now()).toEntity());
    _currentLocation = null;
    _destinationPoint = null;
    _mapObjects.clear();
    isDriving = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onObjectTap: (value) {
              _currentLocation = value.geometry.first.point;
            },
            onMapCreated: (YandexMapController controller) {
              _controller = controller;
              _controller.moveCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(
                    target: Point(
                        latitude: 41.311159247028804,
                        longitude: 69.2796892595276),
                    zoom: 14,
                  ),
                ),
              );
            },
            mapObjects: _mapObjects,
            onMapTap: (Point point) async {
              _currentLocation = point;
              if (_destinationPoint != null) {
                _requestRoutes();
              }
              _updateMarkerAndInfo(point);
            },
          ),
          if (_travelTime != null)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: Text(_travelTime!),
              ),
            ),
          Positioned(
            top: 42,
            right: 16,
            child: primaryFloatingActionButton(
                context: context,
                onPressed: () {
                  pushScreen(context, AppRoutes.historyScreen);
                },
                child: Icon(Icons.history)),
          ),
          isDriving
              ? UnderSaveButton(
            onPressed: () async {
              addDriveHistory();
            },
            title: "Finish Drive",
          )
              : PrimaryUnderWidget(
            onFinishTap: () {
              isDriving = true;
              setState(() {});
            },
            onFinishPlaceTap: () {
              openBottomSheet(PlaceType.end);
            },
            isEnable:
            _currentLocation != null && _destinationPoint != null,
            onStartPlaceTap: () {
              openBottomSheet(PlaceType.start);
            },
            startPoint: _currentLocation,
            endPoint: _destinationPoint,
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // primaryFloatingActionButton(
          //   context: context,
          //   onPressed: _zoomIn,
          //   child: const Icon(Icons.add, color: Colors.white),
          // ),
          // 8.verticalSpace,
          // primaryFloatingActionButton(
          //   context: context,
          //   onPressed: _zoomOut,
          //   child: const Icon(Icons.remove, color: Colors.white),
          // ),
          // 56.verticalSpace,
          isDriving
              ? SizedBox.shrink()
              : primaryFloatingActionButton(
            onPressed: _checkPermissionAndLocateUser,
            context: context,
            child: const Icon(Icons.my_location, color: Colors.black),
          ),
          isDriving ? 156.verticalSpace : 234.verticalSpace
        ],
      ),
    );
  }
}
