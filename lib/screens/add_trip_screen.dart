import 'package:flutter/material.dart';
import 'dart:math';
import '../data/repositories/trip_repository.dart';

class AddTripScreen extends StatefulWidget {
  final TripRepository tripRepository;

  const AddTripScreen({super.key, required this.tripRepository});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  
  // Add location coordinates
  double _pickupLatitude = 0.0;
  double _pickupLongitude = 0.0;
  double _destinationLatitude = 0.0;
  double _destinationLongitude = 0.0;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _passengers = 1;
  double _fare = 0.0;

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
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

  // Add method to calculate fare based on distance
  double _calculateFare(double pickupLat, double pickupLng, 
                       double destLat, double destLng) {
    // This is a simple example - you should implement your own fare calculation logic
    const baseRate = 50.0; // Base fare
    const ratePerKm = 15.0; // Rate per kilometer
    
    // Calculate distance using Haversine formula
    final distance = calculateDistance(pickupLat, pickupLng, destLat, destLng);
    
    return baseRate + (distance * ratePerKm);
  }

  Future<void> _bookTrip() async {
    try {
      // Calculate fare based on locations
      _fare = _calculateFare(
        _pickupLatitude,
        _pickupLongitude,
        _destinationLatitude,
        _destinationLongitude,
      );

      await widget.tripRepository.addTrip(
        pickupLocation: _pickupController.text,
        pickupLatitude: _pickupLatitude,
        pickupLongitude: _pickupLongitude,
        destination: _destinationController.text,
        destinationLatitude: _destinationLatitude,
        destinationLongitude: _destinationLongitude,
        tripDate: _selectedDate,
        tripTime: _selectedTime.format(context),
        passengerCount: _passengers,
        fare: _fare,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Trip booked successfully! Fare: ₱${_fare.toStringAsFixed(2)}'),
          ),
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

  // Helper method to calculate distance between two points
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Implement the Haversine formula to calculate distance between coordinates
    // This is a simplified version - you should implement proper distance calculation
    const R = 6371.0; // Earth's radius in kilometers
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEE4B8E), // Pink color
              Color(0xFFEF7154), // Orange color
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'New Trip',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Location details card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                        color: const Color(0xFF1A237E),
                      ),
                      const SizedBox(height: 16),
                      _buildLocationField(
                        controller: _destinationController,
                        icon: Icons.place,
                        title: 'DESTINATION',
                        hint: 'Enter destination',
                        color: const Color(0xFF1A237E),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Map placeholder
                Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: const ColoredBox(
                      color: Color(0xFFE0E0E0),
                      child: Center(
                        child: Text(
                          'Map View',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Trip details card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: _buildTripDetail(
                              icon: Icons.calendar_today,
                              value: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectTime(context),
                            child: _buildTripDetail(
                              icon: Icons.access_time,
                              value: _selectedTime.format(context),
                            ),
                          ),
                          Column(
                            children: [
                              const Icon(
                                Icons.people,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (_passengers > 1) {
                                        setState(() => _passengers--);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    _passengers.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() => _passengers++);
                                    },
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Book button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      ),
                      child: const Text(
                        'BOOK TRIP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
    required String title,
    required String hint,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTripDetail({
    required IconData icon,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 