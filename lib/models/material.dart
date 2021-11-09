class Material {
  String? id;
  String? name;
  String? price;

  Material({this.id, this.name,this.price});

  factory Material.fromJson(Map<String, dynamic> json) {
    Material material = Material(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
    return material;
  }
}
