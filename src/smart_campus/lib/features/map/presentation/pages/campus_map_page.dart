/// ---------------------------------------------------------
/// صفحة خريطة الحرم - الأسبوع الرابع
/// المسؤولية: إظهار موقع المستخدم على الخريطة
/// مفهوم OS: Location Services + GPS
/// ---------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/utils/permissions.dart';

class CampusMapPage extends StatefulWidget {
  const CampusMapPage({super.key});

  @override
  State<CampusMapPage> createState() => _CampusMapPageState();
}

class _CampusMapPageState extends State<CampusMapPage> {
  Position? _currentPosition;
  bool _isLoading = false;

  /// جلب موقع المستخدم الحالي
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    final hasPermission = await PermissionManager.requestLocation();

    if (!hasPermission) {
      setState(() => _isLoading = false);
      _showPermissionDenied();
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showPermissionDenied() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text('Please allow access to location to show your position on campus map.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              PermissionManager.openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Map')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_currentPosition != null)
              Column(
                children: [
                  const Icon(Icons.location_on, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  Text(
                    'Your Position:',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('Latitude: ${_currentPosition!.latitude}'),
                  Text('Longitude: ${_currentPosition!.longitude}'),
                  const SizedBox(height: 16),
                  /// نقاط الاهتمام في الحرم (POIs)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildPOI('Library', 36.70, 3.17),
                        _buildPOI('Science Building', 36.71, 3.18),
                        _buildPOI('Cafeteria', 36.69, 3.16),
                      ],
                    ),
                  ),
                ],
              )
            else
              const Text('Press the button to get your location'),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Get My Location'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPOI(String name, double lat, double lng) {
    final distance = _currentPosition != null
        ? Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      lat,
      lng,
    ).toStringAsFixed(0)
        : '?';

    return ListTile(
      leading: const Icon(Icons.place, color: Colors.red),
      title: Text(name),
      subtitle: Text('$distance meters away'),
    );
  }
}