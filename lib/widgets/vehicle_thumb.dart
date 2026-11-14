import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../data/models/vehicle.dart';

class VehicleThumb extends StatelessWidget {
  const VehicleThumb({
    super.key,
    required this.vehicle,
    this.width = 92,
    this.height = 68,
    this.radius = 12,
  });

  final Vehicle vehicle;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: width,
        height: height,
        color: AppColors.pale,
        child: Image.asset(
          vehicle.imageAsset,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.directions_car_rounded,
            color: AppColors.primary,
            size: 32,
          ),
        ),
      ),
    );
  }
}
