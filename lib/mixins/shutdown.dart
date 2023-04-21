import "dart:io";
import "package:flutter/services.dart";


mixin AppCloser {
  void closeApp() {
    if (Platform.isAndroid) {
      SystemChannels.platform.invokeListMethod('SystemNavigator.pop');
    }
  }
}
