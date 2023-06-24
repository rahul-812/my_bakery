import 'dart:ui';

mixin LightColors {
  static const Color bg = Color(0xff1f1f1f);
  static const Color surface = Color(0xff363a3f);
  static const Color main = Color(0xff3869ff);
  static const Color secondary = Color(0xFF00D8B8);
  static const Color blue = Color(0xff062e6f);
  static const Color black = Color(0xff1f1f1f);
  static const Color grey = Color(0xffc4c7c5);
  static const Color greyM = Color(0xff7e7e7e);
  static const Color darkGrey = Color(0xFF50535A);
  static const Color blueGrey = Color(0xfff4f6fa);
  static const Color green = Color(0xff23cf96);
  static const Color red = Color(0xffee675c);
  static const Color orange = Color(0xFFF3B564);
  static const Color brown = Color(0xfff27968);
  static const Color bluishBlack = Color.fromARGB(255, 55, 57, 71);
}

class AccentColors {
  int _i = -1;

  Color get next {
    if (_i == 6) _i = -1;
    _i++;
    return _colors[_i];
  }

  final _colors = const [
    Color(0xFF5161DA),
    Color(0xffaf5cf7),
    Color(0xfffcc934),
    Color(0xfffa903e),
    Color(0xffee675c),
    Color(0xfff06292),
    Color(0xFFE64E81),
  ];
}

const padding = 18.0;
