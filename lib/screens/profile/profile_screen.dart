import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_bottom_nav.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _openTab(BuildContext context, int index) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.tabFor(index));
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Se déconnecter ?',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'Vous devrez vous reconnecter pour réserver un véhicule.',
          style: TextStyle(fontSize: 12.5, color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    ref.read(authProvider.notifier).logout();
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final name = user?.fullName ?? 'Utilisateur Alternative Transport';
    final email = user?.email ?? 'contact@alternative.tn';
    final initials = user == null
        ? 'AT'
        : initialsOf(user.firstName, user.lastName);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greenSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Compte vérifié',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.personalInfo,
                    ),
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 19,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _MenuRow(
                icon: Icons.person_outline_rounded,
                label: 'Informations personnelles',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.personalInfo),
              ),
              _MenuRow(
                icon: Icons.folder_open_rounded,
                label: 'Mes documents',
                onTap: () => Navigator.pushNamed(context, AppRoutes.documents),
              ),
              _MenuRow(
                icon: Icons.credit_card_rounded,
                label: 'Moyens de paiement',
                onTap: () => Navigator.pushNamed(context, AppRoutes.payments),
              ),
              _MenuRow(
                icon: Icons.tune_rounded,
                label: 'Préférences',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.preferences),
              ),
              _MenuRow(
                icon: Icons.help_outline_rounded,
                label: 'Aide & support',
                onTap: () => Navigator.pushNamed(context, AppRoutes.support),
              ),
              _MenuRow(
                icon: Icons.info_outline_rounded,
                label: 'À propos de l’application',
                onTap: () => Navigator.pushNamed(context, AppRoutes.brand),
              ),
              const SizedBox(height: 8),
              const Divider(),
              _MenuRow(
                icon: Icons.logout_rounded,
                label: 'Déconnexion',
                color: AppColors.red,
                showChevron: false,
                onTap: () => _logout(context, ref),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Alternative Transport · version 1.0.0',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textLight.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        onTap: (index) => _openTab(context, index),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.navy,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(icon, size: 19, color: color.withValues(alpha: 0.75)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            if (showChevron)
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textLight,
              ),
          ],
        ),
      ),
    );
  }
}
