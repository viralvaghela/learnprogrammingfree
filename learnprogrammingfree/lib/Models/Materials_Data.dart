class MaterialData {
  int id;
  String name;
  String instructor;
  String url;
  String description;
  String image;
  List<String> tags;

  MaterialData(
      {this.id,
        this.name,
        this.instructor,
        this.url,
        this.description,
        this.image,
        this.tags});

  MaterialData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    instructor = json['instructor'];
    url = json['url'];
    description = json['description'];
    image = json['image'];
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['instructor'] = this.instructor;
    data['url'] = this.url;
    data['description'] = this.description;
    data['image'] = this.image;
    data['tags'] = this.tags;
    return data;
  }
}