import 'package:vibes/src/models/Language.dart';
import 'package:vibes/src/providers/BaseProvider.dart';

class LanguagesProvider extends BaseProvider {
  static List<Language> _allLanguages = [
    Language(0, "English", "en"),
    Language(1, "French", "fr"),
    Language(2, "German", "de"),
    Language(3, "Spanish", "es"),
    Language(4, "Italian", "it"),
    Language(5, "Russian", "ru"),
    Language(6, "Hindi", "hi"),
    Language(7, "Japanese", "ja"),
    Language(8, "Turkish", "tr"),
    Language(9, "Chinese (S)", "zh"),
  ];

  List<Language> get allLanguages => _allLanguages;
}
