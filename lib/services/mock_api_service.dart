import 'dart:async';
import 'dart:convert';
import '../data/sample_trips.dart';
import '../models/trip_model.dart';
import 'package:flutter/services.dart';

class MockApiService {
  // Simulate network delay
  static const _delay = Duration(seconds: 1);

  Future<List<TripModel>> getTrips() async {
    try {
      // Load JSON from asset
      final jsonString = await rootBundle.loadString('assets/data/sample_trips.json');
      final data = json.decode(jsonString);
      final List<dynamic> tripsJson = data['trips'] as List;
      return tripsJson.map((json) => TripModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load trips: $e');
    }
  }

  Future<TripModel> getTripById(String id) async {
    await Future.delayed(_delay);

    try {
      final List<dynamic> tripsJson = sampleTripsJson['trips'] as List;
      final tripJson = tripsJson.firstWhere(
        (trip) => trip['id'] == id,
        orElse: () => throw Exception('Trip not found'),
      );
      return TripModel.fromJson(tripJson);
    } catch (e) {
      throw Exception('Failed to load trip: $e');
    }
  }

  Future<TripModel> createTrip(TripModel trip) async {
    await Future.delayed(_delay);

    try {
      // Simulate creating a new trip
      return trip;
    } catch (e) {
      throw Exception('Failed to create trip: $e');
    }
  }
} 