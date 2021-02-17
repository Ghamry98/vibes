import 'package:vibes/src/models/Feed.dart';
import 'package:vibes/src/models/Media.dart';
import 'package:vibes/src/models/NotificationSettings.dart';
import 'package:vibes/utils/Helpers.dart';

enum UserRole { admin, client, seller, guest }
enum BadgeType { verified, trending }
enum SocialLoginType { facebook, google, twitter }

class User {
  // Attributes
  int id;
  String name;
  String mobile;
  Media avatar;
  String email;
  String address;
  DateTime creationDate;
  String bio;
  UserRole role;
  List<BadgeType> badges = [];

  bool isActive;
  bool isPrivate = false;
  bool needPasswordChange = false;

  int numberOfPosts = 0;
  int numberOfFollowers = 0;
  int numberOfFollowing = 0;

  NotificationSettings notificationSettings;

  // Extras
  List<Feed> allFeeds;
  List<Feed> posts;
  List<Feed> comments;
  List<Feed> interactions;

  // Constructors
  User.simple(
    this.id,
    this.name,
    this.avatar,
    this.role,
  );

  User.advanced(
    this.id,
    this.name,
    this.mobile,
    this.avatar,
    this.email,
    this.address,
    this.bio,
    this.role,
    this.badges,
  );

  // Mapping
  User.basic(Map<String, dynamic> data) {
    this.id = data["id"] as int;
    this.name = data["name"] != null ? data["name"] : "";
    this.avatar = data["avatar"] != null ? Media.image(data["avatar"]) : null;

    this.role =
        data["role"] != null ? _getUserRole(data["role"]) : UserRole.client;

    if (data["badge"] != null) {
      for (var badge in data["badge"]) {
        if (badge != null) {
          this.badges.add(_getUserBadge(badge));
        }
      }
    }

    this.isPrivate =
        data["is_private"] != null ? data["is_private"] as bool : false;
  }

  User.fromJSON(Map<String, dynamic> data) {
    this.id = data["id"] as int;
    this.name = data["name"] != null ? data["name"] : "";
    this.mobile = data["mobile"] != null ? data["mobile"] : null;

    this.avatar = data["avatar"] != null ? Media.image(data["avatar"]) : null;

    this.email = data["email"] != null ? data["email"] : null;
    this.address = data["address"] != null ? data["address"] : null;

    this.creationDate = data["creation_date"] != null
        ? DateTime.tryParse(data["creation_date"])
        : null;
    this.bio = data["bio"] != null ? data["bio"] : null;
    this.role =
        data["role"] != null ? _getUserRole(data["role"]) : UserRole.client;

    if (data["badge"] != null) {
      for (var badge in data["badge"]) {
        if (badge != null) {
          this.badges.add(_getUserBadge(badge));
        }
      }
    }

    this.isActive =
        data["is_active"] != null ? data["is_active"] as bool : null;
    this.isPrivate =
        data["is_private"] != null ? data["is_private"] as bool : false;
    this.needPasswordChange = data["need_password_change"] != null
        ? data["need_password_change"] as bool
        : false;

    this.numberOfPosts =
        data["no_of_posts"] != null ? data["no_of_posts"] as int : 0;
    this.numberOfFollowers =
        data["no_of_followers"] != null ? data["no_of_followers"] as int : 0;
    this.numberOfFollowing =
        data["no_of_following"] != null ? data["no_of_following"] as int : 0;

    this.notificationSettings = NotificationSettings.fromJSON(data);
  }

  User.fromToken(String token) {
    Map<String, dynamic> data = Helpers.parseJwt(token);

    this.id = data["id"];
    this.name = data["name"] != null ? data["name"] : "";
    this.mobile = data["mobile"] != null ? data["mobile"] : null;

    this.avatar = data["avatar"] != null ? Media.image(data["avatar"]) : null;

    this.email = data["email"] != null ? data["email"] : null;
    this.address = data["address"] != null ? data["address"] : null;

    this.role =
        data["role"] != null ? _getUserRole(data["role"]) : UserRole.client;

    if (data["badge"] != null) {
      for (var badge in data["badge"]) {
        if (badge != null) {
          this.badges.add(_getUserBadge(badge));
        }
      }
    }

    this.isActive =
        data["is_active"] != null ? data["is_active"] as bool : true;
    this.isPrivate =
        data["is_private"] != null ? data["is_private"] as bool : false;
    this.needPasswordChange = data["need_password_change"] != null
        ? data["need_password_change"] as bool
        : false;
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "name": name,
      "mobile": mobile,
      "avatar": avatar?.url,
      "email": email,
      "address": address,
    };
    return map;
  }

  // Methods
  static BadgeType _getUserBadge(String badge) {
    try {
      switch (badge.toLowerCase()) {
        case "verified":
          return BadgeType.verified;
        case "trending":
          return BadgeType.trending;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  static UserRole _getUserRole(String role) {
    try {
      switch (role.toLowerCase()) {
        case "admin":
          return UserRole.admin;
        case "client":
          return UserRole.client;
        case "seller":
          return UserRole.seller;
        case "guest":
          return UserRole.guest;
        default:
          return UserRole.client;
      }
    } catch (e) {
      return UserRole.client;
    }
  }

  /// Returns a string containing the first letter of the first two words in the user name (if exists).
  ///
  /// If the user name consists of only one word, it will return only the first character of that word.
  String get nickname => Helpers.getUserNickname(this.name);

  /// Returns the url of the user avatar if exists.
  String get avatarUrl =>
      this.avatar != null && this.avatar.url != null ? this.avatar.url : null;

  /// Returns a formatted datetime string that represents the creation date of the user.
  String get formattedCreationDate =>
      Helpers.getformattedCreationDate(creationDate);
}
