class AppUser {
  const AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;

  String get fullName => '$firstName $lastName'.trim();

  AppUser copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return AppUser(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: '${json['id'] ?? ''}',
      firstName: '${json['firstName'] ?? json['first_name'] ?? ''}',
      lastName: '${json['lastName'] ?? json['last_name'] ?? ''}',
      email: '${json['email'] ?? ''}',
      phone: json['phone'] as String?,
    );
  }
}
