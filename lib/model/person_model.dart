class PersonModel {
  final int id;
  final String personName;
  final DateTime dateOfBirth;
  final String gender;
  final String phoneNumber;
  String email;
  final String address;

  PersonModel({
    required this.id,
    required this.personName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  // Factory method to create a Person from a JSON map
  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      personName: json['personName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
    );
  }

  // Method to convert a Person object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personName': personName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
    };
  }

  PersonModel copyWith({
    int? id,
    String? personName,
    DateTime? dateOfBirth,
    String? gender,
    String? phoneNumber,
    String? email,
    String? address,
  }) {
    return PersonModel(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }
}
