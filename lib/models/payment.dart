
class Payment {
  String id;
  String amount;
  String doctorId;
  String notes;
  String collector;
  String createdAt;


  Payment({this.id, this.amount,  this.doctorId, this.notes,this.collector,this.createdAt});



  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
        id : json['id']==null? "N/A":json['id'],
        amount : json['credit']==null? "N/A":json['credit'],
        doctorId : json['doctor_id']==null? "N/A":json['doctor_id'],
        notes : json['notes']==null? "N/A":json['notes'],
        collector : json['collector']==null? "N/A":json['collector'],
        createdAt : json['created_at']==null? "N/A":json['created_at']);
  }
}