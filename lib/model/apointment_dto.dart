class AppointmentDTO {
  final int id;
  final int patientId;
  final String? personName;
  final int? doctorId;
  final String? doctorName;
  final String? specialization;
  final String appointmentDate;
  final String? appointmentStatus;
  final int? medicalRecordId;
  final int? paymentId;

  const AppointmentDTO({
    required this.id,
    required this.patientId,
    this.personName,
    this.doctorId,
    this.doctorName,
    this.specialization,
    required this.appointmentDate,
    this.appointmentStatus,
    this.medicalRecordId,
    this.paymentId
  });

  factory AppointmentDTO.fromJson(Map<String, dynamic> json) {
    return AppointmentDTO(
      id: json['id'],
      patientId: json['patientId'],
      personName: json['personName'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      specialization: json['specialization'],
      appointmentDate: json['appointmentDate'],
      appointmentStatus: json['appointmentStatus'],
      medicalRecordId: json['medicalRecordId'],
      paymentId: json['paymentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'personName': personName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialization': specialization,
      'appointmentDate': appointmentDate,
      'appointmentStatus': appointmentStatus,
      'medicalRecordId': medicalRecordId,
      'paymentId': paymentId,
    };
  }
}
