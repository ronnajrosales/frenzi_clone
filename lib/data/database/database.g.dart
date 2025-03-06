// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TripsTable extends Trips with TableInfo<$TripsTable, Trip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pickupLocationMeta =
      const VerificationMeta('pickupLocation');
  @override
  late final GeneratedColumn<String> pickupLocation = GeneratedColumn<String>(
      'pickup_location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pickupLatitudeMeta =
      const VerificationMeta('pickupLatitude');
  @override
  late final GeneratedColumn<double> pickupLatitude = GeneratedColumn<double>(
      'pickup_latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pickupLongitudeMeta =
      const VerificationMeta('pickupLongitude');
  @override
  late final GeneratedColumn<double> pickupLongitude = GeneratedColumn<double>(
      'pickup_longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _destinationMeta =
      const VerificationMeta('destination');
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
      'destination', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _destinationLatitudeMeta =
      const VerificationMeta('destinationLatitude');
  @override
  late final GeneratedColumn<double> destinationLatitude =
      GeneratedColumn<double>('destination_latitude', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _destinationLongitudeMeta =
      const VerificationMeta('destinationLongitude');
  @override
  late final GeneratedColumn<double> destinationLongitude =
      GeneratedColumn<double>('destination_longitude', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tripDateMeta =
      const VerificationMeta('tripDate');
  @override
  late final GeneratedColumn<DateTime> tripDate = GeneratedColumn<DateTime>(
      'trip_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _tripTimeMeta =
      const VerificationMeta('tripTime');
  @override
  late final GeneratedColumn<String> tripTime = GeneratedColumn<String>(
      'trip_time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passengerCountMeta =
      const VerificationMeta('passengerCount');
  @override
  late final GeneratedColumn<int> passengerCount = GeneratedColumn<int>(
      'passenger_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fareMeta = const VerificationMeta('fare');
  @override
  late final GeneratedColumn<double> fare = GeneratedColumn<double>(
      'fare', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pickupLocation,
        pickupLatitude,
        pickupLongitude,
        destination,
        destinationLatitude,
        destinationLongitude,
        tripDate,
        tripTime,
        passengerCount,
        fare,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(Insertable<Trip> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pickup_location')) {
      context.handle(
          _pickupLocationMeta,
          pickupLocation.isAcceptableOrUnknown(
              data['pickup_location']!, _pickupLocationMeta));
    } else if (isInserting) {
      context.missing(_pickupLocationMeta);
    }
    if (data.containsKey('pickup_latitude')) {
      context.handle(
          _pickupLatitudeMeta,
          pickupLatitude.isAcceptableOrUnknown(
              data['pickup_latitude']!, _pickupLatitudeMeta));
    } else if (isInserting) {
      context.missing(_pickupLatitudeMeta);
    }
    if (data.containsKey('pickup_longitude')) {
      context.handle(
          _pickupLongitudeMeta,
          pickupLongitude.isAcceptableOrUnknown(
              data['pickup_longitude']!, _pickupLongitudeMeta));
    } else if (isInserting) {
      context.missing(_pickupLongitudeMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
          _destinationMeta,
          destination.isAcceptableOrUnknown(
              data['destination']!, _destinationMeta));
    } else if (isInserting) {
      context.missing(_destinationMeta);
    }
    if (data.containsKey('destination_latitude')) {
      context.handle(
          _destinationLatitudeMeta,
          destinationLatitude.isAcceptableOrUnknown(
              data['destination_latitude']!, _destinationLatitudeMeta));
    } else if (isInserting) {
      context.missing(_destinationLatitudeMeta);
    }
    if (data.containsKey('destination_longitude')) {
      context.handle(
          _destinationLongitudeMeta,
          destinationLongitude.isAcceptableOrUnknown(
              data['destination_longitude']!, _destinationLongitudeMeta));
    } else if (isInserting) {
      context.missing(_destinationLongitudeMeta);
    }
    if (data.containsKey('trip_date')) {
      context.handle(_tripDateMeta,
          tripDate.isAcceptableOrUnknown(data['trip_date']!, _tripDateMeta));
    } else if (isInserting) {
      context.missing(_tripDateMeta);
    }
    if (data.containsKey('trip_time')) {
      context.handle(_tripTimeMeta,
          tripTime.isAcceptableOrUnknown(data['trip_time']!, _tripTimeMeta));
    } else if (isInserting) {
      context.missing(_tripTimeMeta);
    }
    if (data.containsKey('passenger_count')) {
      context.handle(
          _passengerCountMeta,
          passengerCount.isAcceptableOrUnknown(
              data['passenger_count']!, _passengerCountMeta));
    } else if (isInserting) {
      context.missing(_passengerCountMeta);
    }
    if (data.containsKey('fare')) {
      context.handle(
          _fareMeta, fare.isAcceptableOrUnknown(data['fare']!, _fareMeta));
    } else if (isInserting) {
      context.missing(_fareMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trip(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pickupLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pickup_location'])!,
      pickupLatitude: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}pickup_latitude'])!,
      pickupLongitude: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}pickup_longitude'])!,
      destination: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}destination'])!,
      destinationLatitude: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}destination_latitude'])!,
      destinationLongitude: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}destination_longitude'])!,
      tripDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}trip_date'])!,
      tripTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trip_time'])!,
      passengerCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}passenger_count'])!,
      fare: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fare'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class Trip extends DataClass implements Insertable<Trip> {
  final int id;
  final String pickupLocation;
  final double pickupLatitude;
  final double pickupLongitude;
  final String destination;
  final double destinationLatitude;
  final double destinationLongitude;
  final DateTime tripDate;
  final String tripTime;
  final int passengerCount;
  final double fare;
  final String status;
  const Trip(
      {required this.id,
      required this.pickupLocation,
      required this.pickupLatitude,
      required this.pickupLongitude,
      required this.destination,
      required this.destinationLatitude,
      required this.destinationLongitude,
      required this.tripDate,
      required this.tripTime,
      required this.passengerCount,
      required this.fare,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pickup_location'] = Variable<String>(pickupLocation);
    map['pickup_latitude'] = Variable<double>(pickupLatitude);
    map['pickup_longitude'] = Variable<double>(pickupLongitude);
    map['destination'] = Variable<String>(destination);
    map['destination_latitude'] = Variable<double>(destinationLatitude);
    map['destination_longitude'] = Variable<double>(destinationLongitude);
    map['trip_date'] = Variable<DateTime>(tripDate);
    map['trip_time'] = Variable<String>(tripTime);
    map['passenger_count'] = Variable<int>(passengerCount);
    map['fare'] = Variable<double>(fare);
    map['status'] = Variable<String>(status);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
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
    );
  }

  factory Trip.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trip(
      id: serializer.fromJson<int>(json['id']),
      pickupLocation: serializer.fromJson<String>(json['pickupLocation']),
      pickupLatitude: serializer.fromJson<double>(json['pickupLatitude']),
      pickupLongitude: serializer.fromJson<double>(json['pickupLongitude']),
      destination: serializer.fromJson<String>(json['destination']),
      destinationLatitude:
          serializer.fromJson<double>(json['destinationLatitude']),
      destinationLongitude:
          serializer.fromJson<double>(json['destinationLongitude']),
      tripDate: serializer.fromJson<DateTime>(json['tripDate']),
      tripTime: serializer.fromJson<String>(json['tripTime']),
      passengerCount: serializer.fromJson<int>(json['passengerCount']),
      fare: serializer.fromJson<double>(json['fare']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pickupLocation': serializer.toJson<String>(pickupLocation),
      'pickupLatitude': serializer.toJson<double>(pickupLatitude),
      'pickupLongitude': serializer.toJson<double>(pickupLongitude),
      'destination': serializer.toJson<String>(destination),
      'destinationLatitude': serializer.toJson<double>(destinationLatitude),
      'destinationLongitude': serializer.toJson<double>(destinationLongitude),
      'tripDate': serializer.toJson<DateTime>(tripDate),
      'tripTime': serializer.toJson<String>(tripTime),
      'passengerCount': serializer.toJson<int>(passengerCount),
      'fare': serializer.toJson<double>(fare),
      'status': serializer.toJson<String>(status),
    };
  }

  Trip copyWith(
          {int? id,
          String? pickupLocation,
          double? pickupLatitude,
          double? pickupLongitude,
          String? destination,
          double? destinationLatitude,
          double? destinationLongitude,
          DateTime? tripDate,
          String? tripTime,
          int? passengerCount,
          double? fare,
          String? status}) =>
      Trip(
        id: id ?? this.id,
        pickupLocation: pickupLocation ?? this.pickupLocation,
        pickupLatitude: pickupLatitude ?? this.pickupLatitude,
        pickupLongitude: pickupLongitude ?? this.pickupLongitude,
        destination: destination ?? this.destination,
        destinationLatitude: destinationLatitude ?? this.destinationLatitude,
        destinationLongitude: destinationLongitude ?? this.destinationLongitude,
        tripDate: tripDate ?? this.tripDate,
        tripTime: tripTime ?? this.tripTime,
        passengerCount: passengerCount ?? this.passengerCount,
        fare: fare ?? this.fare,
        status: status ?? this.status,
      );
  Trip copyWithCompanion(TripsCompanion data) {
    return Trip(
      id: data.id.present ? data.id.value : this.id,
      pickupLocation: data.pickupLocation.present
          ? data.pickupLocation.value
          : this.pickupLocation,
      pickupLatitude: data.pickupLatitude.present
          ? data.pickupLatitude.value
          : this.pickupLatitude,
      pickupLongitude: data.pickupLongitude.present
          ? data.pickupLongitude.value
          : this.pickupLongitude,
      destination:
          data.destination.present ? data.destination.value : this.destination,
      destinationLatitude: data.destinationLatitude.present
          ? data.destinationLatitude.value
          : this.destinationLatitude,
      destinationLongitude: data.destinationLongitude.present
          ? data.destinationLongitude.value
          : this.destinationLongitude,
      tripDate: data.tripDate.present ? data.tripDate.value : this.tripDate,
      tripTime: data.tripTime.present ? data.tripTime.value : this.tripTime,
      passengerCount: data.passengerCount.present
          ? data.passengerCount.value
          : this.passengerCount,
      fare: data.fare.present ? data.fare.value : this.fare,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trip(')
          ..write('id: $id, ')
          ..write('pickupLocation: $pickupLocation, ')
          ..write('pickupLatitude: $pickupLatitude, ')
          ..write('pickupLongitude: $pickupLongitude, ')
          ..write('destination: $destination, ')
          ..write('destinationLatitude: $destinationLatitude, ')
          ..write('destinationLongitude: $destinationLongitude, ')
          ..write('tripDate: $tripDate, ')
          ..write('tripTime: $tripTime, ')
          ..write('passengerCount: $passengerCount, ')
          ..write('fare: $fare, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      pickupLocation,
      pickupLatitude,
      pickupLongitude,
      destination,
      destinationLatitude,
      destinationLongitude,
      tripDate,
      tripTime,
      passengerCount,
      fare,
      status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trip &&
          other.id == this.id &&
          other.pickupLocation == this.pickupLocation &&
          other.pickupLatitude == this.pickupLatitude &&
          other.pickupLongitude == this.pickupLongitude &&
          other.destination == this.destination &&
          other.destinationLatitude == this.destinationLatitude &&
          other.destinationLongitude == this.destinationLongitude &&
          other.tripDate == this.tripDate &&
          other.tripTime == this.tripTime &&
          other.passengerCount == this.passengerCount &&
          other.fare == this.fare &&
          other.status == this.status);
}

class TripsCompanion extends UpdateCompanion<Trip> {
  final Value<int> id;
  final Value<String> pickupLocation;
  final Value<double> pickupLatitude;
  final Value<double> pickupLongitude;
  final Value<String> destination;
  final Value<double> destinationLatitude;
  final Value<double> destinationLongitude;
  final Value<DateTime> tripDate;
  final Value<String> tripTime;
  final Value<int> passengerCount;
  final Value<double> fare;
  final Value<String> status;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.pickupLocation = const Value.absent(),
    this.pickupLatitude = const Value.absent(),
    this.pickupLongitude = const Value.absent(),
    this.destination = const Value.absent(),
    this.destinationLatitude = const Value.absent(),
    this.destinationLongitude = const Value.absent(),
    this.tripDate = const Value.absent(),
    this.tripTime = const Value.absent(),
    this.passengerCount = const Value.absent(),
    this.fare = const Value.absent(),
    this.status = const Value.absent(),
  });
  TripsCompanion.insert({
    this.id = const Value.absent(),
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
    this.status = const Value.absent(),
  })  : pickupLocation = Value(pickupLocation),
        pickupLatitude = Value(pickupLatitude),
        pickupLongitude = Value(pickupLongitude),
        destination = Value(destination),
        destinationLatitude = Value(destinationLatitude),
        destinationLongitude = Value(destinationLongitude),
        tripDate = Value(tripDate),
        tripTime = Value(tripTime),
        passengerCount = Value(passengerCount),
        fare = Value(fare);
  static Insertable<Trip> custom({
    Expression<int>? id,
    Expression<String>? pickupLocation,
    Expression<double>? pickupLatitude,
    Expression<double>? pickupLongitude,
    Expression<String>? destination,
    Expression<double>? destinationLatitude,
    Expression<double>? destinationLongitude,
    Expression<DateTime>? tripDate,
    Expression<String>? tripTime,
    Expression<int>? passengerCount,
    Expression<double>? fare,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pickupLocation != null) 'pickup_location': pickupLocation,
      if (pickupLatitude != null) 'pickup_latitude': pickupLatitude,
      if (pickupLongitude != null) 'pickup_longitude': pickupLongitude,
      if (destination != null) 'destination': destination,
      if (destinationLatitude != null)
        'destination_latitude': destinationLatitude,
      if (destinationLongitude != null)
        'destination_longitude': destinationLongitude,
      if (tripDate != null) 'trip_date': tripDate,
      if (tripTime != null) 'trip_time': tripTime,
      if (passengerCount != null) 'passenger_count': passengerCount,
      if (fare != null) 'fare': fare,
      if (status != null) 'status': status,
    });
  }

  TripsCompanion copyWith(
      {Value<int>? id,
      Value<String>? pickupLocation,
      Value<double>? pickupLatitude,
      Value<double>? pickupLongitude,
      Value<String>? destination,
      Value<double>? destinationLatitude,
      Value<double>? destinationLongitude,
      Value<DateTime>? tripDate,
      Value<String>? tripTime,
      Value<int>? passengerCount,
      Value<double>? fare,
      Value<String>? status}) {
    return TripsCompanion(
      id: id ?? this.id,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      destination: destination ?? this.destination,
      destinationLatitude: destinationLatitude ?? this.destinationLatitude,
      destinationLongitude: destinationLongitude ?? this.destinationLongitude,
      tripDate: tripDate ?? this.tripDate,
      tripTime: tripTime ?? this.tripTime,
      passengerCount: passengerCount ?? this.passengerCount,
      fare: fare ?? this.fare,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pickupLocation.present) {
      map['pickup_location'] = Variable<String>(pickupLocation.value);
    }
    if (pickupLatitude.present) {
      map['pickup_latitude'] = Variable<double>(pickupLatitude.value);
    }
    if (pickupLongitude.present) {
      map['pickup_longitude'] = Variable<double>(pickupLongitude.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (destinationLatitude.present) {
      map['destination_latitude'] = Variable<double>(destinationLatitude.value);
    }
    if (destinationLongitude.present) {
      map['destination_longitude'] =
          Variable<double>(destinationLongitude.value);
    }
    if (tripDate.present) {
      map['trip_date'] = Variable<DateTime>(tripDate.value);
    }
    if (tripTime.present) {
      map['trip_time'] = Variable<String>(tripTime.value);
    }
    if (passengerCount.present) {
      map['passenger_count'] = Variable<int>(passengerCount.value);
    }
    if (fare.present) {
      map['fare'] = Variable<double>(fare.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('pickupLocation: $pickupLocation, ')
          ..write('pickupLatitude: $pickupLatitude, ')
          ..write('pickupLongitude: $pickupLongitude, ')
          ..write('destination: $destination, ')
          ..write('destinationLatitude: $destinationLatitude, ')
          ..write('destinationLongitude: $destinationLongitude, ')
          ..write('tripDate: $tripDate, ')
          ..write('tripTime: $tripTime, ')
          ..write('passengerCount: $passengerCount, ')
          ..write('fare: $fare, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TripsTable trips = $TripsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [trips];
}

typedef $$TripsTableCreateCompanionBuilder = TripsCompanion Function({
  Value<int> id,
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
  Value<String> status,
});
typedef $$TripsTableUpdateCompanionBuilder = TripsCompanion Function({
  Value<int> id,
  Value<String> pickupLocation,
  Value<double> pickupLatitude,
  Value<double> pickupLongitude,
  Value<String> destination,
  Value<double> destinationLatitude,
  Value<double> destinationLongitude,
  Value<DateTime> tripDate,
  Value<String> tripTime,
  Value<int> passengerCount,
  Value<double> fare,
  Value<String> status,
});

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pickupLocation => $composableBuilder(
      column: $table.pickupLocation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pickupLatitude => $composableBuilder(
      column: $table.pickupLatitude,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pickupLongitude => $composableBuilder(
      column: $table.pickupLongitude,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get destinationLatitude => $composableBuilder(
      column: $table.destinationLatitude,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get destinationLongitude => $composableBuilder(
      column: $table.destinationLongitude,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tripDate => $composableBuilder(
      column: $table.tripDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tripTime => $composableBuilder(
      column: $table.tripTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get passengerCount => $composableBuilder(
      column: $table.passengerCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fare => $composableBuilder(
      column: $table.fare, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pickupLocation => $composableBuilder(
      column: $table.pickupLocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pickupLatitude => $composableBuilder(
      column: $table.pickupLatitude,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pickupLongitude => $composableBuilder(
      column: $table.pickupLongitude,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get destinationLatitude => $composableBuilder(
      column: $table.destinationLatitude,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get destinationLongitude => $composableBuilder(
      column: $table.destinationLongitude,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tripDate => $composableBuilder(
      column: $table.tripDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tripTime => $composableBuilder(
      column: $table.tripTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get passengerCount => $composableBuilder(
      column: $table.passengerCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fare => $composableBuilder(
      column: $table.fare, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pickupLocation => $composableBuilder(
      column: $table.pickupLocation, builder: (column) => column);

  GeneratedColumn<double> get pickupLatitude => $composableBuilder(
      column: $table.pickupLatitude, builder: (column) => column);

  GeneratedColumn<double> get pickupLongitude => $composableBuilder(
      column: $table.pickupLongitude, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
      column: $table.destination, builder: (column) => column);

  GeneratedColumn<double> get destinationLatitude => $composableBuilder(
      column: $table.destinationLatitude, builder: (column) => column);

  GeneratedColumn<double> get destinationLongitude => $composableBuilder(
      column: $table.destinationLongitude, builder: (column) => column);

  GeneratedColumn<DateTime> get tripDate =>
      $composableBuilder(column: $table.tripDate, builder: (column) => column);

  GeneratedColumn<String> get tripTime =>
      $composableBuilder(column: $table.tripTime, builder: (column) => column);

  GeneratedColumn<int> get passengerCount => $composableBuilder(
      column: $table.passengerCount, builder: (column) => column);

  GeneratedColumn<double> get fare =>
      $composableBuilder(column: $table.fare, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$TripsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TripsTable,
    Trip,
    $$TripsTableFilterComposer,
    $$TripsTableOrderingComposer,
    $$TripsTableAnnotationComposer,
    $$TripsTableCreateCompanionBuilder,
    $$TripsTableUpdateCompanionBuilder,
    (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
    Trip,
    PrefetchHooks Function()> {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> pickupLocation = const Value.absent(),
            Value<double> pickupLatitude = const Value.absent(),
            Value<double> pickupLongitude = const Value.absent(),
            Value<String> destination = const Value.absent(),
            Value<double> destinationLatitude = const Value.absent(),
            Value<double> destinationLongitude = const Value.absent(),
            Value<DateTime> tripDate = const Value.absent(),
            Value<String> tripTime = const Value.absent(),
            Value<int> passengerCount = const Value.absent(),
            Value<double> fare = const Value.absent(),
            Value<String> status = const Value.absent(),
          }) =>
              TripsCompanion(
            id: id,
            pickupLocation: pickupLocation,
            pickupLatitude: pickupLatitude,
            pickupLongitude: pickupLongitude,
            destination: destination,
            destinationLatitude: destinationLatitude,
            destinationLongitude: destinationLongitude,
            tripDate: tripDate,
            tripTime: tripTime,
            passengerCount: passengerCount,
            fare: fare,
            status: status,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
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
            Value<String> status = const Value.absent(),
          }) =>
              TripsCompanion.insert(
            id: id,
            pickupLocation: pickupLocation,
            pickupLatitude: pickupLatitude,
            pickupLongitude: pickupLongitude,
            destination: destination,
            destinationLatitude: destinationLatitude,
            destinationLongitude: destinationLongitude,
            tripDate: tripDate,
            tripTime: tripTime,
            passengerCount: passengerCount,
            fare: fare,
            status: status,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TripsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TripsTable,
    Trip,
    $$TripsTableFilterComposer,
    $$TripsTableOrderingComposer,
    $$TripsTableAnnotationComposer,
    $$TripsTableCreateCompanionBuilder,
    $$TripsTableUpdateCompanionBuilder,
    (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
    Trip,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
}
