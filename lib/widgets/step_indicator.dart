import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.currentStep,
    this.steps = const ['Infos perso', 'E-mail', 'CIN', 'Permis', 'Validation'],
    this.light = false,
  });

  final int currentStep;
  final List<String> steps;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final step = index + 1;
        final done = step < currentStep;
        final active = step == currentStep;
        final circleColor = active || done
            ? AppColors.primary
            : (light ? Colors.white24 : const Color(0xFFE5ECF3));
        final textColor = active
            ? AppColors.primary
            : (light ? Colors.white70 : AppColors.textMuted);
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: done
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : Text(
                        '$step',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: active ? Colors.white : textColor,
                        ),
                      ),
              ),
              const SizedBox(height: 5),
              Text(
                steps[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8.5,
                  height: 1.1,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
