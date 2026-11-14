import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/document_provider.dart';
import '../../widgets/app_button.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  Timer? _timer;
  bool _emailVerified = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      setState(() => _emailVerified = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _finish() {
    ref.read(authProvider.notifier).completeVerification();
    ref.read(documentsProvider.notifier).validatePending();
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
          child: Column(
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    size: 104,
                    color: AppColors.primary,
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _emailVerified ? 1 : 0.35,
                    child: const Icon(
                      Icons.check_rounded,
                      size: 46,
                      color: Color(0xFF4CD37B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'Vérification en cours',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _emailVerified
                    ? 'Vos documents sont vérifiés. Bienvenue chez Alternative Transport !'
                    : 'Nous vérifions vos documents et votre permis de conduire.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: Color(0xFFB9D3EC),
                ),
              ),
              const SizedBox(height: 28),
              const _CheckRow(label: 'CIN recto', done: true),
              const SizedBox(height: 10),
              const _CheckRow(label: 'CIN verso', done: true),
              const SizedBox(height: 10),
              const _CheckRow(label: 'Permis de conduire', done: true),
              const SizedBox(height: 10),
              _CheckRow(label: 'Vérification de l’e-mail', done: _emailVerified),
              const Spacer(),
              if (_emailVerified)
                AppButton(
                  label: 'Continuer',
                  onPressed: _finish,
                )
              else
                const Text(
                  'Cela peut prendre quelques minutes.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF8FAECB)),
                ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: done ? const Color(0xFF123A63) : const Color(0xFF0F2C4C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: done ? const Color(0xFF1B4B7A) : const Color(0xFF14385E),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            height: 26,
            child: done
                ? Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CD37B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 17,
                      color: Colors.white,
                    ),
                  )
                : const CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation(Color(0xFF7FA7CC)),
                  ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          if (done)
            const Text(
              'Vérifié',
              style: TextStyle(
                fontSize: 10.5,
                color: Color(0xFF9FDDB4),
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
