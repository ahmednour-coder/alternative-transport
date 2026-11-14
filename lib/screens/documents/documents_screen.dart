import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/user_document.dart';
import '../../providers/document_provider.dart';
import '../../widgets/status_badge.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  bool _checking = false;

  Color _iconBackground(UserDocument document) => switch (document.status) {
        DocumentStatus.validated => const Color(0xFFDDF1E5),
        DocumentStatus.pending => const Color(0xFFFBE9C9),
        DocumentStatus.rejected => AppColors.redSoft,
      };

  Color _iconColor(UserDocument document) => switch (document.status) {
        DocumentStatus.validated => AppColors.green,
        DocumentStatus.pending => AppColors.amber,
        DocumentStatus.rejected => AppColors.red,
      };

  StatusBadge _badge(UserDocument document) => switch (document.status) {
        DocumentStatus.validated => const StatusBadge(label: 'Validé'),
        DocumentStatus.pending => const StatusBadge(
            label: 'En attente',
            foreground: AppColors.amber,
            background: AppColors.amberSoft,
          ),
        DocumentStatus.rejected => const StatusBadge(
            label: 'Refusé',
            foreground: AppColors.red,
            background: AppColors.redSoft,
          ),
      };

  Future<void> _refresh() async {
    setState(() => _checking = true);
    await ref.read(documentsProvider.notifier).validatePending();
    if (!mounted) return;
    setState(() => _checking = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Vérifications mises à jour.')),
      );
  }

  void _showDetails(List<UserDocument> documents, {UserDocument? focus}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  focus?.label ?? 'Mes documents',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Documents vérifiés par notre équipe sous 24 h.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 16),
                for (final document in documents)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: document.id == focus?.id
                            ? AppColors.primarySoft
                            : AppColors.pale,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  document.label,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ),
                              _badge(document),
                            ],
                          ),
                          const SizedBox(height: 7),
                          Text(
                            document.description,
                            style: const TextStyle(
                              fontSize: 10.5,
                              height: 1.45,
                              color: AppColors.textMuted,
                            ),
                          ),
                          if (document.reference != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              document.reference!,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('Fermer'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final documents = ref.watch(documentsProvider);
    final pending =
        documents.any((document) => document.status == DocumentStatus.pending);

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
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.maybePop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.chevron_left_rounded,
                            size: 26,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Mes documents',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                        ),
                        const Spacer(),
                        if (pending)
                          TextButton(
                            onPressed: _checking ? null : _refresh,
                            child: _checking
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Actualiser'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vos documents personnels sont chiffrés et ne sont jamais partagés avec des tiers.',
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.45,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 18),
                    for (final document in documents)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _showDetails(documents, focus: document),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: _iconBackground(document),
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: Icon(
                                    Icons.description_rounded,
                                    color: _iconColor(document),
                                    size: 21,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        document.label,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      _badge(document),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: AppColors.textLight,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.add_circle_outline_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Un document à renouveler ?',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Le justificatif de domicile doit dater de moins de 3 mois.',
                            style: TextStyle(
                              fontSize: 10.5,
                              height: 1.4,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () => _showDetails(documents),
                            icon: const Icon(Icons.upload_file_rounded, size: 17),
                            label: const Text('Voir les détails'),
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
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () => _showDetails(documents),
                  child: const Text('Voir les détails'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
