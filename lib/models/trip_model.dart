class TripModel {
  final String id;
  final String pickupLocation;
  final String destination;
  final double pickupLatitude;
  final double pickupLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  final DateTime tripDate;
  final int passengerCount;
  final double fare;

  TripModel({
    required this.id,
    required this.pickupLocation,
    required this.destination,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.tripDate,
    required this.passengerCount,
    required this.fare,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      pickupLocation: json['pickup_location'],
      destination: json['destination'],
      pickupLatitude: json['pickup_latitude'].toDouble(),
      pickupLongitude: json['pickup_longitude'].toDouble(),
      destinationLatitude: json['destination_latitude'].toDouble(),
      destinationLongitude: json['destination_longitude'].toDouble(),
      tripDate: DateTime.parse(json['trip_date']),
      passengerCount: json['passenger_count'],
      fare: json['fare'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickup_location': pickupLocation,
      'destination': destination,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'destination_latitude': destinationLatitude,
      'destination_longitude': destinationLongitude,
      'trip_date': tripDate.toIso8601String(),
      'passenger_count': passengerCount,
      'fare': fare,
    };
  }
} 