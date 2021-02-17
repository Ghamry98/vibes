import 'package:vibes/src/models/City.dart';
import 'package:vibes/src/models/Country.dart';
import 'package:vibes/src/providers/BaseProvider.dart';
import 'package:vibes/src/services/CountriesService.dart';
import 'package:vibes/config/SetupLocator.dart';

class CountriesProvider extends BaseProvider {
  final CountriesService _countriesService = locator<CountriesService>();

  static List<Country> _allCountries = [];
  static List<Country> _followedCountries = [];

  List<Country> get allCountries => _allCountries;
  List<Country> get followedCountries => _followedCountries;
  List<City> get allStates {
    try {
      List<City> states = [];

      _allCountries.forEach((country) {
        states += country.states;
      });

      return states;
    } catch (e) {
      return [];
    }
  }

  List<City> get followedStates {
    try {
      List<City> states = [];

      _followedCountries.forEach((country) {
        states += country.states;
      });

      return states;
    } catch (e) {
      return [];
    }
  }

  Future<bool> fetchCountries() async {
    try {
      _allCountries = await _countriesService.getUserCountries();
      _followedCountries = _allCountries;
      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCountries() async {
    try {
      setState(ViewState.busy);
      await _countriesService.updateCountries(_followedCountries);

      setState(ViewState.idle);

      return true;
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  void updateFollowedCountries(List<Country> items) {
    _followedCountries.clear();
    _followedCountries.addAll(items);
    notifyListeners();
  }

  void unfollowCountry(int countryId) {
    try {
      if (_followedCountries != null) {
        for (var country in _followedCountries) {
          if (country.id == countryId) {
            country.unselectAllStates();
            notifyListeners();
            break;
          }
        }
      }
    } catch (e) {}
  }

  void unfollowState(int countryId, int stateId) {
    try {
      if (_followedCountries != null) {
        for (var country in _followedCountries) {
          if (country.id == countryId) {
            country.unselectState(stateId);
            notifyListeners();
            break;
          }
        }
      }
    } catch (e) {}
  }

  static bool clearData() {
    try {
      if (_allCountries != null) {
        _allCountries.clear();
      }
      if (_followedCountries != null) {
        _followedCountries.clear();
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
