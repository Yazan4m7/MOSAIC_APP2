class JobType {
  String id;
  String name;


  JobType({this.id, this.name});

  factory JobType.fromJson(Map<String, dynamic> json) {
    JobType jobType = JobType(
      id: json['id'],
      name: json['name'],
    );
    return jobType;
  }
}
