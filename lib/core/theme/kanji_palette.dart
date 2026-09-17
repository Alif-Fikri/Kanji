import 'package:flutter/material.dart';

class KanjiColor {
  final String name;
  final int value;

  const KanjiColor(this.name, this.value);

  Color get color => Color(value);
}

class KanjiPalette {
  static const int sumi = 0xFF1A1A1A;
  static const int shu = 0xFFB33A3A;
  static const int ai = 0xFF1F3A5F;
  static const int matcha = 0xFF5F7A4A;
  static const int sakura = 0xFFD98CA0;
  static const int kinari = 0xFFFDF6EC;
  static const int shiro = 0xFFFFFFFF;
  static const int kincha = 0xFFA8842C;

  static const List<KanjiColor> backgrounds = [
    KanjiColor('Cream', kinari),
    KanjiColor('White', shiro),
    KanjiColor('Black', sumi),
    KanjiColor('Indigo', ai),
    KanjiColor('Green', matcha),
    KanjiColor('Pink', sakura),
    KanjiColor('Red', shu),
  ];

  static const List<KanjiColor> texts = [
    KanjiColor('Black', sumi),
    KanjiColor('White', shiro),
    KanjiColor('Red', shu),
    KanjiColor('Indigo', ai),
    KanjiColor('Gold', kincha),
    KanjiColor('Cream', kinari),
  ];
}
