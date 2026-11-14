import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/trip.dart';
import '../data/models/vehicle.dart';
import 'reservation_provider.dart';

class TripNotifier extends StateNotifier<TripState> {
  TripNotifier(this._ref) : super(const TripState());

  final Ref _ref;
  Timer? _timer;

  void start(Vehicle vehicle) {
    _timer?.cancel();
    final startedAt = DateTime.now();
    state = TripState(vehicle: vehicle, startedAt: startedAt, running: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final seconds = state.seconds + 1;
      state = TripState(
        vehicle: state.vehicle,
        startedAt: state.startedAt,
        seconds: seconds,
        distanceKm: seconds * 0.45,
        cost: seconds * 0.70,
        running: true,
      );
    });
  }

  Trip? stop() {
    final vehicle = state.vehicle;
    if (vehicle == null) return null;

    final trip = Trip(
      vehicle: vehicle,
      startedAt: state.startedAt ?? DateTime.now(),
      duration: state.elapsed,
      distanceKm: state.distanceKm,
      cost: state.cost,
    );

    _timer?.cancel();
    _timer = null;
    state = const TripState();
    _ref.read(reservationsProvider.notifier).completeActive();
    return trip;
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    state = const TripState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final tripProvider = StateNotifierProvider<TripNotifier, TripState>((ref) {
  return TripNotifier(ref);
});
