import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/app_button.dart';

enum CaptureKind { cinRecto, cinVerso, permis }

class DocumentCaptureArgs {
  const DocumentCaptureArgs({required this.kind});

  final CaptureKind kind;
}

class DocumentCaptureScreen extends ConsumerStatefulWidget {
  const DocumentCaptureScreen({super.key, required this.kind});

  final CaptureKind kind;

  @override
  ConsumerState<DocumentCaptureScreen> createState() =>
      _DocumentCaptureScreenState();
}

class _DocumentCaptureScreenState extends ConsumerState<DocumentCaptureScreen> {
  bool _captured = false;

  bool get _isPermis => widget.kind == CaptureKind.permis;

  String get _title => switch (widget.kind) {
        CaptureKind.cinRecto => 'Carte d’identité\nnationale (recto)',
        CaptureKind.cinVerso => 'Carte d’identité\nnationale (verso)',
        CaptureKind.permis => 'Permis de conduire\n(code-barres / QR)',
      };

  String get _frameLabel =>
      _isPermis ? '[ Zone de scan ]' : '[ Photo du $_suffix ]';

  String get _suffix =>
      widget.kind == CaptureKind.cinRecto ? 'recto' : 'verso';

  List<String> get _tips => _isPermis
      ? const [
          'Scannez le code-barres ou le QR code',
          'Assurez-vous que le code est bien visible',
          'Le document doit être en bon état',
        ]
      : const [
          'Placez votre carte sur un fond clair',
          'Assurez-vous que toutes les informations sont bien visibles',
          'La photo doit être nette et lisible',
        ];

  Future<void> _capture() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
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
              Text(
                _isPermis ? 'Scanner le permis' : 'Ajouter une photo',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choisissez la source du document.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primarySoft,
                  child: Icon(Icons.camera_alt_rounded,
                      color: AppColors.primary, size: 20),
                ),
                title: Text(_isPermis ? 'Scanner avec la caméra' : 'Prendre la photo'),
                subtitle: const Text('Capture guidée par le cadre'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.pop(sheetContext, 'camera'),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primarySoft,
                  child: Icon(Icons.photo_library_rounded,
                      color: AppColors.primary, size: 20),
                ),
                title: const Text('Choisir depuis la galerie'),
                subtitle: const Text('Importer une image existante'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.pop(sheetContext, 'gallery'),
              ),
            ],
          ),
        ),
      ),
    );

    if (choice == null || !mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _isPermis ? 'Lecture du code…' : 'Traitement de la photo…',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Vérification de la netteté et de la lisibilité.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    setState(() => _captured = true);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _isPermis
                ? 'Code du permis lu avec succès.'
                : 'Photo du $_suffix enregistrée.',
          ),
        ),
      );
  }

  void _next() {
    if (!_captured) {
      _capture();
      return;
    }
    switch (widget.kind) {
      case CaptureKind.cinRecto:
        Navigator.pushNamed(
          context,
          AppRoutes.capture,
          arguments: const DocumentCaptureArgs(kind: CaptureKind.cinVerso),
        );
      case CaptureKind.cinVerso:
        Navigator.pushNamed(
          context,
          AppRoutes.capture,
          arguments: const DocumentCaptureArgs(kind: CaptureKind.permis),
        );
      case CaptureKind.permis:
        Navigator.pushReplacementNamed(context, AppRoutes.verification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 18),
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
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  _StepDots(kind: widget.kind),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _title,
                style: const TextStyle(
                  fontSize: 25,
                  height: 1.18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.62,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: _captured
                        ? const Color(0xFF0F4D3A)
                        : const Color(0xFF123A63),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _captured
                          ? const Color(0xFF4CD37B)
                          : const Color(0xFF1B4B7A),
                    ),
                  ),
                  child: Stack(
                    children: [
                      const _FrameCorners(),
                      Center(
                        child: _captured
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: Color(0xFF4CD37B),
                                    size: 52,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Document capturé',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isPermis
                                        ? Icons.qr_code_scanner_rounded
                                        : Icons.photo_camera_outlined,
                                    color: const Color(0xFF7FA7CC),
                                    size: 42,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _frameLabel,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFB9D3EC),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              ..._tips.map(
                (tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5, right: 9),
                        child: CircleAvatar(
                          radius: 2.5,
                          backgroundColor: Color(0xFFB9D3EC),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.45,
                            color: Color(0xFFD7E7F6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              AppButton(
                label: _captured
                    ? 'Continuer'
                    : (_isPermis ? 'Scanner le code' : 'Prendre la photo'),
                variant:
                    _captured ? AppButtonVariant.primary : AppButtonVariant.light,
                onPressed: _next,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _captured
                      ? 'Vous pouvez reprendre la photo si elle est floue.'
                      : 'Vos documents restent privés et chiffrés.',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF8FAECB),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.kind});

  final CaptureKind kind;

  @override
  Widget build(BuildContext context) {
    final active = switch (kind) {
      CaptureKind.cinRecto => 3,
      CaptureKind.cinVerso => 3,
      CaptureKind.permis => 4,
    };
    return Row(
      children: List.generate(5, (index) {
        final step = index + 1;
        final done = step < active || (step == 3 && active == 4);
        final current = step == active;
        return Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(left: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: done || current
                ? AppColors.primary
                : const Color(0xFF1B4B7A),
            shape: BoxShape.circle,
          ),
          child: done
              ? const Icon(Icons.check, size: 12, color: Colors.white)
              : Text(
                  '$step',
                  style: TextStyle(
                    fontSize: 9,
                    color:
                        current ? Colors.white : const Color(0xFF8FAECB),
                    fontWeight: FontWeight.w700,
                  ),
                ),
        );
      }),
    );
  }
}

class _FrameCorners extends StatelessWidget {
  const _FrameCorners();

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF4CD37B);
    const thickness = 3.0;
    const size = 34.0;
    return Stack(
      children: [
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: color, width: thickness),
                left: BorderSide(color: color, width: thickness),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: color, width: thickness),
                right: BorderSide(color: color, width: thickness),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: color, width: thickness),
                left: BorderSide(color: color, width: thickness),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: color, width: thickness),
                right: BorderSide(color: color, width: thickness),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
