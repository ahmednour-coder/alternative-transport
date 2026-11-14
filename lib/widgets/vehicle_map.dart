import 'package:flutter/material.dart';

import '../data/models/vehicle.dart';

class VehicleMap extends StatelessWidget {
  const VehicleMap({
    super.key,
    required this.vehicles,
    required this.asset,
    this.selected,
    this.onTap,
    this.markerSize = 34,
  });

  final List<Vehicle> vehicles;
  final String asset;
  final Vehicle? selected;
  final ValueChanged<Vehicle>? onTap;
  final double markerSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) =>
                  const ColoredBox(color: Color(0xFFE7EEF5)),
            ),
            for (final vehicle in vehicles)
              Positioned(
                left: width * vehicle.pin.dx - markerSize / 2,
                top: height * vehicle.pin.dy - markerSize / 2,
                child: _Marker(
                  vehicle: vehicle,
                  size: markerSize,
                  selected: selected?.id == vehicle.id,
                  onTap: onTap == null ? null : () => onTap!(vehicle),
                ),
              ),
            Positioned(
              left: width / 2 - 9,
              top: height / 2 - 9,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2D9CFF).withValues(alpha: 0.22),
                ),
                child: Center(
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2D9CFF),
                      border: Border.fromBorderSide(
                        BorderSide(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Marker extends StatelessWidget {
  const _Marker({
    required this.vehicle,
    required this.size,
    required this.selected,
    this.onTap,
  });

  final Vehicle vehicle;
  final double size;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0A5FA8) : const Color(0xFF0E3D66),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.directions_car_rounded,
          color: Colors.white,
          size: size * 0.48,
        ),
      ),
    );
  }
}
