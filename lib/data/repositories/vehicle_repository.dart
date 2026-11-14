import '../models/vehicle.dart';
import '../services/mock_data.dart';

class VehicleRepository {
  const VehicleRepository();

  List<Vehicle> get cached => List<Vehicle>.unmodifiable(MockData.vehicles);

  Future<List<Vehicle>> fetchAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return cached;
  }
}
