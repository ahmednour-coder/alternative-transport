import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/reservation.dart';
import '../../providers/reservation_provider.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/pill_chip.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/vehicle_thumb.dart';
import '../key/access_code_screen.dart';

class ReservationsScreen extends ConsumerStatefulWidget {
  const ReservationsScreen({super.key});

  @override
  ConsumerState<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends ConsumerState<ReservationsScreen> {
  int _tab = 0;

  void _openTab(int index) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.tabFor(index));
  }

  List<Reservation> _filtered(List<Reservation> items) {
    return switch (_tab) {
      1 => items
          .where((item) =>
              item.status == ReservationStatus.active ||
              item.status == ReservationStatus.confirmed)
          .toList(),
      2 => items
          .where((item) => item.status == ReservationStatus.completed)
          .toList(),
      _ => items,
    };
  }

  void _showDetails(Reservation reservation) {
    final accessCode = ref.read(accessCodeProvider);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  VehicleThumb(vehicle: reservation.vehicle, width: 74, height: 56),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reservation.vehicle.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          'Réservation ${reservation.id}',
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(reservation.status),
                ],
              ),
              const SizedBox(height: 18),
              _DetailRow(
                label: 'Début',
                value: formatDateTime(reservation.start),
              ),
              const SizedBox(height: 10),
              _DetailRow(label: 'Fin', value: formatDateTime(reservation.end)),
              const SizedBox(height: 10),
              _DetailRow(
                label: 'Durée',
                value: formatDurationLabel(reservation.duration),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              _DetailRow(
                label: 'Total',
                value: formatMoney(reservation.total),
                strong: true,
              ),
              const SizedBox(height: 16),
              if (reservation.status != ReservationStatus.completed &&
                  accessCode != null)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      Navigator.pushNamed(
                        context,
                        AppRoutes.accessCode,
                        arguments: AccessCodeArgs(
                          code: accessCode,
                          vehicle: reservation.vehicle,
                        ),
                      );
                    },
                    child: const Text('Ouvrir le code d’accès'),
                  ),
                ),
              if (reservation.status == ReservationStatus.completed)
                const Text(
                  'Ce trajet est terminé. Le reçu reste disponible dans l’historique.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  StatusBadge _statusBadge(ReservationStatus status) {
    return switch (status) {
      ReservationStatus.completed => const StatusBadge(label: 'Terminée'),
      ReservationStatus.active => const StatusBadge(
          label: 'En cours',
          foreground: AppColors.primary,
          background: AppColors.primarySoft,
        ),
      ReservationStatus.confirmed => const StatusBadge(
          label: 'Confirmée',
          foreground: AppColors.amber,
          background: AppColors.amberSoft,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(reservationsProvider);
    final items = _filtered(all);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 20, 22, 4),
              child: Text(
                'Mes réservations',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'Suivez vos trajets en cours et retrouvez votre historique.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  PillChip(
                    label: 'Toutes',
                    selected: _tab == 0,
                    onTap: () => setState(() => _tab = 0),
                  ),
                  const SizedBox(width: 9),
                  PillChip(
                    label: 'En cours',
                    selected: _tab == 1,
                    onTap: () => setState(() => _tab = 1),
                  ),
                  const SizedBox(width: 9),
                  PillChip(
                    label: 'Terminées',
                    selected: _tab == 2,
                    onTap: () => setState(() => _tab = 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? EmptyState(
                      icon: Icons.event_busy_rounded,
                      title: 'Aucune réservation',
                      message: _tab == 1
                          ? 'Vous n’avez pas de réservation en cours.'
                          : 'Vos trajets terminés apparaîtront ici.',
                      action: TextButton(
                        onPressed: () => _openTab(0),
                        child: const Text('Réserver un véhicule'),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final reservation = items[index];
                        return InkWell(
                          onTap: () => _showDetails(reservation),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                VehicleThumb(
                                  vehicle: reservation.vehicle,
                                  width: 82,
                                  height: 60,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              reservation.vehicle.name,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.navy,
                                              ),
                                            ),
                                          ),
                                          _statusBadge(reservation.status),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatDateTime(reservation.start),
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${formatDurationLabel(reservation.duration)} · ${formatMoney(reservation.total)}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: _openTab,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: strong ? 15 : 12.5,
            fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}
