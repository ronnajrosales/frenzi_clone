import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/database.dart';
import '../data/repositories/trip_repository.dart';
import '../models/trip_model.dart';
import '../services/api_service.dart';
import '../services/mock_api_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.getInstance();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final mockApiServiceProvider = Provider<MockApiService>((ref) {
  return MockApiService();
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return TripRepository(database);
});

final allTripsProvider = StreamProvider<List<Trip>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchAllTrips();
});

final tripsProvider = FutureProvider<List<TripModel>>((ref) async {
  final apiService = ref.watch(mockApiServiceProvider);
  return apiService.getTrips();
});

final tripProvider = FutureProvider.family<TripModel, String>((ref, id) async {
  final apiService = ref.watch(mockApiServiceProvider);
  return apiService.getTripById(id);
});

final localTripsProvider = StreamProvider<List<Trip>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.select(database.trips).watch();
});
