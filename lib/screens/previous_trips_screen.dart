import 'package:flutter/material.dart';
import '../providers/providers.dart';
import '../widgets/custom_back_button.dart';
import 'trip_info_screen.dart';
import '../data/repositories/trip_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../widgets/loading_dialog.dart';
import '../utils/dialog_helper.dart';
import '../widgets/error_dialog.dart';
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
      if (count%3 == 0) {
        _showErrorDialog("Something went wrong. Please try again.");
      } else {
        _loadWithDelay();
      }

  }

  // Optional: Add this method if you want to display the count somewhere
  Widget _buildOpenCountDebug() {
    return FutureBuilder<int>(
      future: PreferencesHelper.getPreviousTripsOpenCount(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Screen opened: ${snapshot.data} times',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
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

  void _showErrorDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: message,
            onRetry: () {
              _loadWithDelay(); // Retry loading
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allTrips = ref.watch(allTripsProvider);

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
                            const CustomBackButton(),
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : allTrips.when(
                        data: (trips) => trips.isEmpty
                            ? const Center(
                                child: Text(
                                  'No trips found',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                itemCount: trips.length,
                                itemBuilder: (context, index) {
                                  final trip = trips[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
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
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      trip.destination.toUpperCase(),
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
                                                        color: Colors.white.withOpacity(0.8),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    DateFormat('d MMMM yyyy').format(trip.tripDate),
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
                                                          fontWeight: FontWeight.bold,
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
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                        error: (error, stack) {
                          // Show error dialog when error occurs
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _showErrorDialog(error.toString());
                          });
                          return const Center(
                            child: Text(
                              'Loading failed',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 