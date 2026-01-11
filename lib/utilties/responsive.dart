import 'package:flutter/widgets.dart';

class Responsive {
  static const MOBILE_DEVICE_WIDTH = 420;

  static getDeviceWidth(BuildContext buildContext) =>
      MediaQuery.of(buildContext).size.width;

  static bool isMobile(BuildContext buildContext) {
    //print(MediaQuery.of(buildContext).size.width);
    return getDeviceWidth(buildContext) > MOBILE_DEVICE_WIDTH ? false : true;
  }
}
