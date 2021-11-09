import 'package:mosaic_doctors/services/implantsDatabase.dart';

class ImplantStatementRowModel {
  String? id;
  String? entry;
  String? qty;
  String? type;
  String? amount;
  String? balance;
  String? orderId;
  String? itemId;
  String? paymentId;
  String? createdAt;
  String? identifier;
  String? unitPrice;
  String? originalItemId;
  ImplantStatementRowModel({this.id, this.entry, this.qty,
      this.type, this.amount, this.balance,this.orderId,this.itemId,this.paymentId,this.createdAt,this.identifier,this.unitPrice,this.originalItemId});



  factory ImplantStatementRowModel.fromJson(Map<String, dynamic> json) {
    String type ='';


    return ImplantStatementRowModel(
        id : json['id']==null? "N/A":json['id'],
      entry : json['entry']==null? "N/A":json['entry'].replaceAll('Nobel','').replaceAll('mm','').replaceAll('CC','').replaceAll('NP','').replaceAll('WP','').replaceAll('RP','').replaceAll('Internal','').replaceAll('  ',' ').replaceAll('  ',' '),
      qty : json['qty']==null? "-":json['qty'],
      type : json['type']==null? "Payment": json['type'],
      amount : json['amount']==null? "N/A":json['amount'],
      balance : json['balance']==null? "N/A":json['balance'],
      orderId : json['order_id']==null? "N/A":json['order_id'],
      itemId : json['item_id']==null? "N/A":json['item_id'],
      paymentId : json['payment_id']==null? "N/A":json['payment_id'],
      createdAt : json['created_at']==null? "N/A":json['created_at'],
      identifier : json['identifier']==null? "N/A":json['identifier'],
      unitPrice : json['price']==null? "N/A":json['price'],
      originalItemId : json['orderItemId']==null? "N/A":json['orderItemId'],
    );
  }
}