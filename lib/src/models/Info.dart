class Info {
  // Attributes
  String about;
  String helpCenter;
  String privacyPolicy;
  String termsAndConditions;

  // Constructor
  Info(
    this.about,
    this.helpCenter,
    this.privacyPolicy,
    this.termsAndConditions,
  );

  // Mapping
  Info.fromJSON(Map<String, dynamic> data) {
    this.about = data["about"];
    this.helpCenter = data["help_center"];
    this.privacyPolicy = data["privacy_policy"];
    this.termsAndConditions = data["terms_conditions"];
  }
}
