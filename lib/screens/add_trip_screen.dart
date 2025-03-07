import 'package:flutter/material.dart';
import 'dart:math';
import '../data/repositories/trip_repository.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../utils/text_styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/custom_back_button.dart';


class AddTripScreen extends ConsumerStatefulWidget {
  const AddTripScreen({super.key});

  @override
  ConsumerState<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends ConsumerState<AddTripScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _passengerCount = 1;
  double _pickupLatitude = 0.0;
  double _pickupLongitude = 0.0;
  double _destinationLatitude = 0.0;
  double _destinationLongitude = 0.0;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  String _distance = '';
  String _duration = '';

  @override
  void initState() {
    super.initState();
    // No need to set default location anymore
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _bookTrip() async {
    if (_pickupController.text.isEmpty || _destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter pickup and destination locations')),
      );
      return;
    }

    try {
      final tripRepository = ref.read(tripRepositoryProvider);
      final fare = 50.0 + (_passengerCount * 10.0);

      await tripRepository.addTrip(
        pickupLocation: _pickupController.text,
        pickupLatitude: _pickupLatitude,
        pickupLongitude: _pickupLongitude,
        destination: _destinationController.text,
        destinationLatitude: _destinationLatitude,
        destinationLongitude: _destinationLongitude,
        tripDate: _selectedDate,
        tripTime: _selectedTime.format(context),
        passengerCount: _passengerCount,
        fare: fare,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip booked successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error booking trip: $e')),
        );
      }
    }
  }

  Future<void> _getRouteAndDrawPolyline() async {
    if (_pickupLatitude == 0.0 || _destinationLatitude == 0.0) return;

    try {
      final String url = 
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=$_pickupLatitude,$_pickupLongitude'
        '&destination=$_destinationLatitude,$_destinationLongitude'
        '&mode=driving'
        '&key=AIzaSyAlm9aA_rmQ2Wz5TEh9AtBY_5E3M3w5lkY';

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          // Get route points
          final points = data['routes'][0]['overview_polyline']['points'];
          
          // Get distance and duration
          _distance = data['routes'][0]['legs'][0]['distance']['text'];
          _duration = data['routes'][0]['legs'][0]['duration']['text'];

          // Decode polyline points
          _polylineCoordinates = _decodePolyline(points);

          setState(() {
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: const Color(0xFF1A237E),
                points: _polylineCoordinates,
                width: 4,
              ),
            );
          });

          // Update camera to show entire route
          if (_mapController != null && _polylineCoordinates.isNotEmpty) {
            LatLngBounds bounds = _getBoundsForPolyline(_polylineCoordinates);
            await _mapController!.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 50),
            );
          }
        } else {
          print('Directions API error: ${data['status']}');
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }
    return points;
  }

  LatLngBounds _getBoundsForPolyline(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;

    for (LatLng point in points) {
      if (minLat == null || point.latitude < minLat) {
        minLat = point.latitude;
      }
      if (maxLat == null || point.latitude > maxLat) {
        maxLat = point.latitude;
      }
      if (minLng == null || point.longitude < minLng) {
        minLng = point.longitude;
      }
      if (maxLng == null || point.longitude > maxLng) {
        maxLng = point.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat! - 0.01, minLng! - 0.01),
      northeast: LatLng(maxLat! + 0.01, maxLng! + 0.01),
    );
  }

  void _updateMapMarkers() async {
    setState(() {
      _markers.clear();
      
      // Add pickup marker
      if (_pickupLatitude != 0.0 && _pickupLongitude != 0.0) {
        _markers.add(
          Marker(
            markerId: const MarkerId('pickup'),
            position: LatLng(_pickupLatitude, _pickupLongitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(title: 'Pickup', snippet: _pickupController.text),
          ),
        );
      }

      // Add destination marker
      if (_destinationLatitude != 0.0 && _destinationLongitude != 0.0) {
        _markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(_destinationLatitude, _destinationLongitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(title: 'Destination', snippet: _destinationController.text),
          ),
        );
      }
    });

    // Get and draw route if both markers are set
    if (_markers.length == 2) {
      await _getRouteAndDrawPolyline();
    } else {
      setState(() {
        _polylines.clear();
        _distance = '';
        _duration = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFE8C6F),
            Color(0xFFFF6B81),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CustomBackButton(),
                      const SizedBox(width: 8),
              
                    ],
                  ),
                ),

                 Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: 
                  
                      const Text(
                        'New Trip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                 ),

                // Location Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildLocationField(
                        controller: _pickupController,
                        icon: Icons.radio_button_checked,
                        title: 'PICKUP',
                        hint: 'Enter pickup location',
                        isPickup: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLocationField(
                        controller: _destinationController,
                        icon: Icons.place,
                        title: 'DESTINATION',
                        hint: 'Enter destination',
                        isPickup: false,
                      ),
                    ],
                  ),
                ),

                // Map Placeholder
                Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(51.5074, -0.1278), // London coordinates
                            zoom: 12,
                          ),
                          markers: _markers,
                          polylines: _polylines,
                          onMapCreated: (controller) {
                            _mapController = controller;
                            if (_markers.isNotEmpty) {
                              _updateMapMarkers();
                            }
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          mapToolbarEnabled: false,
                        ),
                        if (_distance.isNotEmpty && _duration.isNotEmpty)
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.directions_car, size: 18, color: Color(0xFF1A237E)),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$_distance • $_duration',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Trip Details Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailItem(
                        icon: Icons.calendar_today,
                        title: 'Date',
                        value: '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailItem(
                        icon: Icons.access_time,
                        title: 'Time',
                        value: _selectedTime.format(context),
                        onTap: () => _selectTime(context),
                      ),
                      const SizedBox(height: 16),
                      _buildPassengerCount(),
                    ],
                  ),
                ),

                // Book Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _bookTrip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'BOOK TRIP',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required IconData icon,
    required String title,
    required String hint,
    required bool isPickup,
  }) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      googleAPIKey: "AIzaSyAlm9aA_rmQ2Wz5TEh9AtBY_5E3M3w5lkY",
      inputDecoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
        labelText: title,
        labelStyle: AppTextStyles.caption.copyWith(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
        ),
        hintText: hint,
        hintStyle: AppTextStyles.body2.copyWith(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1A237E)),
        ),
      ),
      debounceTime: 800,
      countries: const ["uk"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        setState(() {
          if (isPickup) {
            _pickupLatitude = double.parse(prediction.lat ?? "0");
            _pickupLongitude = double.parse(prediction.lng ?? "0");
          } else {
            _destinationLatitude = double.parse(prediction.lat ?? "0");
            _destinationLongitude = double.parse(prediction.lng ?? "0");
          }
        });
        _updateMapMarkers();
      },
      itemClick: (Prediction prediction) {
        controller.text = prediction.description ?? "";
      },
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.body1.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerCount() {
    return Row(
      children: [
        const Icon(Icons.person, color: Colors.white),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PASSENGERS',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      if (_passengerCount > 1) {
                        setState(() => _passengerCount--);
                      }
                    },
                  ),
                  Text(
                    '$_passengerCount',
                    style: AppTextStyles.body1.copyWith(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      setState(() => _passengerCount++);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
} 