import 'package:flutter/material.dart';

class ScreenSize {
  static double fullHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double fullWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
}
