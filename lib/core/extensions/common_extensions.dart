import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_it/get_it.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

T inject<T extends Object>() => GetIt.I.get<T>();

Future<T> injectAsync<T extends Object>() async => GetIt.I.getAsync<T>();

extension ContextExtensions on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
}

extension AssetExtension on String {
  String get pngIcon => 'assets/icons/$this.png';

  String get pngImage => 'assets/images/$this.png';

  String get svgImage => 'assets/images/$this.svg';

  String get svgIcon => 'assets/vectors/$this.svg';
}

extension StringExtensions on String {
  bool isImageUrl() {
    return startsWith('http://') || startsWith('https://');
  }

  bool isFilePath() {
    return startsWith('/') || startsWith(RegExp(r'^[a-zA-Z]:\\'));
  }
}

Future<String> getLocationDetails(Point position) async {
  try {
    // 2. Koordinatalarni manzilga aylantirish
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      String administrativeArea = place.administrativeArea ?? "";
      String locality = place.locality ?? '';
      String name = place.name ?? 'Unnamed place';

      return '$administrativeArea, $locality, $name';
    } else {
      return 'Manzil topilmadi';
    }
  } catch (e) {
    return 'Xatolik yuz berdi: $e';
  }
}
