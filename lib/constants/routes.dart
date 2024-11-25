import 'package:flutter/material.dart';

class RoutingService {
  ///Navigate Push
  static goto(BuildContext context, Widget nextScreen) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ),
    );
  }

  static gotoAndBackUntil(BuildContext context, Widget nextScreen) {
    //  Navigator.pushAndRemoveUntil(context);
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => nextScreen,
        ),
        (Route<dynamic> route) => false);
  }

  ///Navigate Without Back
  static gotoWithoutBack(
    BuildContext context,
    Widget nextScreen,
  ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ),
    );
  }

  ///Navigate Untill Remove
  static gotoUtillBack(
    BuildContext context,
    Widget nextScreen,
  ) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => nextScreen,
        ),
        (route) => false);
  }

  ///Pop Navigate
  static goBack(BuildContext context, {var result}) {
    Navigator.pop(context, result);
  }
}
