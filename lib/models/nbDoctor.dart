
class NbDoctor {
  String? id;
  String? name;
  String? unitsBoughtActive;
  String? unitsBoughtParallel;
  String? availableBonusActive;
  String? availableBonusParallel;
  String? consumedBonusActive;
  String? consumedBonusParallel;
  String? balance;
  String? phone;


  NbDoctor({this.id, this.name, this.unitsBoughtActive, this.unitsBoughtParallel,
      this.availableBonusActive, this.availableBonusParallel,
      this.consumedBonusActive, this.consumedBonusParallel, this.balance,
      this.phone});


  factory NbDoctor.fromJson(Map<String, dynamic> json) {
    return NbDoctor(
        id : json['id']==null? "N/A":json['id'],
        name : json['name']==null? "N/A":json['name'],
        balance : json['balance']==null? "N/A":json['balance'],
        phone : json['phone']==null? "N/A":json['phone'],
        unitsBoughtActive : json['units_bought_active']==null? "N/A":json['units_bought_active'],
        unitsBoughtParallel : json['units_bought_parallel']==null? "N/A":json['units_bought_parallel'],
        availableBonusActive : json['bonus_available_active']==null? "N/A":json['bonus_available_active'],
        availableBonusParallel : json['bonus_available_parallel']==null? "N/A":json['bonus_available_parallel'],
        consumedBonusActive : json['bonus_consumed_active']==null? "N/A":json['bonus_consumed_active'],
        consumedBonusParallel : json['bonus_consumed_parallel']==null? "N/A":json['bonus_consumed_parallel']
    );
  }
}