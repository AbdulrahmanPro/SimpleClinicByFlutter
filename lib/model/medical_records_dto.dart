class MedicalRecordsDTO {
  final int medicalRecordID;
  final String? visitDescription;
  final String? diagnosis;
  final String? additionalNotes;

  const MedicalRecordsDTO({
    required this.medicalRecordID,
    this.visitDescription,
    this.diagnosis,
    this.additionalNotes,
  });

  factory MedicalRecordsDTO.fromJson(Map<String, dynamic> json) {
    return MedicalRecordsDTO(
      medicalRecordID: json['medicalRecordID'],
      visitDescription: json['visitDescription'],
      diagnosis: json['diagnosis'],
      additionalNotes: json['additionalNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicalRecordID': medicalRecordID,
      'visitDescription': visitDescription,
      'diagnosis': diagnosis,
      'additionalNotes': additionalNotes,
    };
  }
}
