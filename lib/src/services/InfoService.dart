import 'package:dio/dio.dart';
import 'package:vibes/src/models/Info.dart';
import 'package:vibes/config/SetupLocator.dart';

class InfoService {
  Dio dio = locator<Dio>();

  Future<Info> getInfo() async {
    try {
      Response response = await dio.get("/help");

      return Info.fromJSON(response.data['body']);
    } catch (e) {
      // print(e);
      return null;
    }
  }
}
