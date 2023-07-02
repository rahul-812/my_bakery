import 'dart:ui';

mixin LightColors {
  static const Color main = Color(0xff23cf96);
  static const Color text = Color(0xff41454c);
  static const Color textMedium = Color(0xff5b5e65);
  static const Color lightText = Color(0xff97a1b6);
  static const Color warning = Color(0xfff27968);
  static const Color shadow = Color(0x230054ff);
  static const Color greyCard = Color(0xfff7f7f7);
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
