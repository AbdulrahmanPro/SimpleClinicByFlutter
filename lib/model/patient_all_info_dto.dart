class PatientAllInfoDTO {
  final int id;
  final int personId;
  final String? personName;
  final String dateOfBirth;
  final String? gender;
  final String? phoneNumber;
  final String? email;
  final String? address;

  const PatientAllInfoDTO({
    required this.id,
    required this.personId,
    this.personName,
    required this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    this.email,
    this.address,
  });

  factory PatientAllInfoDTO.fromJson(Map<String, dynamic> json) {
    return PatientAllInfoDTO(
      id: json['id'],
      personId: json['personId'],
      personName: json['personName'],
      dateOfBirth: json['dateOfBirth'],
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
      'personName': personName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
    };
  }
}
