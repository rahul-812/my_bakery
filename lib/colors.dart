import 'dart:ui';

mixin LightColors {
  static const Color bg = Color(0xff1f1f1f);
  static const Color main = Color(0xff3869ff);
  static const Color secondary = Color(0xFF00D8B8);
  static const Color textColor = Color(0xff394347);
  static const Color textMediumColor = Color(0xFF50535a);
  static const Color lightTextColor = Color(0xff97a1b6);
  static const Color warningColor = Color(0xfff27968);
  static const Color shadowColor = Color(0x230054ff);
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
