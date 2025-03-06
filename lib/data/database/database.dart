import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Trips extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pickupLocation => text()();
  RealColumn get pickupLatitude => real()();
  RealColumn get pickupLongitude => real()();
  TextColumn get destination => text()();
  RealColumn get destinationLatitude => real()();
  RealColumn get destinationLongitude => real()();
  DateTimeColumn get tripDate => dateTime()();
  TextColumn get tripTime => text()();
  IntColumn get passengerCount => integer()();
  RealColumn get fare => real()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
}

@DriftDatabase(tables: [Trips])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());
  static AppDatabase? _instance;

  static AppDatabase getInstance() {
    _instance ??= AppDatabase._();
    return _instance!;
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Add new location columns
        await m.addColumn(trips, trips.pickupLatitude);
        await m.addColumn(trips, trips.pickupLongitude);
        await m.addColumn(trips, trips.destinationLatitude);
        await m.addColumn(trips, trips.destinationLongitude);
      }
      if (from < 3) {
        // Add fare column
        await m.addColumn(trips, trips.fare);
      }
    },
  );

  // CRUD operations for trips
  Future<List<Trip>> getAllTrips() => select(trips).get();
  
  Future<Trip> getTripById(int id) =>
      (select(trips)..where((t) => t.id.equals(id))).getSingle();
  
  Future<int> insertTrip(TripsCompanion trip) => into(trips).insert(trip);
  
  Future<bool> updateTrip(Trip trip) => update(trips).replace(trip);
  
  Future<int> deleteTrip(int id) =>
      (delete(trips)..where((t) => t.id.equals(id))).go();

  // Get trips by status
  Future<List<Trip>> getTripsByStatus(String status) =>
      (select(trips)..where((t) => t.status.equals(status))).get();

  Stream<List<Trip>> watchAllTrips() => select(trips).watch();

  // // Get total fares for completed trips
  // Future<double> getTotalFares() async {
  //   final query = select(trips)
  //     ..where((t) => t.status.equals('completed'));
    
  //   final completedTrips = await query.get();
  //   return completedTrips.fold<double>(
  //     0,
  //     (sum, trip) => sum + trip.fare,
  //   );
  // }

  // // Get trips within fare range
  // Future<List<Trip>> getTripsInFareRange(double minFare, double maxFare) =>
  //     (select(trips)
  //       ..where((t) => t.fare.isBetweenValues(minFare, maxFare)))
  //     .get();

  // // Get trips near location (simplified version)
  // Future<List<Trip>> getTripsNearLocation(
  //   double latitude,
  //   double longitude,
  //   double radiusKm,
  // ) async {
  //   // For now, return all trips - implement proper distance filtering if needed
  //   return getAllTrips();
  // }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'trips.sqlite'));
    return NativeDatabase(file);
  });
} 