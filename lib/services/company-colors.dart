import 'package:flutter/material.dart';

class CompanyColors{
  CompanyColors._();

  static const Map<int, Color> _primary = const <int, Color> {
    100: const Color(0xE91A63)
  };

  static const Map<int, Color> _accent = const <int, Color> {
    100: const Color(0x536DFE)
  };

  static const Map<int, Color> _primaryText = const <int, Color> {
    100: const Color(0x757575)
  };

  static const Map<int, Color> _accentText = const <int, Color> {
    100: const Color(0x212121)
  };

    static const Map<int, Color> _textSelectHandle = const <int, Color> {
    100: const Color(0x424242)
  };

  static const Map<int, Color> _darkGrey = const <int, Color> {
    100: const Color(0x374046)
  };

  static MaterialColor primary = new MaterialColor(0x212121, _primary);
  static MaterialColor accent = new MaterialColor(0x212121, _accent);
  static MaterialColor primaryText = new MaterialColor(0x212121, _primaryText);
  static MaterialColor darkGrey = new MaterialColor(0x212121, _darkGrey);
  static MaterialColor accentText = new MaterialColor(0x212121, _accentText);
  static MaterialColor textSelectionHandle = new MaterialColor(0x424242, _textSelectHandle);

}