/// Service Bluetooth simulé : il reproduit les étapes d'un appairage réel
/// (recherche, connexion, vérification de l'accès) sans dépendre d'un plugin.
class BleService {
  const BleService();

  Future<void> connect({
    required void Function(BleStep step) onStep,
    required bool Function() isCancelled,
    Duration stepDelay = const Duration(milliseconds: 950),
  }) async {
    for (final step in BleStep.values) {
      await Future<void>.delayed(stepDelay);
      if (isCancelled()) return;
      onStep(step);
    }
  }
}

enum BleStep { searching, connecting, verifying }
