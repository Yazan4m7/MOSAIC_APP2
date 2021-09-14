import 'dart:convert';

class CCPaymentResponse{
  int transactionId;
  bool isSuccess;
  String message;
  List<dynamic> errors;

  String errDescription;
  CCPaymentResponse({this.transactionId, this.isSuccess, this.message, this.errors,this.errDescription});


  @override
  String toString() {
    return 'CCPaymentResponse{transactionId: $transactionId, isSuccess: $isSuccess, message: $message, errors: $errors,errDescription: $errDescription}';
  }

  factory CCPaymentResponse.fromJson(Map<String, dynamic> jsonObj) {
    print("jsonObj ${jsonObj['errors'].isEmpty}");
    print(jsonObj.containsValue(['errors']));
    return CCPaymentResponse(
      transactionId : jsonObj['transactionId']==null? null:jsonObj['transactionId'] as int,
      isSuccess : jsonObj['isSuccess']==null? "N/A":jsonObj['isSuccess'] as bool,
      message : jsonObj['message']==null? "N/A":jsonObj['message'],
      errors : jsonObj['errors']==null? "N/A":(jsonObj['errors']),

      errDescription : jsonObj['errors'].isEmpty? "N/A" : jsonObj['errors'][0]['description']
    );
  }
}