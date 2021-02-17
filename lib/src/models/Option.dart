class Option {
  // Attributes
  int id;
  String title;
  bool value;

  // Constructors
  Option(
    this.id,
    this.title,
    this.value,
  );

  // Mapping
  Option.fromJSON(Map<String, dynamic> data) {
    this.id = data["id"] as int;
    this.title = data["title"] != null ? data["title"] : null;
    this.value = data["value"] != null ? data["value"] as bool : null;
  }
}
