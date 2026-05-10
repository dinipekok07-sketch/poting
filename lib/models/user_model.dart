class UserModel {
  final String id;
  final String nim;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime createdAt;
  final bool hasVoted;
  final String role;

  bool get isAdmin => role == 'admin';

  UserModel({
    required this.id,
    required this.nim,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    this.hasVoted = false,
    this.role = 'voter',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nim: json['nim'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      hasVoted: json['hasVoted'] ?? false,
      role: json['role'] ?? 'voter',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nim': nim,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'hasVoted': hasVoted,
      'role': role,
    };
  }

  UserModel copyWith({
    String? id,
    String? nim,
    String? name,
    String? email,
    String? phoneNumber,
    DateTime? createdAt,
    bool? hasVoted,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      nim: nim ?? this.nim,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      hasVoted: hasVoted ?? this.hasVoted,
      role: role ?? this.role,
    );
  }
}
