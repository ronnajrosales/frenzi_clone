import 'package:drift/drift.dart';

import '../data/database/database.dart';
import '../models/trip_model.dart';
import '../services/api_service.dart';
import '../utils/exceptions.dart';

class TripRepository {
  final AppDatabase _db;
  final ApiService _apiService;

  TripRepository(this._db, this._apiService);

  Future<List<Trip>> getAllTrips() => _db.getAllTrips();
  Stream<List<Trip>> watchAllTrips() => _db.watchAllTrips();
  Future<Trip> getTripById(int id) => _db.getTripById(id);

  Future<int> createTrip({
    required String pickupLocation,
    required String destination,
    required double pickupLatitude,
    required double pickupLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    required DateTime tripDate,
    required int passengerCount,
    required double fare,
  }) {
    return _db.insertTrip(
      TripsCompanion.insert(
        pickupLocation: pickupLocation,
        destination: destination,
        pickupLatitude: pickupLatitude,
        pickupLongitude: pickupLongitude,
        destinationLatitude: destinationLatitude,
        destinationLongitude: destinationLongitude,
        tripDate: tripDate,
        passengerCount: passengerCount,
        fare: fare, tripTime: '9:00',
      ),
    );
  }

  Future<bool> updateTrip(Trip trip) => _db.updateTrip(trip);
  Future<int> deleteTrip(int id) => _db.deleteTrip(id);

  Future<List<TripModel>> getTrips() async {
    try {
      return await _apiService.getTrips();
    } catch (e) {
      throw ApiException('Failed to fetch trips: $e');
    }
  }


}