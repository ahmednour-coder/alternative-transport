import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/step_indicator.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _lastName = TextEditingController();
  final _firstName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  String? _lastNameError;
  String? _firstNameError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _lastName.dispose();
    _firstName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    final lastNameError = Validators.required(_lastName.text, 'votre nom');
    final firstNameError = Validators.required(_firstName.text, 'votre prénom');
    final emailError = Validators.email(_email.text);
    final passwordError = Validators.password(_password.text);

    setState(() {
      _lastNameError = lastNameError;
      _firstNameError = firstNameError;
      _emailError = emailError;
      _passwordError = passwordError;
    });
    if (lastNameError != null ||
        firstNameError != null ||
        emailError != null ||
        passwordError != null) {
      return;
    }

    FocusScope.of(context).unfocus();
    final success = await ref.read(authProvider.notifier).register(
          firstName: _firstName.text,
          lastName: _lastName.text,
          email: _email.text,
          password: _password.text,
        );

    if (!mounted) return;
    if (success) {
      Navigator.pushNamed(
        context,
        AppRoutes.otp,
        arguments: _email.text.trim().toLowerCase(),
      );
    } else {
      final message = ref.read(authProvider).error ?? 'Inscription impossible.';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider.select((state) => state.loading));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 22, 26, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.navy,
                      size: 26,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Étape 1 sur 5',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Créer un compte',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Rejoignez Alternative Transport et profitez d’une mobilité simple et durable.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 22),
              const StepIndicator(currentStep: 1),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Nom',
                hint: 'Votre nom',
                controller: _lastName,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                errorText: _lastNameError,
                onChanged: (_) {
                  if (_lastNameError != null) {
                    setState(() => _lastNameError = null);
                  }
                },
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Prénom',
                hint: 'Votre prénom',
                controller: _firstName,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                errorText: _firstNameError,
                onChanged: (_) {
                  if (_firstNameError != null) {
                    setState(() => _firstNameError = null);
                  }
                },
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'E-mail',
                hint: 'exemple@mail.com',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                errorText: _emailError,
                onChanged: (_) {
                  if (_emailError != null) {
                    setState(() => _emailError = null);
                  }
                },
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Mot de passe',
                hint: 'Votre mot de passe',
                controller: _password,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                errorText: _passwordError,
                onSubmitted: (_) => _next(),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 19,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              AppButton(
                label: 'Suivant',
                loading: loading,
                onPressed: _next,
              ),
              const SizedBox(height: 18),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'Vous avez déjà un compte ? ',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Après cette étape : vérification e-mail, CIN et permis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10.5, color: AppColors.textLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
