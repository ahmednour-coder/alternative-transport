import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/vehicle.dart';
import '../../providers/ble_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/screen_header.dart';

class BleConnectionScreen extends ConsumerStatefulWidget {
  const BleConnectionScreen({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  ConsumerState<BleConnectionScreen> createState() =>
      _BleConnectionScreenState();
}

class _BleConnectionScreenState extends ConsumerState<BleConnectionScreen> {
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(bleProvider.notifier).connect(widget.vehicle);
      }
    });
  }

  void _cancel() {
    ref.read(bleProvider.notifier).cancel();
    Navigator.maybePop(context);
  }

  void _goToVehicle() {
    if (_navigating) return;
    _navigating = true;
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.control,
      arguments: widget.vehicle,
    );
  }

  int get _phaseIndex => switch (ref.read(bleProvider).phase) {
        BlePhase.idle => 0,
        BlePhase.searching => 0,
        BlePhase.connecting => 1,
        BlePhase.verifying => 2,
        BlePhase.connected => 3,
        BlePhase.error => 0,
      };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bleProvider);
    final connected = state.isConnected;

    ref.listen<BleState>(bleProvider, (previous, next) {
      if (next.isConnected && !_navigating) {
        Future<void>.delayed(const Duration(milliseconds: 700), () {
          if (mounted) _goToVehicle();
        });
      }
    });

    final steps = [
      'Recherche du véhicule',
      'Connexion Bluetooth',
      'Vérification de l’accès',
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 14),
                child: Column(
                  children: [
                    ScreenHeader(
                      title: 'Connexion Bluetooth',
                      onBack: _cancel,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 168,
                      height: 168,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 168,
                            height: 168,
                            decoration: const BoxDecoration(
                              color: AppColors.primarySoft,
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (!connected)
                            const SizedBox(
                              width: 142,
                              height: 142,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          Container(
                            width: 118,
                            height: 118,
                            decoration: BoxDecoration(
                              color: connected
                                  ? AppColors.green
                                  : AppColors.navy,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              connected
                                  ? Icons.check_rounded
                                  : Icons.bluetooth_rounded,
                              color: Colors.white,
                              size: 52,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      connected ? 'Véhicule connecté' : 'Connexion en cours…',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      connected
                          ? 'Vous pouvez maintenant contrôler ${widget.vehicle.name}.'
                          : 'Rapprochez-vous du véhicule et activez le Bluetooth.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          for (var index = 0; index < steps.length; index++) ...[
                            _StepRow(
                              label: steps[index],
                              done: _phaseIndex > index,
                              current: _phaseIndex == index && !connected,
                            ),
                            if (index != steps.length - 1)
                              const Divider(height: 1),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.pale,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                          SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'La liaison est chiffrée et limitée à cette réservation.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.4,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 14),
              child: connected
                  ? AppButton(
                      label: 'Continuer vers le véhicule',
                      onPressed: _goToVehicle,
                    )
                  : AppButton(
                      label: 'Annuler',
                      variant: AppButtonVariant.outline,
                      onPressed: _cancel,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.label,
    required this.done,
    required this.current,
  });

  final String label;
  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            height: 26,
            child: done
                ? Container(
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  )
                : current
                    ? const CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor:
                            AlwaysStoppedAnimation(AppColors.primary),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border, width: 2),
                        ),
                      ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: done || current ? AppColors.navy : AppColors.textLight,
            ),
          ),
          const Spacer(),
          if (done)
            const Text(
              'OK',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.green,
              ),
            ),
        ],
      ),
    );
  }
}
