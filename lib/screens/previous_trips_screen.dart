import 'package:flutter/material.dart';
import '../data/database/database.dart';
import '../providers/providers.dart';
import '../widgets/custom_back_button.dart';
import 'trip_info_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../utils/preferences_helper.dart';

class PreviousTripsScreen extends ConsumerStatefulWidget {
  const PreviousTripsScreen({Key? key}) : super(key: key);

  @override
  _PreviousTripsScreenState createState() => _PreviousTripsScreenState();
}

class _PreviousTripsScreenState extends ConsumerState<PreviousTripsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initScreen();
  }

  Future<void> _initScreen() async {
    final count = await PreferencesHelper.incrementPreviousTripsOpenCount();
    print('Previous Trips screen opened $count times'); // Debug print

    if (count % 3 == 0) {
      _showErrorDialog("Something went wrong. Please try again.");
    } else {
      _loadWithDelay();
      if (count == 1) {
        // only load the mock data if fresh install
        _fetchAndSaveTrips();
      }
    }
  }

  Future<void> _loadWithDelay() async {
    try {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      _showErrorDialog('Failed to load trips');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchAndSaveTrips() async {
    try {
      setState(() => _isLoading = true);

      // Get trips from mock API
      final mockApi = ref.read(mockApiServiceProvider);
      final apiTrips = await mockApi.getTrips();

      // Save to local database
      final database = ref.read(databaseProvider);
      await database.transaction(() async {
        // Clear existing trips
        await database.delete(database.trips).go();

        // Insert new trips
        for (final trip in apiTrips) {
          await database.into(database.trips).insert(
                TripsCompanion.insert(
                  pickupLocation: trip.pickupLocation,
                  destination: trip.destination,
                  pickupLatitude: trip.pickupLatitude,
                  pickupLongitude: trip.pickupLongitude,
                  destinationLatitude: trip.destinationLatitude,
                  destinationLongitude: trip.destinationLongitude,
                  tripDate: trip.tripDate,
                  tripTime: '12:00',
                  passengerCount: trip.passengerCount,
                  fare: trip.fare,
                ),
              );
        }
      });

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching and saving trips: $e');
      if (mounted) {
        _showErrorDialog('Failed to load trips');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _fetchAndSaveTrips(); // Retry loading
            },
            child: const Text('RETRY'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(localTripsProvider);

    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const CustomBackButton(text: 'Home',),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Title and subtitle
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trips List',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap any trip to view details and book again',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Trips list
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                    child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : trips.when(
                          data: (tripsList) => RefreshIndicator(
                            onRefresh: _fetchAndSaveTrips,
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              itemCount: tripsList.length,
                              itemBuilder: (context, index) {
                                final trip = tripsList[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TripInfoScreen(
                                              tripId: trip.id,
                                            ),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    trip.destination
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'From ${trip.pickupLocation}',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  DateFormat('d MMMM yyyy')
                                                      .format(trip.tripDate),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'TRIP INFO',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                          error: (error, stack) => Center(
                            child: Text(
                              'Error: $error',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
