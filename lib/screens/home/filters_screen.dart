import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/vehicle_filter.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/pill_chip.dart';
import '../../widgets/screen_header.dart';

class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({super.key});

  @override
  ConsumerState<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  late VehicleFilter _draft;

  static const _types = ['Tous', 'Électrique', 'Petite'];
  static const _brands = ['Tous', 'Bika', 'Dacia', 'Renault'];
  static const _equipment = [
    'Climatisation',
    'Bluetooth',
    'GPS',
    'Caméra de recul',
    'Recharge rapide',
  ];

  @override
  void initState() {
    super.initState();
    _draft = ref.read(vehicleFilterProvider);
  }

  void _apply() {
    ref.read(vehicleFilterProvider.notifier).state = _draft;
    Navigator.pop(context);
  }

  void _reset() {
    setState(() => _draft = const VehicleFilter());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScreenHeader(
                      title: 'Filtres',
                      trailing: TextButton(
                        onPressed: _reset,
                        child: const Text('Réinitialiser'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _Label('Type de véhicule'),
                    Wrap(
                      spacing: 9,
                      runSpacing: 9,
                      children: [
                        for (final type in _types)
                          PillChip(
                            label: type,
                            selected: _draft.type == type,
                            onTap: () => setState(
                              () => _draft = _draft.copyWith(type: type),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _Label('Marque'),
                    Wrap(
                      spacing: 9,
                      runSpacing: 9,
                      children: [
                        for (final brand in _brands)
                          PillChip(
                            label: brand,
                            selected: _draft.brand == brand,
                            onTap: () => setState(
                              () => _draft = _draft.copyWith(brand: brand),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const _Label('Autonomie min.', noPadding: true),
                        const Spacer(),
                        Text(
                          '${_draft.minRange.toInt()} km',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: _sliderTheme,
                      child: Slider(
                        value: _draft.minRange,
                        min: 0,
                        max: 300,
                        divisions: 30,
                        onChanged: (value) => setState(
                          () => _draft = _draft.copyWith(minRange: value),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const _Label('Prix max.', noPadding: true),
                        const Spacer(),
                        Text(
                          '${_draft.maxPrice.toInt()} TND/jour',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: _sliderTheme,
                      child: Slider(
                        value: _draft.maxPrice,
                        min: 5,
                        max: 40,
                        divisions: 35,
                        onChanged: (value) => setState(
                          () => _draft = _draft.copyWith(maxPrice: value),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _Label('Équipements'),
                    Wrap(
                      spacing: 9,
                      runSpacing: 9,
                      children: [
                        for (final item in _equipment)
                          PillChip(
                            label: item,
                            selected: _draft.equipment.contains(item),
                            onTap: () {
                              final next = Set<String>.of(_draft.equipment);
                              if (next.contains(item)) {
                                next.remove(item);
                              } else {
                                next.add(item);
                              }
                              setState(
                                () => _draft = _draft.copyWith(equipment: next),
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 17,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Les filtres s’appliquent immédiatement à la liste des véhicules à proximité.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.4,
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
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
              child: AppButton(label: 'Appliquer', onPressed: _apply),
            ),
          ],
        ),
      ),
    );
  }

  SliderThemeData get _sliderTheme => SliderThemeData(
        trackHeight: 4,
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.pale,
        thumbColor: Colors.white,
        overlayColor: AppColors.primary.withValues(alpha: 0.12),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 11,
          elevation: 2,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      );
}

class _Label extends StatelessWidget {
  const _Label(this.text, {this.noPadding = false});

  final String text;
  final bool noPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: noPadding ? 0 : 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
