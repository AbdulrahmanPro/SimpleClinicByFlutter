class PaymentDTO {
  final int id;
  final String? paidPatient;
  final String paymentDate;
  final int paymentMethodId;
  final String? paymentMethod;
  final double amountPaid;
  final String? additionalNotes;

  const PaymentDTO({
    required this.id,
    this.paidPatient,
    required this.paymentDate,
    required this.paymentMethodId,
    this.paymentMethod,
    required this.amountPaid,
    this.additionalNotes,
  });

  factory PaymentDTO.fromJson(Map<String, dynamic> json) {
    return PaymentDTO(
      id: json['id'],
      paidPatient: json['paidPatient'],
      paymentDate: json['paymentDate'],
      paymentMethodId: json['paymentMethodId'],
      paymentMethod: json['paymentMethod'],
      amountPaid: json['amountPaid'],
      additionalNotes: json['additionalNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paidPatient': paidPatient,
      'paymentDate': paymentDate,
      'paymentMethodId': paymentMethodId,
      'paymentMethod': paymentMethod,
      'amountPaid': amountPaid,
      'additionalNotes': additionalNotes,
    };
  }
}
