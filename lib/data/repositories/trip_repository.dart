import 'package:drift/drift.dart';
import '../database/database.dart';

class TripRepository {
  final AppDatabase _database;

  TripRepository(this._database);

  // Get all trips
  Future<List<Trip>> getAllTrips() => _database.getAllTrips();

  // Watch all trips (reactive)
  Stream<List<Trip>> watchAllTrips() => _database.watchAllTrips();

  // Get trip by id
  Future<Trip> getTripById(int id) => _database.getTripById(id);

  // Add new trip
  Future<int> addTrip({
    required String pickupLocation,
    required double pickupLatitude,
    required double pickupLongitude,
    required String destination,
    required double destinationLatitude,
    required double destinationLongitude,
    required DateTime tripDate,
    required String tripTime,
    required int passengerCount,
    required double fare,
    String status = 'pending',
  }) {
    return _database.insertTrip(
      TripsCompanion(
        pickupLocation: Value(pickupLocation),
        pickupLatitude: Value(pickupLatitude),
        pickupLongitude: Value(pickupLongitude),
        destination: Value(destination),
        destinationLatitude: Value(destinationLatitude),
        destinationLongitude: Value(destinationLongitude),
        tripDate: Value(tripDate),
        tripTime: Value(tripTime),
        passengerCount: Value(passengerCount),
        fare: Value(fare),
        status: Value(status),
      ),
    );
  }

  // Update trip
  Future<bool> updateTrip(Trip trip) => _database.updateTrip(trip);

  // Delete trip
  Future<int> deleteTrip(int id) => _database.deleteTrip(id);

  // // Get total fares
  // Future<double> getTotalFares() => _database.getTotalFares();

  // // Get trips within fare range
  // Future<List<Trip>> getTripsInFareRange(double minFare, double maxFare) =>
  //     _database.getTripsInFareRange(minFare, maxFare);

  // Get trips by status
  Future<List<Trip>> getTripsByStatus(String status) =>
      _database.getTripsByStatus(status);

  // // New method to find trips near a location
  // Future<List<Trip>> findTripsNearLocation(
  //   double latitude,
  //   double longitude,
  //   double radiusKm,
  // ) {
  //   return _database.getTripsNearLocation(latitude, longitude, radiusKm);
  // }
} 