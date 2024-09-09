import 'package:flutter/widgets.dart';

extension MediaQueryValues on BuildContext {
  double get h => MediaQuery.of(this).size.height;//817
  double get w => MediaQuery.of(this).size.width;//384

  // Adding radius getter based on screen width
  double r(double factor) {
    return w * factor;
  }

  double sp(double factor) {
    return w * factor;
  }



}
