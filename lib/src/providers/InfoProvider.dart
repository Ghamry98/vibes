import 'package:vibes/src/providers/BaseProvider.dart';
import 'package:vibes/src/services/InfoService.dart';
import 'package:vibes/config/SetupLocator.dart';
import 'package:vibes/src/models/Info.dart';

class InfoProvider extends BaseProvider {
  final InfoService infoService = locator<InfoService>();

  static Info _info;

  Future<bool> fetchInfo() async {
    try {
      setState(ViewState.busy);
      _info = await infoService.getInfo();
      setState(ViewState.idle);
      return true;
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }

      return false;
    }
  }

  Info get info => _info;
}
