import 'vehicle.dart';

class VehicleFilter {
  const VehicleFilter({
    this.type = 'Tous',
    this.brand = 'Tous',
    this.minRange = 0,
    this.maxPrice = 25,
    this.equipment = const <String>{},
  });

  final String type;
  final String brand;
  final double minRange;
  final double maxPrice;
  final Set<String> equipment;

  bool get isActive =>
      type != 'Tous' ||
      brand != 'Tous' ||
      minRange > 0 ||
      maxPrice < 25 ||
      equipment.isNotEmpty;

  bool matches(Vehicle vehicle) {
    if (type != 'Tous' && vehicle.type != type) return false;
    if (brand != 'Tous' && vehicle.brand != brand) return false;
    if (vehicle.rangeKm < minRange) return false;
    if (vehicle.pricePerDay > maxPrice) return false;
    if (!equipment.every(vehicle.equipment.contains)) return false;
    return true;
  }

  VehicleFilter copyWith({
    String? type,
    String? brand,
    double? minRange,
    double? maxPrice,
    Set<String>? equipment,
  }) {
    return VehicleFilter(
      type: type ?? this.type,
      brand: brand ?? this.brand,
      minRange: minRange ?? this.minRange,
      maxPrice: maxPrice ?? this.maxPrice,
      equipment: equipment ?? this.equipment,
    );
  }
}
