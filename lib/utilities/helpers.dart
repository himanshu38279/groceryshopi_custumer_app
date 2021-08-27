
import 'package:intl/intl.dart';

class Helpers {
  Helpers._();

  static Map<String, String> getDisplayDateAndTime(DateTime dateTime) {
    DateFormat formatter;
    String displayTime;
    String displayDate;

    formatter = DateFormat('h:mm a');
    displayTime = formatter.format(dateTime);

    formatter = DateFormat('d MMMM yyyy');
    displayDate = formatter.format(dateTime);

    return {
      'displayTime': displayTime,
      'displayDate': displayDate,
    };
  }

  // static Future<String> getAppId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isIOS) {
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor;
  //   } else {
  //     var androidDeviceInfo = await deviceInfo.androidInfo;
  //     return androidDeviceInfo.androidId;
  //   }
  // }

  static String capitalize(String value) {
    if (value == null || value.trim() == "") return null;
    return value.split(' ').map(_capitalizeFirst).join(' ');
  }

  static String _capitalizeFirst(String s) {
    if (s == null || s.trim() == "") return null;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }
}
