import 'package:equatable/equatable.dart';

enum KanjiFont { notoSansJp, kosugi, kosugiMaru, shipporiMincho }

enum WidgetSize { small, medium, large }

class WidgetConfig extends Equatable {
  final KanjiFont font;
  final WidgetSize size;
  final int textColor;
  final int backgroundColor;
  final bool showBackground;

  const WidgetConfig({
    required this.font,
    required this.size,
    required this.textColor,
    required this.backgroundColor,
    required this.showBackground,
  });

  factory WidgetConfig.initial() => const WidgetConfig(
        font: KanjiFont.notoSansJp,
        size: WidgetSize.medium,
        textColor: 0xFF1A1A1A,
        backgroundColor: 0xFFFDF6EC,
        showBackground: true,
      );

  WidgetConfig copyWith({
    KanjiFont? font,
    WidgetSize? size,
    int? textColor,
    int? backgroundColor,
    bool? showBackground,
  }) {
    return WidgetConfig(
      font: font ?? this.font,
      size: size ?? this.size,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      showBackground: showBackground ?? this.showBackground,
    );
  }

  @override
  List<Object?> get props => [
        font,
        size,
        textColor,
        backgroundColor,
        showBackground,
      ];
}
