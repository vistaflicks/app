import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as lo;
import 'package:permission_handler/permission_handler.dart';

import '../../const/app_constants.dart';
import '../../const/global_context_manager.dart';
import '../../widgets/common_dialogs.dart';

abstract class LocationHandler {
  static Position? currentPosition;

  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    lo.Location location = lo.Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled. Please enable the services
      await location.requestService();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied
        commonToaster('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, we cannot request permissions.
      showMessageDialog(
        globalContext!,
        'Location permissions are permanently denied, we cannot request permissions. open app setting to enable.',
        () {
          openAppSettings();
        },
      );
    }
    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      /// Fetch Location settings
      await getLocationSetting();

      /// Handle permission
      final hasPermission = await handleLocationPermission();
      if (!hasPermission) return null;

      /// Fetch Current Location
      await Geolocator.getCurrentPosition(locationSettings: locationSettings)
          .then((Position position) {
        currentPosition = position;
        showLog('currentPosition getCurrentPosition $currentPosition');
      }).catchError((e, s) {
        debugPrint('Error in Fetching Location ===> $e\n$s');
      });
      return currentPosition;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMarks[0];
      return '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
    } catch (e) {
      return null;
    }
  }

  /// get Location Setting
  static LocationSettings? locationSettings;

  static getLocationSetting() {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
        allowBackgroundLocationUpdates: true,
      );
    }
  }
}
