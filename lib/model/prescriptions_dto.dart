class PrescriptionsDTO {
  final int prescriptionID;
  final int medicalRecordID;
  final String? medicationName;
  final String? dosage;
  final String? frequency;
  final String startDate;
  final String endDate;
  final String? specialInstructions;

  const PrescriptionsDTO({
    required this.prescriptionID,
    required this.medicalRecordID,
    this.medicationName,
    this.dosage,
    this.frequency,
    required this.startDate,
    required this.endDate,
    this.specialInstructions,
  });

  factory PrescriptionsDTO.fromJson(Map<String, dynamic> json) {
    return PrescriptionsDTO(
      prescriptionID: json['prescriptionID'],
      medicalRecordID: json['medicalRecordID'],
      medicationName: json['medicationName'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      specialInstructions: json['specialInstructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prescriptionID': prescriptionID,
      'medicalRecordID': medicalRecordID,
      'medicationName': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'startDate': startDate,
      'endDate': endDate,
      'specialInstructions': specialInstructions,
    };
  }
}
