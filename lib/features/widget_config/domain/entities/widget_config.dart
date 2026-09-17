import 'package:equatable/equatable.dart';

enum KanjiFont { notoSansJp, kosugi, kosugiMaru, shipporiMincho }

enum WidgetSize { small, medium, large }

enum NumeralStyle { kanji, arabic }

class WidgetConfig extends Equatable {
  final KanjiFont font;
  final WidgetSize size;
  final int textColor;
  final int backgroundColor;
  final bool showBackground;
  final bool showDate;
  final bool showSeconds;
  final bool showWeekday;
  final bool use24HourFormat;
  final NumeralStyle numeralStyle;
  final bool boldText;

  const WidgetConfig({
    required this.font,
    required this.size,
    required this.textColor,
    required this.backgroundColor,
    required this.showBackground,
    required this.showDate,
    required this.showSeconds,
    required this.showWeekday,
    required this.use24HourFormat,
    required this.numeralStyle,
    required this.boldText,
  });

  factory WidgetConfig.initial() => const WidgetConfig(
    font: KanjiFont.notoSansJp,
    size: WidgetSize.medium,
    textColor: 0xFF1A1A1A,
    backgroundColor: 0xFFFDF6EC,
    showBackground: true,
    showDate: true,
    showSeconds: false,
    showWeekday: false,
    use24HourFormat: true,
    numeralStyle: NumeralStyle.kanji,
    boldText: false,
  );

  WidgetConfig copyWith({
    KanjiFont? font,
    WidgetSize? size,
    int? textColor,
    int? backgroundColor,
    bool? showBackground,
    bool? showDate,
    bool? showSeconds,
    bool? showWeekday,
    bool? use24HourFormat,
    NumeralStyle? numeralStyle,
    bool? boldText,
  }) {
    return WidgetConfig(
      font: font ?? this.font,
      size: size ?? this.size,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      showBackground: showBackground ?? this.showBackground,
      showDate: showDate ?? this.showDate,
      showSeconds: showSeconds ?? this.showSeconds,
      showWeekday: showWeekday ?? this.showWeekday,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      numeralStyle: numeralStyle ?? this.numeralStyle,
      boldText: boldText ?? this.boldText,
    );
  }

  String get summary {
    final parts = [
      numeralStyle == NumeralStyle.kanji ? 'Kanji' : 'Numbers',
      use24HourFormat ? '24-hour' : '12-hour',
      if (showSeconds) 'seconds',
      if (!showDate) 'no date',
      if (showWeekday) 'weekday',
    ];
    return parts.join(' · ');
  }

  @override
  List<Object?> get props => [
    font,
    size,
    textColor,
    backgroundColor,
    showBackground,
    showDate,
    showSeconds,
    showWeekday,
    use24HourFormat,
    numeralStyle,
    boldText,
  ];
}
