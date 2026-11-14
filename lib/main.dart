import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: AlternativeTransportApp()));
}

/// Route de départ : celle demandée par l'URL (ex. http://localhost:8080/#/profil)
/// ou '/' par défaut, ce qui affiche l'écran de démarrage.
String get _initialRoute {
  final name = WidgetsBinding.instance.platformDispatcher.defaultRouteName;
  return name.isEmpty ? AppRoutes.splash : name;
}

class AlternativeTransportApp extends StatelessWidget {
  const AlternativeTransportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alternative Transport',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('fr', 'FR'),
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: _initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 620 || child == null) {
              return child ?? const SizedBox.shrink();
            }
            final height = math.min(constraints.maxHeight - 32, 920.0);
            return ColoredBox(
              color: AppColors.navyDeep,
              child: Center(
                child: Container(
                  width: 430,
                  height: height,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 40,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
