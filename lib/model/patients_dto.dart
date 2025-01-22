class PatientsDTO {
  final int id;
  int personId;

   PatientsDTO({
    required this.id,
    required this.personId,
  });

  factory PatientsDTO.fromJson(Map<String, dynamic> json) {
    return PatientsDTO(
      id: json['id'],
      personId: json['personId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
    };
  }
}
