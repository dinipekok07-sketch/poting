class CandidateModel {
  final int id;
  final String name1;
  final String name2;
  final String visi;
  final String misi;
  final int voteCount;
  final String? photoUrl1;
  final String? photoUrl2;

  CandidateModel({
    required this.id,
    required this.name1,
    required this.name2,
    required this.visi,
    required this.misi,
    this.voteCount = 0,
    this.photoUrl1,
    this.photoUrl2,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      id: json['id'] ?? 0,
      name1: json['name1'] ?? '',
      name2: json['name2'] ?? '',
      visi: json['visi'] ?? '',
      misi: json['misi'] ?? '',
      voteCount: json['voteCount'] ?? 0,
      photoUrl1: json['photoUrl1'],
      photoUrl2: json['photoUrl2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name1': name1,
      'name2': name2,
      'visi': visi,
      'misi': misi,
      'voteCount': voteCount,
      'photoUrl1': photoUrl1,
      'photoUrl2': photoUrl2,
    };
  }

  CandidateModel copyWith({
    int? id,
    String? name1,
    String? name2,
    String? visi,
    String? misi,
    int? voteCount,
    String? photoUrl1,
    String? photoUrl2,
  }) {
    return CandidateModel(
      id: id ?? this.id,
      name1: name1 ?? this.name1,
      name2: name2 ?? this.name2,
      visi: visi ?? this.visi,
      misi: misi ?? this.misi,
      voteCount: voteCount ?? this.voteCount,
      photoUrl1: photoUrl1 ?? this.photoUrl1,
      photoUrl2: photoUrl2 ?? this.photoUrl2,
    );
  }

  String get getNames => '$name1 & $name2';
}
