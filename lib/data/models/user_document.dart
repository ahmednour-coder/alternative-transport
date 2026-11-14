enum DocumentStatus { validated, pending, rejected }

extension DocumentStatusLabel on DocumentStatus {
  String get label => switch (this) {
        DocumentStatus.validated => 'Validé',
        DocumentStatus.pending => 'En attente',
        DocumentStatus.rejected => 'Refusé',
      };
}

class UserDocument {
  const UserDocument({
    required this.id,
    required this.label,
    required this.status,
    required this.description,
    this.reference,
  });

  final String id;
  final String label;
  final DocumentStatus status;
  final String description;
  final String? reference;

  UserDocument copyWith({DocumentStatus? status}) {
    return UserDocument(
      id: id,
      label: label,
      status: status ?? this.status,
      description: description,
      reference: reference,
    );
  }
}
