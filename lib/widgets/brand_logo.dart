import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Monogramme « AT » + nom de la marque.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 64,
    this.showText = false,
    this.light = false,
    this.centered = false,
  });

  final double size;
  final bool showText;
  final bool light;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final mark = SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            top: -size * 0.06,
            child: Text(
              'A',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: size * 0.92,
                height: 1,
                fontWeight: FontWeight.w700,
                color: light ? Colors.white : AppColors.primary,
                shadows: light
                    ? const [
                        Shadow(
                          color: Color(0x66000000),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Text(
              'T',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: size * 0.78,
                height: 1,
                fontWeight: FontWeight.w700,
                color: light ? const Color(0xFFBFE0FF) : AppColors.navy,
                shadows: light
                    ? const [
                        Shadow(
                          color: Color(0x66000000),
                          blurRadius: 14,
                          offset: Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ],
      ),
    );

    if (!showText) return mark;

    final text = Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Alternative',
          style: TextStyle(
            fontSize: size * 0.28,
            height: 1.05,
            fontWeight: FontWeight.w800,
            color: light ? Colors.white : AppColors.navy,
          ),
        ),
        Text(
          'Transport',
          style: TextStyle(
            fontSize: size * 0.28,
            height: 1.05,
            fontWeight: FontWeight.w800,
            color: light ? Colors.white : AppColors.navy,
          ),
        ),
      ],
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          centered ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        mark,
        SizedBox(width: size * 0.14),
        text,
      ],
    );
  }
}
