import 'vehicle.dart';

class Trip {
  const Trip({
    required this.vehicle,
    required this.startedAt,
    required this.duration,
    required this.distanceKm,
    required this.cost,
  });

  final Vehicle vehicle;
  final DateTime startedAt;
  final Duration duration;
  final double distanceKm;
  final double cost;
}

class TripState {
  const TripState({
    this.vehicle,
    this.startedAt,
    this.seconds = 0,
    this.distanceKm = 0,
    this.cost = 0,
    this.running = false,
  });

  final Vehicle? vehicle;
  final DateTime? startedAt;

  /// Durée simulée : 1 seconde réelle = 1 minute de trajet.
  final int seconds;
  final double distanceKm;
  final double cost;
  final bool running;

  Duration get elapsed => Duration(minutes: seconds);

  double get distance => distanceKm;
}
