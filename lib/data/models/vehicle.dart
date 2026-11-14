import '../../core/constants/app_constants.dart';

class Vehicle {
  const Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.rangeKm,
    required this.maxSpeed,
    required this.seats,
    required this.pricePerDay,
    required this.pricePerHour,
    required this.distanceKm,
    required this.battery,
    required this.imageAsset,
    required this.equipment,
    required this.rating,
    required this.reviews,
    required this.pin,
  });

  final String id;
  final String name;
  final String brand;
  final String type;
  final int rangeKm;
  final int maxSpeed;
  final int seats;
  final double pricePerDay;
  final double pricePerHour;
  final double distanceKm;
  final double battery;
  final String imageAsset;
  final List<String> equipment;
  final double rating;
  final int reviews;

  /// Position relative (0 → 1) sur la carte.
  final Offset2 pin;

  bool get isElectric => type == 'Électrique';

  String get batteryLabel => '${battery.toStringAsFixed(0)} %';

  Vehicle copyWith({
    String? name,
    double? distanceKm,
    double? battery,
  }) {
    return Vehicle(
      id: id,
      name: name ?? this.name,
      brand: brand,
      type: type,
      rangeKm: rangeKm,
      maxSpeed: maxSpeed,
      seats: seats,
      pricePerDay: pricePerDay,
      pricePerHour: pricePerHour,
      distanceKm: distanceKm ?? this.distanceKm,
      battery: battery ?? this.battery,
      imageAsset: imageAsset,
      equipment: equipment,
      rating: rating,
      reviews: reviews,
      pin: pin,
    );
  }

  static const fallbackImage = AppConstants.carBika;
}

class Offset2 {
  const Offset2(this.dx, this.dy);
  final double dx;
  final double dy;
}
