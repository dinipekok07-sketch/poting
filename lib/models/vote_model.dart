class VoteModel {
  final String id;
  final String userId;
  final int candidateId;
  final DateTime votedAt;
  final String ipAddress;

  VoteModel({
    required this.id,
    required this.userId,
    required this.candidateId,
    required this.votedAt,
    required this.ipAddress,
  });

  factory VoteModel.fromJson(Map<String, dynamic> json) {
    return VoteModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      candidateId: json['candidateId'] ?? 0,
      votedAt: DateTime.parse(json['votedAt'] ?? DateTime.now().toIso8601String()),
      ipAddress: json['ipAddress'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'candidateId': candidateId,
      'votedAt': votedAt.toIso8601String(),
      'ipAddress': ipAddress,
    };
  }

  VoteModel copyWith({
    String? id,
    String? userId,
    int? candidateId,
    DateTime? votedAt,
    String? ipAddress,
  }) {
    return VoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      candidateId: candidateId ?? this.candidateId,
      votedAt: votedAt ?? this.votedAt,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}
