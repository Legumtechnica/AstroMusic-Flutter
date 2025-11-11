import 'package:flutter/cupertino.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }

  // Convenience getters for backward compatibility
  static double? get height => screenHeight;
  static double? get width => screenWidth;
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight as double;
  // 812 is the layout height that designer use (iPhone X)
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate width as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth as double;
  // 375 is the layout width that designer use (iPhone X)
  return (inputWidth / 375.0) * screenWidth;
}

// Mixin to provide screen sizing helpers
mixin ScreenSizeMixin {
  double proportionateScreenHeight(double inputHeight) {
    return getProportionateScreenHeight(inputHeight);
  }

  double proportionateScreenWidth(double inputWidth) {
    return getProportionateScreenWidth(inputWidth);
  }
}

// Extension methods for convenient usage
extension SizeExtension on num {
  double get w => getProportionateScreenWidth(toDouble());
  double get h => getProportionateScreenHeight(toDouble());
}

// Global helper methods that can be used without context
double proportionateScreenHeight(double inputHeight) =>
    getProportionateScreenHeight(inputHeight);

double proportionateScreenWidth(double inputWidth) =>
    getProportionateScreenWidth(inputWidth);
