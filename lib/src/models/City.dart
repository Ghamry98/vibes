class City {
  // Attributes
  int id;
  String name;
  bool isSelected;

  // Constructor
  City(this.id, this.name, this.isSelected);

  // Mapping
  City.fromJSON(Map<String, dynamic> data) {
    this.id = data["id"] as int;
    this.name = data["name"];
    this.isSelected =
        data["is_selected"] != null ? data["is_selected"] as bool : false;
  }
}
