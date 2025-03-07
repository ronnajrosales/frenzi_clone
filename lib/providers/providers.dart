import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/database.dart';
import '../data/repositories/trip_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.getInstance();
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return TripRepository(database);
});


final allTripsProvider = StreamProvider<List<Trip>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchAllTrips();
});
