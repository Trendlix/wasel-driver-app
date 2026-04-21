import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wasel_driver/apps/core/network/local/local_storage_service.dart';

class PermissionService {
  PermissionService._();

  /// Request location permission — and immediately fetch + save coordinates
  static Future<PermissionStatus> requestLocation() async {
    final status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      await _fetchAndSaveLocation();
    }

    return status;
  }

  /// Fetch current position and persist to SharedPreferences
  static Future<void> _fetchAndSaveLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final prefs = GetIt.instance<LocalStorageService>();
      await prefs.saveLat(position.latitude);
      await prefs.saveLong(position.longitude);
    } catch (e) {
      // Position fetch failed — silently ignore, permission is still granted
      debugPrint('Location fetch failed: $e');
    }
  }

  /// Read saved lat/lng anywhere in the app — returns null if not yet saved
  static Future<({double lat, double lng})?> getSavedLocation() async {
    final prefs = GetIt.instance<LocalStorageService>();
    final lat = await prefs.getLat();
    final lng = await prefs.getLong();
    if (lat == null || lng == null) return null;
    return (lat: double.parse(lat), lng: double.parse(lng));
  }

  /// Request notification permission
  static Future<PermissionStatus> requestNotification() =>
      Permission.notification.request();

  /// Request camera permission
  static Future<PermissionStatus> requestCamera() =>
      Permission.camera.request();

  /// Request all at once
  static Future<Map<Permission, PermissionStatus>> requestAll() async {
    return await [
      Permission.locationWhenInUse,
      Permission.notification,
      Permission.camera,
    ].request();
  }

  /// Check without prompting
  static Future<PermissionStatus> check(Permission permission) =>
      permission.status;

  /// Open app settings if permanently denied
  static Future<void> openSettings() => openAppSettings();
}
