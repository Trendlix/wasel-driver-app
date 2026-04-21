import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _currentPosition;
  String _addressName = "Locating you...";
  bool _isLoading = true;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng initialLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = initialLatLng;
      _isLoading = false;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(initialLatLng, 16),
    );

    _getAddressName(initialLatLng);
  }

  Future<void> _getAddressName(LatLng pos) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _addressName =
              "${place.street ?? ''} ${place.subLocality ?? place.locality ?? ''}";
        });
      }
    } catch (e) {
      setState(() => _addressName = "Unknown Location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _addressName,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: () => Navigator.pop(context, _addressName),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 16,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onTap: (newLatLng) {
                setState(() => _currentPosition = newLatLng);
                _getAddressName(newLatLng);
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(newLatLng),
                );
              },
              markers: {
                Marker(
                  markerId: const MarkerId("selected"),
                  position: _currentPosition!,
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
