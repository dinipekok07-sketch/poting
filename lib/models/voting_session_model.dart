class VotingSessionModel {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int totalVotes;

  VotingSessionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.totalVotes = 0,
  });

  factory VotingSessionModel.fromJson(Map<String, dynamic> json) {
    return VotingSessionModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? false,
      totalVotes: json['totalVotes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'totalVotes': totalVotes,
    };
  }

  VotingSessionModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    int? totalVotes,
  }) {
    return VotingSessionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      totalVotes: totalVotes ?? this.totalVotes,
    );
  }

  bool isSessionEnded() {
    return DateTime.now().isAfter(endDate);
  }

  bool hasSessionStarted() {
    return DateTime.now().isAfter(startDate);
  }
}
