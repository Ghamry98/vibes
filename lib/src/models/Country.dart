import 'package:vibes/src/models/City.dart';

class Country {
  // Attributes
  int id;
  String name;
  List<City> states = [];

  // Constructor
  Country(this.id, this.name, this.states);

  // Mapping
  Country.fromJSON(Map<String, dynamic> data) {
    this.id = data["id"] as int;
    this.name = data["name"];

    if (data["states"] != null) {
      for (var state in data["states"]) {
        this.states.add(City.fromJSON(state));
      }
    }
  }

  // Methods
  /// Checks if the all country states are selected.
  bool get isSelected {
    try {
      bool result = true;

      states.forEach((state) {
        result = result && state.isSelected;
      });

      return result;
    } catch (e) {
      return true;
    }
  }

  /// Selects a certain country state.
  void selectState(int stateId) {
    try {
      for (var state in this.states) {
        if (state.id == stateId) {
          state.isSelected = true;
          break;
        }
      }
    } catch (e) {}
  }

  /// Unselects a certain country state.
  void unselectState(int stateId) {
    try {
      for (var state in this.states) {
        if (state.id == stateId) {
          state.isSelected = false;
          break;
        }
      }
    } catch (e) {}
  }

  /// Selects all the country states.
  void selectAllStates() {
    try {
      for (var state in this.states) {
        state.isSelected = true;
      }
    } catch (e) {}
  }

  /// Unselects all the country states.
  void unselectAllStates() {
    try {
      for (var state in this.states) {
        state.isSelected = false;
      }
    } catch (e) {}
  }

  /// Returns a list containing ids of the selected states in this country.
  List<int> getSelectedStatesIds() {
    try {
      List<int> result = [];

      for (var state in this.states) {
        if (state.isSelected) {
          result.add(state.id);
        }
      }
      return result;
    } catch (e) {
      return [];
    }
  }
}
