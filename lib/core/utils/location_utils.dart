import 'dart:io' show Platform;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationUtils {
  /// Request and check location permission
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  /// Show dialog if user denied permission
  static Future<void> showLocationDeniedDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder:
          (context) =>
              Platform.isIOS
                  ? CupertinoAlertDialog(
                    title: const Text('Location Permission Required'),
                    content: const Text(
                      'Please enable location access in settings to use this feature',
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoDialogAction(
                        child: const Text('Settings'),
                        onPressed: () {
                          Navigator.pop(context);
                          AppSettings.openAppSettings();
                        },
                      ),
                    ],
                  )
                  : AlertDialog(
                    title: const Text('Location Permission Required'),
                    content: const Text(
                      'Please enable location access in settings to use this feature',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          AppSettings.openAppSettings();
                        },
                        child: const Text('Settings'),
                      ),
                    ],
                  ),
    );
  }

  /// Safely get current position
  static Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  /// Get formatted coordinates like "28.61,77.20"
  static Future<String?> getFormattedLocation() async {
    final position = await getCurrentPosition();
    return position != null
        ? "${position.latitude},${position.longitude}"
        : null;
  }

  static Future<void> ensureLocationServiceEnabled(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // On Android: can open system location settings
      if (Platform.isAndroid) {
        await Geolocator.openLocationSettings();
      } else if (Platform.isIOS) {
        // On iOS, can only show guidance, cannot open GPS settings directly
        await showDialog(
          context: context,
          builder:
              (context) => CupertinoAlertDialog(
                title: const Text('Enable Location Services'),
                content: const Text(
                  'Please enable Location Services from Settings > Privacy > Location Services.',
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
        );
      }
    }
  }

  static Future<String?> getReadableLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? place.subAdministrativeArea ?? '';
        final country = place.country ?? '';
        return [city, country].where((e) => e.isNotEmpty).join(', ');
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
