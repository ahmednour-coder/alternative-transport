import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/access_code.dart';
import '../../data/models/vehicle.dart';
import '../../providers/reservation_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/screen_header.dart';

class AccessCodeArgs {
  const AccessCodeArgs({required this.code, required this.vehicle});

  final AccessCode code;
  final Vehicle vehicle;
}

class AccessCodeScreen extends ConsumerStatefulWidget {
  const AccessCodeScreen({super.key, required this.code, required this.vehicle});

  final AccessCode code;
  final Vehicle vehicle;

  @override
  ConsumerState<AccessCodeScreen> createState() => _AccessCodeScreenState();
}

class _AccessCodeScreenState extends ConsumerState<AccessCodeScreen> {
  late AccessCode _code;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _code = widget.code;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _regenerate() {
    final now = DateTime.now();
    final next = AccessCode(
      code: (1000 + Random.secure().nextInt(9000)).toString(),
      issuedAt: now,
      expiresAt: now.add(AppConstants.accessCodeValidity),
      vehicleId: widget.vehicle.id,
    );
    setState(() => _code = next);
    ref.read(accessCodeProvider.notifier).state = next;
  }

  @override
  Widget build(BuildContext context) {
    final expired = _code.isExpired;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 14),
                child: Column(
                  children: [
                    const ScreenHeader(title: 'Autorisation temporaire'),
                    const SizedBox(height: 26),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: const BoxDecoration(
                        color: AppColors.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 118,
                          height: 118,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            expired
                                ? Icons.lock_clock_rounded
                                : Icons.lock_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Accès au véhicule',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      expired
                          ? 'Le code a expiré. Générez-en un nouveau.'
                          : 'Votre réservation est confirmée !',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 22,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Code d’accès temporaire',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _code.code.split('').join('  '),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              color: expired ? AppColors.textLight : AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Valide pendant 15 minutes',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: expired
                                  ? AppColors.redSoft
                                  : AppColors.greenSoft,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              expired
                                  ? 'Code expiré'
                                  : 'Expire dans ${formatCountdown(_code.remaining)}',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color:
                                    expired ? AppColors.red : AppColors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (expired)
                      AppButton(
                        label: 'Régénérer le code',
                        onPressed: _regenerate,
                      )
                    else
                      AppButton(
                        label: 'Voir sur la carte',
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.map,
                        ),
                      ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: expired
                          ? null
                          : () => Navigator.pushNamed(
                                context,
                                AppRoutes.ble,
                                arguments: widget.vehicle,
                              ),
                      child: const Text(
                        'Se connecter en Bluetooth',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Vous pouvez maintenant accéder au véhicule.',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
