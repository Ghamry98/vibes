import 'package:dio/dio.dart';
import 'package:vibes/src/models/Country.dart';
import 'package:vibes/config/SetupLocator.dart';

class CountriesService {
  Dio dio = locator<Dio>();

  Future<List<Country>> getUserCountries() async {
    try {
      Response response = await dio.get("/user/country");

      List<Country> _list = [];
      for (var item in response.data["list"]) {
        _list.add(Country.fromJSON(item));
      }

      return _list;
    } catch (e) {
      // print(e);
      return null;
    }
  }

  Future<bool> updateCountries(List<Country> countries) async {
    try {
      List<int> stateIds = [];
      if (countries != null) {
        countries.forEach((country) {
          stateIds += country.getSelectedStatesIds();
        });
      }

      Map<String, dynamic> data = {"countries": stateIds};

      await dio.post("/user/country", data: data);

      return true;
    } catch (e) {
      return null;
    }
  }
}
