class Device {
  String id;
  String deviceUID;
  String platform;
  String os;
  String name;
  String ip;
  String docId;
  String isAllowed;
  String dateCreated;

  Device(
      {this.id,this.deviceUID, this.os, this.name,this.platform, this.ip, this.isAllowed,this.docId,this.dateCreated});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
        id : json['id']==null? "N/A":json['id'],
        deviceUID : json['device_uid']==null? "N/A":json['device_uid'],
        platform : json['platform']==null? "N/A":json['platform'],
        os : json['os_id']==null? "N/A":json['os_id'],
        name : json['device_name']==null? "N/A":json['device_name'],
      ip : json['ip']==null? "N/A":json['ip'],
      isAllowed : json['is_allowed']==null? "N/A":json['is_allowed'],
      docId : json['user_id']==null? "N/A":json['user_id'],
      dateCreated : json['date_created']==null? "N/A":json['date_created'],
    );
  }
}