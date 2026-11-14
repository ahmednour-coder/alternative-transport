import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/brand_logo.dart';

class BrandScreen extends StatelessWidget {
  const BrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDeep,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppConstants.heroWelcome,
            fit: BoxFit.cover,
            alignment: const Alignment(0, 0.1),
            errorBuilder: (context, error, stackTrace) =>
                const ColoredBox(color: AppColors.navy),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xF2081C33),
                  Color(0x99081C33),
                  Color(0x55081C33),
                  Color(0xF2081C33),
                ],
                stops: [0, 0.32, 0.62, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 26),
              child: Column(
                children: [
                  Row(
                    children: [
                      _RoundIcon(
                        icon: Icons.chevron_left_rounded,
                        onTap: () => Navigator.maybePop(context),
                      ),
                      const Spacer(),
                      const BrandLogo(size: 46, light: true),
                    ],
                  ),
                  const SizedBox(height: 26),
                  const BrandLogo(size: 92, light: true),
                  const SizedBox(height: 18),
                  const Text(
                    'Alternative Transport',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Petits véhicules.\nGrands trajets.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      color: Color(0xFFD7E7F6),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: const [
                      Expanded(
                        child: _Feature(
                          icon: Icons.bolt_rounded,
                          title: '100 %',
                          subtitle: 'Électrique',
                        ),
                      ),
                      Expanded(
                        child: _Feature(
                          icon: Icons.power_settings_new_rounded,
                          title: 'Simple',
                          subtitle: 'à utiliser',
                        ),
                      ),
                      Expanded(
                        child: _Feature(
                          icon: Icons.eco_rounded,
                          title: 'Plus propre',
                          subtitle: 'pour la planète',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.welcome,
                      (route) => false,
                    ),
                    child: const Text(
                      'Découvrir l’application',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF4CD37B), width: 1.6),
          ),
          child: Icon(icon, color: const Color(0xFF4CD37B), size: 25),
        ),
        const SizedBox(height: 9),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: Color(0xFFB9D3EC)),
        ),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x33FFFFFF),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
