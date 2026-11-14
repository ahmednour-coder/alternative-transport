import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/screen_header.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _faq = [
    (
      question: 'Comment réserver un véhicule ?',
      answer:
          'Depuis l’accueil, choisissez un véhicule à proximité, sélectionnez vos dates puis confirmez la réservation. Un code d’accès temporaire est généré automatiquement.',
    ),
    (
      question: 'Comment fonctionne le code d’accès ?',
      answer:
          'Le code à 4 chiffres est valable 15 minutes. Il permet de déverrouiller le véhicule via la connexion Bluetooth sécurisée.',
    ),
    (
      question: 'Que faire si le véhicule ne se connecte pas ?',
      answer:
          'Vérifiez que le Bluetooth est activé et rapprochez-vous du véhicule. Si le problème persiste, annulez puis relancez la connexion depuis l’écran du véhicule.',
    ),
    (
      question: 'Comment sont vérifiés mes documents ?',
      answer:
          'La CIN et le permis sont contrôlés automatiquement puis validés par notre équipe. Le justificatif de domicile est vérifié sous 24 heures.',
    ),
    (
      question: 'Comment obtenir un reçu ?',
      answer:
          'À la fin du trajet, appuyez sur « Voir le reçu ». Tous vos reçus restent disponibles dans l’historique des réservations.',
    ),
  ];

  void _copy(BuildContext context, String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label copié.')));
  }

  Future<void> _sendMessage(BuildContext context) async {
    final subject = TextEditingController();
    final message = TextEditingController();
    final sent = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Contacter le support',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                label: 'Objet',
                hint: 'Réservation, paiement, compte…',
                controller: subject,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Message',
                hint: 'Décrivez votre demande',
                controller: message,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              if (message.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Écrivez votre message.')),
                  );
                return;
              }
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
    subject.dispose();
    message.dispose();
    if (sent == true && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Message envoyé. Réponse sous 24 h ouvrées.'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenHeader(title: 'Aide & support'),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.navy, AppColors.primaryDark],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Besoin d’un coup de main ?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Notre équipe répond du lundi au samedi, de 8 h à 19 h.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.45,
                              color: Color(0xFFCFE3F7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Questions fréquentes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    for (final item in _faq)
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: const EdgeInsets.only(bottom: 12),
                          title: Text(
                            item.question,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                          iconColor: AppColors.primary,
                          collapsedIconColor: AppColors.textLight,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.answer,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  height: 1.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nous contacter',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _ContactRow(
                      icon: Icons.mail_outline_rounded,
                      label: 'support@alternative.tn',
                      onTap: () => _copy(
                        context,
                        'support@alternative.tn',
                        'E-mail',
                      ),
                    ),
                    _ContactRow(
                      icon: Icons.phone_outlined,
                      label: '+216 70 000 000',
                      onTap: () => _copy(context, '+216 70 000 000', 'Téléphone'),
                    ),
                    _ContactRow(
                      icon: Icons.location_on_outlined,
                      label: 'Avenue Habib Bourguiba, Tunis',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 14),
              child: AppButton(
                label: 'Envoyer un message',
                onPressed: () => _sendMessage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
            const Icon(
              Icons.copy_rounded,
              size: 15,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
