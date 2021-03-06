class Case {
  String id;
  String orderId;
  String patientName;
  String deliveryDate;
  String currentStatus;
  String doctorId;
  String createdBy;
  String createdAt;

  Case({
    required this.id,
    required this.orderId,
    required this.patientName,
    required this.deliveryDate,
    required this.currentStatus,
    required this.doctorId,
    required this.createdBy,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'Case{id: $id, orderId: $orderId, patientName: $patientName, deliveryDate: $deliveryDate, currentStatus: $currentStatus, doctorId: $doctorId, createdBy: $createdBy, createdAt: $createdAt}';
  }

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      id: json['id'],
      orderId: json['order_id'],
      patientName: json['patient_name'],
      currentStatus: json['current_status'],
      doctorId: json['doctor_id'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      deliveryDate: json['deliver_date'],
    );
  }
}
