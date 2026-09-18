import 'package:equatable/equatable.dart';

import 'widget_config.dart';

class WidgetTemplate extends Equatable {
  final String name;
  final KanjiFont font;
  final int textColor;
  final int backgroundColor;
  final bool showBackground;
  final bool boldText;

  const WidgetTemplate({
    required this.name,
    required this.font,
    required this.textColor,
    required this.backgroundColor,
    required this.showBackground,
    required this.boldText,
  });

  WidgetConfig applyTo(WidgetConfig config) {
    return config.copyWith(
      font: font,
      textColor: textColor,
      backgroundColor: backgroundColor,
      showBackground: showBackground,
      boldText: boldText,
    );
  }

  bool matches(WidgetConfig config) {
    return config.font == font &&
        config.textColor == textColor &&
        config.backgroundColor == backgroundColor &&
        config.showBackground == showBackground &&
        config.boldText == boldText;
  }

  @override
  List<Object?> get props => [
    name,
    font,
    textColor,
    backgroundColor,
    showBackground,
    boldText,
  ];
}

class WidgetTemplates {
  static const List<WidgetTemplate> all = [
    WidgetTemplate(
      name: 'Washi',
      font: KanjiFont.notoSansJp,
      textColor: 0xFF1A1A1A,
      backgroundColor: 0xFFFDF6EC,
      showBackground: true,
      boldText: false,
    ),
    WidgetTemplate(
      name: 'Sumi Night',
      font: KanjiFont.shipporiMincho,
      textColor: 0xFFA8842C,
      backgroundColor: 0xFF1A1A1A,
      showBackground: true,
      boldText: false,
    ),
    WidgetTemplate(
      name: 'Sakura',
      font: KanjiFont.kosugiMaru,
      textColor: 0xFF1A1A1A,
      backgroundColor: 0xFFD98CA0,
      showBackground: true,
      boldText: false,
    ),
    WidgetTemplate(
      name: 'Ai',
      font: KanjiFont.notoSansJp,
      textColor: 0xFFFDF6EC,
      backgroundColor: 0xFF1F3A5F,
      showBackground: true,
      boldText: true,
    ),
    WidgetTemplate(
      name: 'Shu',
      font: KanjiFont.shipporiMincho,
      textColor: 0xFFFDF6EC,
      backgroundColor: 0xFFB33A3A,
      showBackground: true,
      boldText: false,
    ),
    WidgetTemplate(
      name: 'Mist',
      font: KanjiFont.kosugi,
      textColor: 0xFF5E6873,
      backgroundColor: 0xFFFFFFFF,
      showBackground: true,
      boldText: false,
    ),
  ];
}
