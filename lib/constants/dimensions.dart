import 'package:flutter/material.dart';

class Dimensions {
  static double widthP(BuildContext context) {
    return MediaQuery.of(context).size.width / 428;
  }

  static double heightP(BuildContext context) {
    return MediaQuery.of(context).size.height / 926;
  }

  // Size without status-bar and navigation-bar
  static double heightF(BuildContext context) {
    return (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.bottom -
            MediaQuery.of(context).padding.top) /
        852;
  }
}
