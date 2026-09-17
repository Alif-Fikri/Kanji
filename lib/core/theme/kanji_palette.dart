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
  static const int kinari = 0xFFFDF6EC;
  static const int sakura = 0xFFD98CA0;

  static const List<KanjiColor> swatches = [
    KanjiColor('White', 0xFFFFFFFF),
    KanjiColor('Cream', kinari),
    KanjiColor('Sand', 0xFFEFE0CC),
    KanjiColor('Stone', 0xFFCFC9C0),
    KanjiColor('Ash', 0xFF9A958D),
    KanjiColor('Slate', 0xFF5E6873),
    KanjiColor('Charcoal', 0xFF33363A),
    KanjiColor('Black', sumi),
    KanjiColor('Blush', 0xFFF4C7CE),
    KanjiColor('Rose', 0xFFD98CA0),
    KanjiColor('Coral', 0xFFE8735A),
    KanjiColor('Vermillion', 0xFFE04E27),
    KanjiColor('Red', shu),
    KanjiColor('Crimson', 0xFF8C1F2C),
    KanjiColor('Apricot', 0xFFF3B77A),
    KanjiColor('Amber', 0xFFE8A33D),
    KanjiColor('Gold', 0xFFA8842C),
    KanjiColor('Clay', 0xFF8C5A3C),
    KanjiColor('Espresso', 0xFF4A332A),
    KanjiColor('Sage', 0xFFA8BC96),
    KanjiColor('Matcha', 0xFF7C9A56),
    KanjiColor('Moss', 0xFF5F7A4A),
    KanjiColor('Forest', 0xFF2C4633),
    KanjiColor('Mint', 0xFF9BD5C4),
    KanjiColor('Teal', 0xFF2E8B92),
    KanjiColor('Sky', 0xFFA5CDE4),
    KanjiColor('Azure', 0xFF3E7CB1),
    KanjiColor('Indigo', ai),
    KanjiColor('Navy', 0xFF1B2A4A),
    KanjiColor('Lavender', 0xFFC3B8DE),
    KanjiColor('Wisteria', 0xFF8B81C3),
    KanjiColor('Plum', 0xFF5D3F6A),
  ];

  static const List<KanjiColor> backgrounds = swatches;
  static const List<KanjiColor> texts = swatches;

  static String nameOf(int value) {
    for (final swatch in swatches) {
      if (swatch.value == value) return swatch.name;
    }
    return 'Custom';
  }
}
