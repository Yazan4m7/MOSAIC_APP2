
class DBAccountStatement {
  String? id;
  String? patientName;
  String? credit;
  String? debit;
  String? balance;
  String? doctorId;
  String? createdAt;


  DBAccountStatement({this.id, this.patientName, this.credit,this.debit, this.doctorId,
      this.balance, this.createdAt});



  factory DBAccountStatement.fromJson(Map<String, dynamic> json) {
    return DBAccountStatement(
        id : json['id']==null? "N/A":json['id'],
        patientName : json['patient_name']==null? "N/A":json['patient_name'],
        balance : json['balance']==null? "N/A":json['balance'],
      credit : json['credit']==null? "N/A":json['credit'],
      debit : json['debit']==null? "N/A":json['debit'],
      doctorId : json['doctor_id']==null? "N/A":json['doctor_id'],
      createdAt : json['created_at']==null? "N/A":json['created_at'],

    );
  }
}