//palette.dart
import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor yek = MaterialColor(
    0xff28313B, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color.fromARGB(230, 40, 49, 59), //10%40, 49, 59
      100: Color.fromARGB(205, 40, 49, 59), //20%
      200: Color.fromARGB(180, 40, 49, 59), //30%
      300: Color.fromARGB(155, 40, 49, 59), //40%
      400: Color.fromARGB(130, 40, 49, 59), //50%
      500: Color.fromARGB(105, 40, 49, 59), //60%
      600: Color.fromARGB(80, 40, 49, 59), //70%
      700: Color.fromARGB(55, 40, 49, 59), //80%
      800: Color.fromARGB(30, 40, 49, 59), //90%
      900: Color.fromARGB(5, 40, 49, 59), //100%
    },
  );
}
