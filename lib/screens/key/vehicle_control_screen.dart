import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/vehicle.dart';
import '../../providers/ble_provider.dart';
import '../../providers/trip_provider.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/screen_header.dart';

class VehicleControlScreen extends ConsumerWidget {
  const VehicleControlScreen({super.key, required this.vehicle});

  final Vehicle vehicle;

  void _openTab(BuildContext context, int index) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.tabFor(index));
  }

  void _toggleLock(BuildContext context, WidgetRef ref, BleState state) {
    if (!state.isConnected) {
      Navigator.pushNamed(context, AppRoutes.ble, arguments: vehicle);
      return;
    }
    final unlocking = state.locked;
    ref.read(bleProvider.notifier).toggleLock();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            unlocking
                ? 'Véhicule déverrouillé. Bon trajet !'
                : 'Véhicule verrouillé.',
          ),
        ),
      );
  }

  void _start(BuildContext context, WidgetRef ref) {
    final trip = ref.read(tripProvider);
    if (!trip.running) {
      ref.read(tripProvider.notifier).start(vehicle);
    }
    Navigator.pushNamed(context, AppRoutes.trip, arguments: vehicle);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bleProvider);
    final connected = state.isConnected;
    final locked = state.locked;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                title: 'Mon véhicule',
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: connected ? AppColors.greenSoft : AppColors.pale,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        connected
                            ? Icons.bluetooth_connected_rounded
                            : Icons.bluetooth_disabled_rounded,
                        size: 13,
                        color:
                            connected ? AppColors.green : AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        connected ? 'Connecté' : 'Hors ligne',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: connected
                              ? AppColors.green
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 158,
                    height: 128,
                    decoration: BoxDecoration(
                      color: AppColors.pale,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      vehicle.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AppConstants.carControl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          connected ? 'Connecté' : 'Dernière synchro : hier',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: connected
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          vehicle.batteryLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${vehicle.rangeKm} km d’autonomie',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _ControlButton(
                      label: 'Déverrouiller',
                      icon: Icons.lock_open_rounded,
                      primary: locked,
                      onTap: () => _toggleLock(context, ref, state),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ControlButton(
                      label: 'Verrouiller',
                      icon: Icons.lock_outline_rounded,
                      primary: !locked,
                      onTap: () => _toggleLock(context, ref, state),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ControlButton(
                      label: 'Démarrer',
                      icon: Icons.play_arrow_rounded,
                      onTap: () => _start(context, ref),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ControlButton(
                      label: 'Localiser',
                      icon: Icons.location_on_outlined,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.map),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.pale,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      locked
                          ? Icons.lock_rounded
                          : Icons.lock_open_rounded,
                      size: 17,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      locked
                          ? 'Véhicule verrouillé · prêt à être déverrouillé'
                          : 'Véhicule déverrouillé · vous pouvez démarrer',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Astuce : vérifiez le niveau de charge avant de démarrer un long trajet.',
                style: TextStyle(
                  fontSize: 10.5,
                  height: 1.4,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (index) => _openTab(context, index),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary ? AppColors.primary : AppColors.pale,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 94,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: primary ? Colors.white : AppColors.navy,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: primary ? Colors.white : AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
