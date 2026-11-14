import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/vehicle.dart';
import '../data/services/ble_service.dart';

enum BlePhase { idle, searching, connecting, verifying, connected, error }

class BleState {
  const BleState({
    this.phase = BlePhase.idle,
    this.vehicle,
    this.locked = true,
    this.started = false,
  });

  final BlePhase phase;
  final Vehicle? vehicle;
  final bool locked;
  final bool started;

  bool get isConnected => phase == BlePhase.connected;

  BleState copyWith({
    BlePhase? phase,
    Vehicle? vehicle,
    bool? locked,
    bool? started,
  }) {
    return BleState(
      phase: phase ?? this.phase,
      vehicle: vehicle ?? this.vehicle,
      locked: locked ?? this.locked,
      started: started ?? this.started,
    );
  }
}

class BleNotifier extends StateNotifier<BleState> {
  BleNotifier(this._service) : super(const BleState());

  final BleService _service;
  bool _cancelled = false;

  Future<void> connect(Vehicle vehicle) async {
    _cancelled = false;
    state = BleState(phase: BlePhase.searching, vehicle: vehicle);
    await _service.connect(
      onStep: (step) {
        if (!mounted || _cancelled) return;
        state = state.copyWith(
          phase: switch (step) {
            BleStep.searching => BlePhase.searching,
            BleStep.connecting => BlePhase.connecting,
            BleStep.verifying => BlePhase.verifying,
          },
        );
      },
      isCancelled: () => _cancelled,
    );
    if (!mounted || _cancelled) return;
    state = state.copyWith(phase: BlePhase.connected);
  }

  void cancel() {
    _cancelled = true;
    state = const BleState();
  }

  void toggleLock() {
    if (!state.isConnected) return;
    state = state.copyWith(locked: !state.locked);
  }

  void setStarted(bool value) {
    state = state.copyWith(started: value);
  }

  void disconnect() {
    _cancelled = true;
    state = const BleState();
  }
}

final bleProvider = StateNotifierProvider<BleNotifier, BleState>((ref) {
  return BleNotifier(const BleService());
});
