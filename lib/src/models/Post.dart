import 'package:flutter/material.dart';
import 'package:vibes/src/models/Comment.dart';
import 'package:vibes/src/models/MarkedText.dart';
import 'package:vibes/src/models/Media.dart';
import 'package:vibes/src/models/User.dart';
import 'package:vibes/utils/Constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibes/utils/Helpers.dart';

enum PostType {
  dining,
  traveling,
  shopping,
  outing,
  all_mobile,
  trending_mobile,
  none
}
enum PostsListSort { date, likes }

class Post {
  // Attributes
  int id;
  PostType type;
  String title;
  String description;
  DateTime creationDate;

  Position location;
  String address;

  User author;
  String countryCode;

  int numberOfLikes = 0;
  int numberOfComments = 0;

  List<Media> media = [];

  bool isLiked = false;
  bool isSaved = false;
  bool isTrending = false;

  List<Comment> comments = [];

  // Extras
  List<MarkedText> markedText = [];
  String translatedTitle;
  String translatedDescription;
  List<MarkedText> translatedMarkedText = [];
  bool showTranslation = false;

  // Constructors
  Post.basic();

  Post(
    this.id,
    this.type,
    this.title,
    this.description,
    this.creationDate,
    this.location,
    this.address,
    this.author,
    this.numberOfLikes,
    this.isTrending,
    this.isSaved,
    this.media,
  );

  // Mapping
  Post.simple(Map<String, dynamic> data) {
    this.id = data["id"] as int;
    this.type = _getPostType(data["type"]);
    this.title = data["title"] != null ? data["title"] : "";
  }

  Post.homeResponse(Map<String, dynamic> data) {
    this.id = data["id"] as int;
    this.type = _getPostType(data["type"]);
    this.title = data["title"] != null ? data["title"] : "";
    this.description = data["description"] != null ? data["description"] : "";
    this.creationDate = DateTime.tryParse(data["created_at"]);

    this.address = data["address"] != null ? data["address"] : null;

    this.author = data["owner"] != null ? User.basic(data["owner"]) : null;

    this.numberOfLikes =
        data["number_likes"] != null ? data["number_likes"] as int : 0;
    this.numberOfComments =
        data["no_of_comments"] != null ? data["no_of_comments"] as int : 0;

    this.isLiked = data["is_liked"] != null ? data["is_liked"] as bool : null;
    this.isSaved = data["is_saved"] != null ? data["is_saved"] as bool : false;
    this.isTrending =
        data["is_trending"] != null ? data["is_trending"] as bool : false;

    if (data["media_collection"] != null) {
      for (var element in data["media_collection"]) {
        this.media.add(Media.fromJSON(element));
      }
    }

    this.numberOfLikes =
        data["no_of_likes"] != null ? data["no_of_likes"] as int : 0;
    this.numberOfComments =
        data["no_of_comments"] != null ? data["no_of_comments"] as int : 0;

    this.markedText = markText(this.description);
  }

  Post.detailed(Map<String, dynamic> data) {
    this.id = data["id"] as int;
    this.type = _getPostType(data["type"]);
    this.title = data["title"] != null ? data["title"] : "";
    this.description = data["description"] != null ? data["description"] : "";

    this.creationDate = DateTime.tryParse(data["created_at"]);

    this.address = data["address"] != null ? data["address"] : null;

    this.author = data["owner"] != null ? User.basic(data["owner"]) : null;

    this.isLiked = data["is_liked"] != null ? data["is_liked"] as bool : null;
    this.isSaved = data["is_saved"] != null ? data["is_saved"] as bool : false;
    this.isTrending =
        data["is_trending"] != null ? data["is_trending"] as bool : false;

    if (data["media_collection"] != null) {
      for (var element in data["media_collection"]) {
        this.media.add(Media.fromJSON(element));
      }
    }

    this.markedText = markText(this.description);

    this.numberOfLikes =
        data["no_of_likes"] != null ? data["no_of_likes"] as int : 0;
    this.numberOfComments =
        data["no_of_comments"] != null ? data["no_of_comments"] as int : 0;

    if (data["comments"] != null) {
      for (var element in data["comments"]) {
        this.comments.add(Comment.fromJSON(element));
      }
    }
  }

  Map toMap() {
    List<Map<String, dynamic>> _list = [];

    for (var item in media) {
      if (item.isFileValid) {
        _list.add(item.toMap());
      }
    }

    Map<String, dynamic> map = {
      "type": type.toString().replaceAll("PostType.", ""),
      "title": title,
      "description": description,
      "media": _list,
    };

    if (countryCode != null) {
      map["country"] = countryCode;
    }
    if (location != null) {
      map["latitude"] = location.latitude;
      map["longitude"] = location.latitude;
    }
    if (address != null && address.isNotEmpty) {
      map["address"] = address;
    }

    this.markedText = markText(this.description);
    return map;
  }

  // Methods
  /// Returns the sharing link url of that post.
  String get sharingLink => Constants.frontUrl + "/posts/" + this.id.toString();

  /// Returns a formatted localized datetime string that indicates the post elapsed time.
  String elapsedTime(BuildContext context, {bool isLongFormat = false}) =>
      Helpers.getElapsedTime(creationDate, context, isLongFormat);

  /// Returns a list of marked text.
  static List<MarkedText> markText(String description) =>
      Helpers.markText(description);

  static PostType _getPostType(String type) {
    try {
      switch (type.toLowerCase()) {
        case "dining":
          return PostType.dining;
        case "traveling":
          return PostType.traveling;
        case "shopping":
          return PostType.shopping;
        case "outing":
          return PostType.outing;
        default:
          return PostType.none;
      }
    } catch (e) {
      return PostType.none;
    }
  }
}
