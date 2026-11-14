import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/vehicle.dart';
import '../data/models/vehicle_filter.dart';
import '../data/repositories/vehicle_repository.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return const VehicleRepository();
});

class VehiclesNotifier extends StateNotifier<List<Vehicle>> {
  VehiclesNotifier(this._repository) : super(_repository.cached);

  final VehicleRepository _repository;

  Future<void> refresh() async {
    state = await _repository.fetchAll();
  }
}

final vehiclesProvider =
    StateNotifierProvider<VehiclesNotifier, List<Vehicle>>((ref) {
  return VehiclesNotifier(ref.watch(vehicleRepositoryProvider));
});

final vehicleFilterProvider = StateProvider<VehicleFilter>((ref) {
  return const VehicleFilter();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredVehiclesProvider = Provider<List<Vehicle>>((ref) {
  final filter = ref.watch(vehicleFilterProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  return ref.watch(vehiclesProvider).where((vehicle) {
    if (!filter.matches(vehicle)) return false;
    if (query.isEmpty) return true;
    return vehicle.name.toLowerCase().contains(query) ||
        vehicle.brand.toLowerCase().contains(query) ||
        vehicle.type.toLowerCase().contains(query);
  }).toList();
});

final selectedVehicleProvider = StateProvider<Vehicle?>((ref) => null);
