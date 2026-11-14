class AccessCode {
  const AccessCode({
    required this.code,
    required this.issuedAt,
    required this.expiresAt,
    required this.vehicleId,
  });

  final String code;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final String vehicleId;

  Duration get remaining {
    final value = expiresAt.difference(DateTime.now());
    return value.isNegative ? Duration.zero : value;
  }

  bool get isExpired => remaining == Duration.zero;
}
