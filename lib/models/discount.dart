class Discount {
  String id;
  String doctorId;
  String materialId;
  String discount;
  String type;

  @override
  String toString() {
    return 'Discount{id: $id, doctorId: $doctorId, materialId: $materialId, discount: $discount, type: $type}';
  }

  Discount({this.id, this.doctorId, this.materialId, this.discount, this.type});

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'] == null ? "N/A" : json['id'],
      doctorId: json['doctor_id'] == null ? "N/A" : json['doctor_id'],
      materialId: json['material_id'] == null ? "N/A" : json['material_id'],
      discount: json['discount'] == null ? "N/A" : json['discount'],
      type: json['type'] == null ? "N/A" : json['type'],
    );
  }
}
