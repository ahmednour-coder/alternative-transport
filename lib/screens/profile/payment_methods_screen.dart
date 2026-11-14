import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/screen_header.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentCard {
  _PaymentCard({
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.holder,
    this.isDefault = false,
  });

  final String brand;
  final String last4;
  final String expiry;
  final String holder;
  bool isDefault;
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<_PaymentCard> _cards = [
    _PaymentCard(
      brand: 'Visa',
      last4: '4242',
      expiry: '09/28',
      holder: 'AHMED NOUR SDIRI',
      isDefault: true,
    ),
    _PaymentCard(
      brand: 'Mastercard',
      last4: '8810',
      expiry: '03/27',
      holder: 'AHMED NOUR SDIRI',
    ),
  ];

  _PaymentCard get _defaultCard =>
      _cards.firstWhere((card) => card.isDefault, orElse: () => _cards.first);

  void _setDefault(_PaymentCard card) {
    setState(() {
      for (final item in _cards) {
        item.isDefault = item == card;
      }
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${card.brand} •••• ${card.last4} par défaut.')),
      );
  }

  Future<void> _addCard() async {
    final number = TextEditingController();
    final holder = TextEditingController();
    final expiry = TextEditingController();
    final added = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Ajouter une carte',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                label: 'Numéro de carte',
                hint: '1234 5678 9012 3456',
                controller: number,
                keyboardType: TextInputType.number,
                maxLength: 19,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Titulaire',
                hint: 'Nom sur la carte',
                controller: holder,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Expiration',
                hint: 'MM/AA',
                controller: expiry,
                keyboardType: TextInputType.datetime,
                maxLength: 5,
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
              final digits = number.text.replaceAll(RegExp(r'\D'), '');
              if (digits.length < 12 || holder.text.trim().isEmpty) {
                ScaffoldMessenger.of(dialogContext)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Vérifiez le numéro et le titulaire.'),
                    ),
                  );
                return;
              }
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
    if (added != true || !mounted) return;
    final digits = number.text.replaceAll(RegExp(r'\D'), '');
    setState(() {
      _cards.add(
        _PaymentCard(
          brand: 'Carte',
          last4: digits.substring(digits.length - 4),
          expiry: expiry.text.trim().isEmpty ? '—' : expiry.text.trim(),
          holder: holder.text.trim().toUpperCase(),
        ),
      );
    });
    number.dispose();
    holder.dispose();
    expiry.dispose();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Carte ajoutée.')));
  }

  void _remove(_PaymentCard card) {
    if (_cards.length == 1) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Ajoutez une autre carte avant.')),
        );
      return;
    }
    setState(() {
      _cards.remove(card);
      if (card.isDefault) _cards.first.isDefault = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultCard = _defaultCard;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScreenHeader(title: 'Moyens de paiement'),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.navy, AppColors.primary],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          defaultCard.brand,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.contactless_rounded,
                          color: Color(0xFFCFE3F7),
                          size: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      '••••  ••••  ••••  ${defaultCard.last4}',
                      style: const TextStyle(
                        fontSize: 18,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TITULAIRE',
                              style: TextStyle(
                                fontSize: 8,
                                letterSpacing: 1,
                                color: Color(0xFFBFD8EF),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              defaultCard.holder,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'EXPIRE',
                              style: TextStyle(
                                fontSize: 8,
                                letterSpacing: 1,
                                color: Color(0xFFBFD8EF),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              defaultCard.expiry,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Mes cartes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 10),
              for (final card in _cards)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: card.isDefault
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.pale,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            card.brand == 'Visa' ? 'VISA' : 'MC',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${card.brand} •••• ${card.last4}',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                              Text(
                                'Expire ${card.expiry}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (card.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Par défaut',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        else
                          IconButton(
                            onPressed: () => _setDefault(card),
                            icon: const Icon(
                              Icons.star_border_rounded,
                              size: 19,
                              color: AppColors.textLight,
                            ),
                            tooltip: 'Définir par défaut',
                          ),
                        IconButton(
                          onPressed: () => _remove(card),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 19,
                            color: AppColors.textLight,
                          ),
                          tooltip: 'Supprimer',
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              AppButton(
                label: 'Ajouter une carte',
                variant: AppButtonVariant.outline,
                icon: Icons.add_rounded,
                onPressed: _addCard,
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.pale,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 17,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Paiement sécurisé. Aucun numéro de carte complet n’est stocké sur l’appareil.',
                        style: TextStyle(
                          fontSize: 10.5,
                          height: 1.4,
                          color: AppColors.textMuted,
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
}
