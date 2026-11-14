abstract final class Validators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final _phone = RegExp(r'^\+?[0-9 ]{8,15}$');

  static String? email(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Saisissez votre adresse e-mail.';
    if (!_email.hasMatch(text)) return 'Adresse e-mail invalide.';
    return null;
  }

  static String? emailOrPhone(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Saisissez votre e-mail ou téléphone.';
    if (!_email.hasMatch(text) && !_phone.hasMatch(text)) {
      return 'Identifiant invalide.';
    }
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Saisissez votre mot de passe.';
    if (text.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères.';
    }
    return null;
  }

  static String? required(String? value, String label) {
    if ((value ?? '').trim().isEmpty) return 'Renseignez $label.';
    return null;
  }
}
