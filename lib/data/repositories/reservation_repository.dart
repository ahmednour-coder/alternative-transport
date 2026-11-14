import '../models/reservation.dart';
import '../models/vehicle.dart';
import '../services/mock_data.dart';

class ReservationRepository {
  ReservationRepository() : _items = MockData.reservations();

  final List<Reservation> _items;
  int _sequence = 2000;

  List<Reservation> get cached => List<Reservation>.unmodifiable(_items);

  Future<Reservation> create({
    required Vehicle vehicle,
    required DateTime start,
    required DateTime end,
    required double total,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _sequence++;
    final reservation = Reservation(
      id: 'r-$_sequence',
      vehicle: vehicle,
      start: start,
      end: end,
      total: total,
      status: ReservationStatus.confirmed,
    );
    _items.insert(0, reservation);
    return reservation;
  }

  void markActiveCompleted() {
    for (var index = 0; index < _items.length; index++) {
      final item = _items[index];
      if (item.status == ReservationStatus.confirmed ||
          item.status == ReservationStatus.active) {
        _items[index] = item.copyWith(status: ReservationStatus.completed);
      }
    }
  }

  void activate(String reservationId) {
    for (var index = 0; index < _items.length; index++) {
      final item = _items[index];
      if (item.id == reservationId) {
        _items[index] = item.copyWith(status: ReservationStatus.active);
      }
    }
  }
}
