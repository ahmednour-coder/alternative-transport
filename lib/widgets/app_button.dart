import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

enum AppButtonVariant { primary, outline, danger, light }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final double height;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final style = switch (variant) {
      AppButtonVariant.primary => FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        ),
      AppButtonVariant.outline => OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.border),
        ),
      AppButtonVariant.danger => FilledButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
        ),
      AppButtonVariant.light => FilledButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.navy,
        ),
    };

    final onTap = loading ? null : onPressed;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: switch (variant) {
        AppButtonVariant.outline =>
          OutlinedButton(style: style, onPressed: onTap, child: child),
        _ => FilledButton(style: style, onPressed: onTap, child: child),
      },
    );
  }
}
