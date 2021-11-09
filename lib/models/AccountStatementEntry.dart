class AccountStatementEntry {
  String? id;
  String? patientName;
  String? credit;
  String? debit;
  String? balance;
  String? createdAt;
  String? doctorId;
  String? caseId;
  String? paymentId;

  @override
  String toString() {
    return 'AccountStatementEntry{id: $id, patientName: $patientName, credit: $credit, debit: $debit, balance: $balance, createdAt: $createdAt, doctorId: $doctorId, caseId: $caseId, paymentId: $paymentId}';
  }

  AccountStatementEntry({this.id, this.patientName, this.doctorId,
      this.balance, this.createdAt, this.credit,this.debit,this.caseId,this.paymentId});

  factory AccountStatementEntry.fromJson(Map<String, dynamic> json) {
    return AccountStatementEntry(
        id : json['id']==null? "N/A":json['id'],
        patientName : json['patient_name']==null? "N/A":json['patient_name'],
        balance : json['balance']==null? "N/A":json['balance'],
      credit : json['credit']==null? "N/A":json['credit'],
      debit : json['debit']==null? "N/A":json['debit'],
      doctorId : json['doctor_id']==null? "N/A":json['doctor_id'],
      createdAt : json['created_at']==null? "N/A":json['created_at'],
      caseId : json['case_id']==null? "N/A":json['case_id'],
      paymentId : json['payment_id']==null? "N/A":json['payment_id'],
    );
  }
}