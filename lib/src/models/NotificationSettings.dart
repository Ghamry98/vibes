import 'package:flutter/material.dart';
import 'package:vibes/src/models/Option.dart';
import 'package:vibes/config/AppLocalizations.dart';

class NotificationSettings {
  // Attributes
  bool push;
  bool inapp;
  bool email;

  bool notifyLike;
  bool notifyComment;
  bool notifyFollow;
  bool notifyNewsletter;

  // Constructor
  NotificationSettings(
    this.push,
    this.inapp,
    this.email,
    this.notifyLike,
    this.notifyComment,
    this.notifyFollow,
    this.notifyNewsletter,
  );

  // Mapping
  NotificationSettings.fromJSON(Map<String, dynamic> data) {
    this.push = data["push"] != null ? data["push"] as bool : false;
    this.inapp = data["inapp"] != null ? data["inapp"] as bool : false;
    this.email = data["email"] != null ? data["email"] as bool : false;

    this.notifyLike =
        data["notify_like"] != null ? data["notify_like"] as bool : false;
    this.notifyComment =
        data["notify_comment"] != null ? data["notify_comment"] as bool : false;
    this.notifyFollow =
        data["notify_follow"] != null ? data["notify_follow"] as bool : false;
    this.notifyNewsletter = data["notify_newsletter"] != null
        ? data["notify_newsletter"] as bool
        : false;
  }

  /// Constructs a NotificationSettings object from a list of options.
  NotificationSettings.fromList(List<Option> options) {
    try {
      this.push = options[0].value;
      this.inapp = options[1].value;
      this.email = options[2].value;
      this.notifyLike = options[3].value;
      this.notifyComment = options[4].value;
      this.notifyFollow = options[5].value;
      this.notifyNewsletter = options[6].value;
    } catch (e) {}
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "push": this.push,
      "inapp": this.inapp,
      "email": this.email,
      "notify_like": this.notifyLike,
      "notify_comment": this.notifyComment,
      "notify_follow": this.notifyFollow,
      "notify_newsletter": this.notifyNewsletter
    };
    return map;
  }

  // Methods
  /// Returns a list of options from a NotificationSettings object.
  List<Option> toList(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return [
      Option(0, localizations.translate("notifications_settings_option_1_2"),
          push),
      Option(1, localizations.translate("notifications_settings_option_1_3"),
          inapp),
      Option(2, localizations.translate("notifications_settings_option_1_1"),
          email),
      Option(3, localizations.translate("notifications_settings_option_2_1"),
          notifyLike),
      Option(4, localizations.translate("notifications_settings_option_2_3"),
          notifyComment),
      Option(5, localizations.translate("notifications_settings_option_2_4"),
          notifyFollow),
      Option(6, localizations.translate("notifications_settings_option_2_5"),
          notifyNewsletter),
    ];
  }
}
