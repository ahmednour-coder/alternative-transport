import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/screen_header.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() =>
      _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _firstName = TextEditingController(text: user?.firstName ?? '');
    _lastName = TextEditingController(text: user?.lastName ?? '');
    _email = TextEditingController(text: user?.email ?? '');
    _phone = TextEditingController(text: user?.phone ?? '+216 ');
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    final error = Validators.email(_email.text) ??
        Validators.required(_firstName.text, 'votre prénom') ??
        Validators.required(_lastName.text, 'votre nom');
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    ref.read(authProvider.notifier).updateProfile(
          firstName: _firstName.text.trim(),
          lastName: _lastName.text.trim(),
          email: _email.text.trim().toLowerCase(),
        );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Informations mises à jour.')),
      );
    Navigator.maybePop(context);
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
                    const ScreenHeader(title: 'Informations personnelles'),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 86,
                        height: 86,
                        decoration: const BoxDecoration(
                          color: AppColors.primarySoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 42,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Votre identité doit correspondre à vos documents.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    AppTextField(
                      label: 'Nom',
                      hint: 'Votre nom',
                      controller: _lastName,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Prénom',
                      hint: 'Votre prénom',
                      controller: _firstName,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'E-mail',
                      hint: 'exemple@mail.com',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _error,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Téléphone',
                      hint: '+216 00 000 000',
                      controller: _phone,
                      keyboardType: TextInputType.phone,
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
                              'Ces informations servent uniquement à vérifier votre éligibilité à la location.',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 14),
              child: AppButton(label: 'Enregistrer', onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }
}
