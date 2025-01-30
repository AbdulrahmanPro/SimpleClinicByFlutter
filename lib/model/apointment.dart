class AddorEditAppointmentDTO {
  final int id;
  final int patientId;
  final String? personName;
  final int? doctorId;
  final String? doctorName;
  final String? specialization;
  final DateTime appointmentDate;
  final int? appointmentStatus;
  final int? medicalRecordId;
  final int? paymentId;

  const AddorEditAppointmentDTO(
      {required this.id,
      required this.patientId,
      this.personName,
      this.doctorId,
      this.doctorName,
      this.specialization,
      required this.appointmentDate,
      this.appointmentStatus,
      this.medicalRecordId,
      this.paymentId});

  factory AddorEditAppointmentDTO.fromJson(Map<String, dynamic> json) {
    return AddorEditAppointmentDTO(
      id: json['id'],
      patientId: json['patientId'],
      personName: json['personName'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      specialization: json['specialization'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
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
      'appointmentDate': appointmentDate.toIso8601String(),
      'appointmentStatus': appointmentStatus,
      'medicalRecordId': medicalRecordId,
      'paymentId': paymentId,
    };
  }
}
