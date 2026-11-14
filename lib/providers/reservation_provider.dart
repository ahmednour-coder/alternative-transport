import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/access_code.dart';
import '../data/models/reservation.dart';
import '../data/models/vehicle.dart';
import '../data/repositories/reservation_repository.dart';

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  return ReservationRepository();
});

class ReservationsNotifier extends StateNotifier<List<Reservation>> {
  ReservationsNotifier(this._repository) : super(_repository.cached);

  final ReservationRepository _repository;

  Future<Reservation> create({
    required Vehicle vehicle,
    required DateTime start,
    required DateTime end,
    required double total,
  }) async {
    final reservation = await _repository.create(
      vehicle: vehicle,
      start: start,
      end: end,
      total: total,
    );
    state = _repository.cached;
    return reservation;
  }

  void activate(String reservationId) {
    _repository.activate(reservationId);
    state = _repository.cached;
  }

  void completeActive() {
    _repository.markActiveCompleted();
    state = _repository.cached;
  }
}

final reservationsProvider =
    StateNotifierProvider<ReservationsNotifier, List<Reservation>>((ref) {
  return ReservationsNotifier(ref.watch(reservationRepositoryProvider));
});

final accessCodeProvider = StateProvider<AccessCode?>((ref) => null);
final activeReservationProvider = StateProvider<Reservation?>((ref) => null);
