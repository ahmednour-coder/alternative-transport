import 'vehicle.dart';

enum ReservationStatus { confirmed, active, completed }

extension ReservationStatusLabel on ReservationStatus {
  String get label => switch (this) {
        ReservationStatus.confirmed => 'Confirmée',
        ReservationStatus.active => 'En cours',
        ReservationStatus.completed => 'Terminée',
      };
}

class Reservation {
  const Reservation({
    required this.id,
    required this.vehicle,
    required this.start,
    required this.end,
    required this.total,
    required this.status,
  });

  final String id;
  final Vehicle vehicle;
  final DateTime start;
  final DateTime end;
  final double total;
  final ReservationStatus status;

  Duration get duration => end.difference(start);

  Reservation copyWith({ReservationStatus? status}) {
    return Reservation(
      id: id,
      vehicle: vehicle,
      start: start,
      end: end,
      total: total,
      status: status ?? this.status,
    );
  }
}
