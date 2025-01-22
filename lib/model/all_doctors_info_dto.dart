class AllDoctorsInfoDTO {
  final int id;
  final int personId;
  final String specialization;
  final String personName;
  final DateTime dateOfBirth;
  final String gender;
  final String phoneNumber;
  final String email;
  final String address;

  const AllDoctorsInfoDTO({
    required this.id,
    required this.personId,
    required this.specialization,
    required this.personName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  factory AllDoctorsInfoDTO.fromJson(Map<String, dynamic> json) {
    return AllDoctorsInfoDTO(
      id: json['id'],
      personId: json['personId'],
      specialization: json['specialization'],
      personName: json['personName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
      'specialization': specialization,
      'personName': personName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
    };
  }
}
