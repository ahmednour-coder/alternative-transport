import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/brand_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
            alignment: const Alignment(0, -0.1),
            errorBuilder: (context, error, stackTrace) => const ColoredBox(
              color: AppColors.navy,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xE6081C33),
                  Color(0x66081C33),
                  Color(0x33081C33),
                  Color(0xF2081C33),
                ],
                stops: [0, 0.28, 0.58, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const BrandLogo(size: 74, light: true),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.brand),
                        icon: const Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFFCFE3F7),
                          size: 21,
                        ),
                        tooltip: 'À propos',
                      ),
                    ],
                  ),
                  const Spacer(flex: 5),
                  const Text(
                    'Alternative\nTransport',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      height: 1.02,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Roulez plus propre,\naujourd’hui et demain.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xFFD7E7F6),
                    ),
                  ),
                  const Spacer(flex: 3),
                  AppButton(
                    label: 'Commencer',
                    variant: AppButtonVariant.light,
                    height: 56,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.login),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.login),
                    child: Text.rich(
                      TextSpan(
                        text: 'Déjà un compte ? ',
                        style: const TextStyle(
                          color: Color(0xFFD7E7F6),
                          fontSize: 12,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Se connecter',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ],
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
