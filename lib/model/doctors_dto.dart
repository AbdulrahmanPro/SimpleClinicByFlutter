class DoctorsDTO {
  final int id;
  final int personId;  // الشخص المعني
  final String specialization;

  DoctorsDTO({
    required this.id,
    required this.personId,
    required this.specialization,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
      'specialization': specialization,
    };
  }

  factory DoctorsDTO.fromJson(Map<String, dynamic> json) {
    return DoctorsDTO(
      id: json['id'],
      personId: json['personId'],
      specialization: json['specialization'],
    );
  }

  // دالة copyWith لإنشاء نسخة جديدة من DoctorsDTO مع تعديل الخصائص التي نريدها
  DoctorsDTO copyWith({
    int? id,
    int? personId,
    String? specialization,
  }) {
    return DoctorsDTO(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      specialization: specialization ?? this.specialization,
    );
  }
}
