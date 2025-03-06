import 'package:flutter/material.dart';
import '../data/database/database.dart';
import '../data/repositories/trip_repository.dart';

class TripInfoScreen extends StatelessWidget {
  final TripRepository tripRepository;
  final int tripId;

  const TripInfoScreen({
    super.key,
    required this.tripRepository,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8A80), Color(0xFFFF5252)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FutureBuilder<Trip>(
            future: tripRepository.getTripById(tripId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              final trip = snapshot.data!;

              return SingleChildScrollView(
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
                            'Trip Details',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
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
                          _buildLocationItem(
                            icon: Icons.radio_button_checked,
                            title: 'PICKUP',
                            location: trip.pickupLocation,
                            color: const Color(0xFF1A237E),
                          ),
                          const SizedBox(height: 16),
                          _buildLocationItem(
                            icon: Icons.place,
                            title: 'DESTINATION',
                            location: trip.destination,
                            color: const Color(0xFF1A237E),
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
                            value: _formatDate(trip.tripDate),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailItem(
                            icon: Icons.access_time,
                            title: 'Time',
                            value: trip.tripTime,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailItem(
                            icon: Icons.person,
                            title: 'Passengers',
                            value: '${trip.passengerCount}',
                          ),
                          const SizedBox(height: 16),
                          _buildDetailItem(
                            icon: Icons.payment,
                            title: 'Fare',
                            value: '₱${trip.fare.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 16),
                          _buildDetailItem(
                            icon: Icons.info_outline,
                            title: 'Status',
                            value: trip.status.toUpperCase(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLocationItem({
    required IconData icon,
    required String title,
    required String location,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                location,
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

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
} 