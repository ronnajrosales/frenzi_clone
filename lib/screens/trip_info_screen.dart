import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/database/database.dart';
import '../data/repositories/trip_repository.dart';
import '../main.dart';
import '../utils/text_styles.dart';
import '../widgets/custom_back_button.dart';
import 'add_trip_screen.dart';


class TripInfoScreen extends ConsumerStatefulWidget {
  final int tripId;

  const TripInfoScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<TripInfoScreen> createState() => _TripInfoScreenState();
}

class _TripInfoScreenState extends ConsumerState<TripInfoScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  String _distance = '';
  String _duration = '';
  bool _isPolylineLoaded = false;
  Trip? _trip;

  @override
  void initState() {
    super.initState();
    _loadTripData();
  }

  Future<void> _loadTripData() async {
    try {
      final trip = await ref.read(tripRepositoryProvider).getTripById(
          widget.tripId);
      if (mounted) {
        setState(() {
          _trip = trip;
        });
        _updateMapWithTrip(trip);
      }
    } catch (e) {
      print('Error loading trip: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load trip details')),
        );
      }
    }
  }

  Future<void> _getRouteAndDrawPolyline(Trip trip) async {
    if (_isPolylineLoaded) return;

    try {
      final origin = '${trip.pickupLatitude},${trip.pickupLongitude}';
      final destination = '${trip.destinationLatitude},${trip
          .destinationLongitude}';
      final apiKey = 'AIzaSyAlm9aA_rmQ2Wz5TEh9AtBY_5E3M3w5lkY'; // Replace with your API key

      print('Fetching route from: $origin to: $destination'); // Debug print

      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response: $data'); // Debug print

        if (data['status'] == 'OK' && mounted) {
          final routes = data['routes'] as List;
          if (routes.isEmpty) {
            print('No routes found');
            return;
          }

          final route = routes[0] as Map<String, dynamic>;
          final legs = route['legs'] as List;
          if (legs.isEmpty) {
            print('No legs found');
            return;
          }

          final leg = legs[0] as Map<String, dynamic>;
          final overviewPolyline = route['overview_polyline'] as Map<
              String,
              dynamic>;
          final points = overviewPolyline['points'] as String;

          print('Encoded polyline: $points'); // Debug print

          // Create a simple polyline for testing
          final List<LatLng> simplePolyline = [
            LatLng(trip.pickupLatitude, trip.pickupLongitude),
            LatLng(trip.destinationLatitude, trip.destinationLongitude),
          ];

          setState(() {
            _distance = leg['distance']['text'] as String;
            _duration = leg['duration']['text'] as String;

            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: const Color(0xFF1A237E),
                width: 4,
                points: simplePolyline,
              ),
            );
            _isPolylineLoaded = true;
          });

          // Update camera to show both markers
          if (_mapController != null) {
            final bounds = LatLngBounds(
              southwest: LatLng(
                min(trip.pickupLatitude, trip.destinationLatitude),
                min(trip.pickupLongitude, trip.destinationLongitude),
              ),
              northeast: LatLng(
                max(trip.pickupLatitude, trip.destinationLatitude),
                max(trip.pickupLongitude, trip.destinationLongitude),
              ),
            );

            await _mapController!.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 50),
            );
          }
        } else {
          print('API Error: ${data['status']}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Route error: ${data['status']}')),
            );
          }
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Network error: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load route')),
        );
      }
    }
  }

  // Add these helper functions
  double min(double a, double b) => a < b ? a : b;

  double max(double a, double b) => a > b ? a : b;

  void _updateMapWithTrip(Trip trip) {
    if (_mapController == null) return;

    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('pickup'),
          position: LatLng(trip.pickupLatitude, trip.pickupLongitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Pickup', snippet: trip.pickupLocation),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(trip.destinationLatitude, trip.destinationLongitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
              title: 'Destination', snippet: trip.destination),
        ),
      };
    });

    if (!_isPolylineLoaded) {
      _getRouteAndDrawPolyline(trip);
    }
  }

  Widget _buildLocationCard(Trip trip) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Pickup Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.near_me,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PICKUP',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF1A237E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.pickupLocation,
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Destination Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.place,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DESTINATION',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF1A237E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.destination,
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetails(Trip trip) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Date
            Column(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  _formatDate(trip.tripDate),
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // Passengers
            Column(
              children: [
                const Icon(Icons.person, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  '${trip.passengerCount}',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // Fare
            Column(
              children: [
                const Icon(Icons.attach_money, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  '£${trip.fare.toStringAsFixed(2)}',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),

          ],
        ),
        // Book Again Button
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to AddTripScreen with pre-filled data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const AddTripScreen(

                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'BOOK AGAIN',
                    style: AppTextStyles.button,
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],)
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEE4B8E), // Pink color
            Color(0xFFEF7154), 
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _trip == null
              ? const Center(
              child: CircularProgressIndicator(color: Colors.white))
              : SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // Header
            Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CustomBackButton(),
                const SizedBox(width: 8),
              ],
          ),
        ),

        Padding(padding: const EdgeInsets.symmetric(horizontal: 16,
            vertical: 4), child: Text(
          _trip!.destination.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        ),
        const SizedBox(height: 16,),

        // Location Card
        _buildLocationCard(_trip!),
        const SizedBox(height: 16,),

        // Map container with error handling
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
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        _trip!.pickupLatitude, _trip!.pickupLongitude),
                    zoom: 12,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _updateMapWithTrip(_trip!);
                  },
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
                if (_distance.isNotEmpty && _duration.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
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
                          const Icon(
                            Icons.directions_car,
                            size: 18,
                            color: Color(0xFF1A237E),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_distance • $_duration',
                            style: AppTextStyles.body2,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8,),
        // Trip Details
        _buildTripDetails(_trip!),


        ],
      ),
    ),)
    ,
    )
    ,
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}