import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/screen_header.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _pushNotifications = true;
  bool _tripReminders = true;
  bool _emailReceipts = true;
  bool _dataSaver = false;
  bool _preciseLocation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenHeader(title: 'Préférences'),
              const SizedBox(height: 20),
              const _SectionTitle('Notifications'),
              _SwitchRow(
                title: 'Notifications push',
                subtitle: 'Réservations, messages et alertes',
                value: _pushNotifications,
                onChanged: (value) => setState(() => _pushNotifications = value),
              ),
              _SwitchRow(
                title: 'Rappels de réservation',
                subtitle: '15 minutes avant le début du trajet',
                value: _tripReminders,
                onChanged: (value) => setState(() => _tripReminders = value),
              ),
              _SwitchRow(
                title: 'Reçus par e-mail',
                subtitle: 'Un reçu détaillé après chaque trajet',
                value: _emailReceipts,
                onChanged: (value) => setState(() => _emailReceipts = value),
              ),
              const SizedBox(height: 18),
              const _SectionTitle('Application'),
              InkWell(
                onTap: () => _showLanguage(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.language_rounded,
                        size: 19,
                        color: AppColors.navy,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Langue',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      const Text(
                        'Français',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: AppColors.textLight,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              _SwitchRow(
                title: 'Localisation précise',
                subtitle: 'Pour afficher les véhicules les plus proches',
                value: _preciseLocation,
                onChanged: (value) => setState(() => _preciseLocation = value),
              ),
              _SwitchRow(
                title: 'Économiser les données',
                subtitle: 'Réduit la qualité des images de la carte',
                value: _dataSaver,
                onChanged: (value) => setState(() => _dataSaver = value),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.verified_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Vos préférences sont enregistrées sur cet appareil.',
                        style: TextStyle(
                          fontSize: 10.5,
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
    );
  }

  void _showLanguage(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choisir la langue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text('Français'),
                trailing: const Icon(Icons.check_rounded, color: AppColors.primary),
                onTap: () => Navigator.pop(sheetContext),
              ),
              ListTile(
                title: const Text('العربية'),
                subtitle: const Text('Bientôt disponible'),
                enabled: false,
                onTap: () {},
              ),
              ListTile(
                title: const Text('English'),
                subtitle: const Text('Bientôt disponible'),
                enabled: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.textMuted,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
