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
import '../../widgets/vehicle_thumb.dart';
import '../key/access_code_screen.dart';

class ReservationScreen extends ConsumerStatefulWidget {
  const ReservationScreen({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  ConsumerState<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends ConsumerState<ReservationScreen> {
  late DateTime _start;
  late DateTime _end;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _start = DateTime(now.year, now.month, now.day, 10);
    _end = DateTime(now.year, now.month, now.day, 14);
  }

  int get _hours {
    final difference = _end.difference(_start).inMinutes;
    if (difference <= 0) return 0;
    return max(1, (difference / 60).ceil());
  }

  double get _basePrice => _hours * widget.vehicle.pricePerHour;
  double get _total => _basePrice + AppConstants.serviceFee;

  Future<void> _pickDateTime({required bool isStart}) async {
    final initial = isStart ? _start : _end;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      helpText: isStart ? 'Date de début' : 'Date de fin',
      cancelText: 'Annuler',
      confirmText: 'Choisir',
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      helpText: isStart ? 'Heure de début' : 'Heure de fin',
      cancelText: 'Annuler',
      confirmText: 'Choisir',
    );
    if (time == null || !mounted) return;
    final value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (isStart) {
        _start = value;
        if (!_end.isAfter(_start)) {
          _end = _start.add(const Duration(hours: 4));
        }
      } else {
        _end = value;
      }
    });
  }

  Future<void> _confirm() async {
    if (_hours <= 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('La date de fin doit être après la date de début.'),
          ),
        );
      return;
    }

    setState(() => _loading = true);
    final reservation = await ref
        .read(reservationsProvider.notifier)
        .create(
          vehicle: widget.vehicle,
          start: _start,
          end: _end,
          total: _total,
        );

    final now = DateTime.now();
    final code = AccessCode(
      code: (1000 + Random.secure().nextInt(9000)).toString(),
      issuedAt: now,
      expiresAt: now.add(AppConstants.accessCodeValidity),
      vehicleId: widget.vehicle.id,
    );

    ref.read(accessCodeProvider.notifier).state = code;
    ref.read(activeReservationProvider.notifier).state = reservation;

    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushNamed(
      context,
      AppRoutes.accessCode,
      arguments: AccessCodeArgs(code: code, vehicle: widget.vehicle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenHeader(title: 'Réservation'),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          VehicleThumb(
                            vehicle: widget.vehicle,
                            width: 92,
                            height: 64,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.vehicle.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${widget.vehicle.distanceKm.toStringAsFixed(1)} km · ${widget.vehicle.seats} places · ${widget.vehicle.type}',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _DateTimeCard(
                            label: 'Date de début',
                            date: _start,
                            onTap: () => _pickDateTime(isStart: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DateTimeCard(
                            label: 'Date de fin',
                            date: _end,
                            onTap: () => _pickDateTime(isStart: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _PriceRow(
                      label: 'Prix de base',
                      value: '${_basePrice.toStringAsFixed(0)} TND',
                    ),
                    const SizedBox(height: 12),
                    const _PriceRow(label: 'Frais de service', value: '2 TND'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_total.toStringAsFixed(0)} TND',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Durée : ${formatDurationLabel(_end.difference(_start))} · $_hours h facturée(s).',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primaryDark,
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
              child: AppButton(
                label: 'Confirmer la réservation',
                loading: _loading,
                onPressed: _confirm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimeCard extends StatelessWidget {
  const _DateTimeCard({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            const SizedBox(height: 6),
            Text(
              formatDate(date),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Text(
                  formatTime(date),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.edit_calendar_outlined,
                  size: 15,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}
