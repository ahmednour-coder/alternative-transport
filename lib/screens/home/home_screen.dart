import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/vehicle.dart';
import '../../data/models/vehicle_filter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/pill_chip.dart';
import '../../widgets/vehicle_map.dart';
import '../../widgets/vehicle_thumb.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openTab(int index) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.tabFor(index));
  }

  void _openVehicle(Vehicle vehicle) {
    ref.read(selectedVehicleProvider.notifier).state = vehicle;
    Navigator.pushNamed(context, AppRoutes.vehicle, arguments: vehicle);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final vehicles = ref.watch(filteredVehiclesProvider);
    final filter = ref.watch(vehicleFilterProvider);
    final firstName = user?.firstName.trim();
    final greeting = firstName == null || firstName.isEmpty
        ? 'Bonjour'
        : 'Bonjour, $firstName';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Prêt pour une nouvelle aventure ?',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.pale,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.search_rounded,
                                  size: 20,
                                  color: AppColors.textMuted,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _search,
                                    onChanged: (value) => ref
                                        .read(searchQueryProvider.notifier)
                                        .state = value,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.navy,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Rechercher un véhicule, une station…',
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      filled: false,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 14),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.filters,
                                  ),
                                  icon: const Icon(
                                    Icons.tune_rounded,
                                    size: 19,
                                    color: AppColors.primary,
                                  ),
                                  tooltip: 'Filtres',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (final type in const [
                                  'Tous',
                                  'Électrique',
                                  'Petite',
                                ])
                                  Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: PillChip(
                                      label: type,
                                      selected: filter.type == type,
                                      onTap: () {
                                        ref
                                            .read(vehicleFilterProvider.notifier)
                                            .state =
                                            filter.copyWith(type: type);
                                      },
                                    ),
                                  ),
                                PillChip(
                                  label: 'Bika',
                                  selected: filter.brand == 'Bika',
                                  onTap: () {
                                    ref
                                        .read(vehicleFilterProvider.notifier)
                                        .state = filter.copyWith(
                                      brand:
                                          filter.brand == 'Bika' ? 'Tous' : 'Bika',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: SizedBox(
                          height: 230,
                          child: VehicleMap(
                            vehicles: ref.watch(vehiclesProvider),
                            asset: AppConstants.mapHome,
                            markerSize: 31,
                            onTap: _openVehicle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Row(
                        children: [
                          const Text(
                            'Véhicules à proximité',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => _openTab(1),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Voir tout'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: vehicles.isEmpty
                          ? EmptyState(
                              icon: Icons.search_off_rounded,
                              title: 'Aucun véhicule',
                              message:
                                  'Aucun véhicule ne correspond à votre recherche. Modifiez les filtres.',
                              action: TextButton(
                                onPressed: () {
                                  ref
                                      .read(vehicleFilterProvider.notifier)
                                      .state = const VehicleFilter();
                                },
                                child: const Text('Réinitialiser les filtres'),
                              ),
                            )
                          : Column(
                              children: [
                                for (final vehicle in vehicles.take(3))
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _VehicleRow(
                                      vehicle: vehicle,
                                      onTap: () => _openVehicle(vehicle),
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onTap: _openTab,
      ),
    );
  }
}

class _VehicleRow extends StatelessWidget {
  const _VehicleRow({required this.vehicle, required this.onTap});

  final Vehicle vehicle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(10),
      onTap: onTap,
      child: Row(
        children: [
          VehicleThumb(vehicle: vehicle, width: 86, height: 62),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${vehicle.batteryLabel} · ${vehicle.rangeKm} km',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${vehicle.distanceKm.toStringAsFixed(1)} km',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textLight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
