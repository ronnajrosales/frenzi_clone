import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/trip_model.dart';
import '../utils/exceptions.dart';

class ApiService {
  static const String baseUrl = 'YOUR_API_BASE_URL'; // Replace with your API URL
  static const String apiKey = 'YOUR_API_KEY'; // Replace with your API key

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  
  factory ApiService() {
    return _instance;
  }
  
  ApiService._internal();

  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  // Get trips from API
  Future<List<TripModel>> getTrips() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trips'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TripModel.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load trips: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // Get single trip by ID
  Future<TripModel> getTripById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trips/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TripModel.fromJson(data);
      } else {
        throw ApiException('Failed to load trip: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // Create new trip
  Future<TripModel> createTrip(TripModel trip) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trips'),
        headers: _headers,
        body: json.encode(trip.toJson()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return TripModel.fromJson(data);
      } else {
        throw ApiException('Failed to create trip: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
} 