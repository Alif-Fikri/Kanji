import 'package:hive/hive.dart';

import '../domain/entities/widget_config.dart';

const int kanjiFontTypeId = 1;
const int widgetSizeTypeId = 2;
const int widgetConfigTypeId = 3;
const int numeralStyleTypeId = 4;

class KanjiFontAdapter extends TypeAdapter<KanjiFont> {
  @override
  final int typeId = kanjiFontTypeId;

  @override
  KanjiFont read(BinaryReader reader) => KanjiFont.values[reader.readByte()];

  @override
  void write(BinaryWriter writer, KanjiFont obj) => writer.writeByte(obj.index);
}

class WidgetSizeAdapter extends TypeAdapter<WidgetSize> {
  @override
  final int typeId = widgetSizeTypeId;

  @override
  WidgetSize read(BinaryReader reader) => WidgetSize.values[reader.readByte()];

  @override
  void write(BinaryWriter writer, WidgetSize obj) => writer.writeByte(obj.index);
}

class NumeralStyleAdapter extends TypeAdapter<NumeralStyle> {
  @override
  final int typeId = numeralStyleTypeId;

  @override
  NumeralStyle read(BinaryReader reader) =>
      NumeralStyle.values[reader.readByte()];

  @override
  void write(BinaryWriter writer, NumeralStyle obj) =>
      writer.writeByte(obj.index);
}

class WidgetConfigAdapter extends TypeAdapter<WidgetConfig> {
  @override
  final int typeId = widgetConfigTypeId;

  @override
  WidgetConfig read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };
    final fallback = WidgetConfig.initial();
    return WidgetConfig(
      font: fields[0] as KanjiFont? ?? fallback.font,
      size: fields[1] as WidgetSize? ?? fallback.size,
      textColor: fields[2] as int? ?? fallback.textColor,
      backgroundColor: fields[3] as int? ?? fallback.backgroundColor,
      showBackground: fields[4] as bool? ?? fallback.showBackground,
      showDate: fields[5] as bool? ?? fallback.showDate,
      showSeconds: fields[6] as bool? ?? fallback.showSeconds,
      showWeekday: fields[7] as bool? ?? fallback.showWeekday,
      use24HourFormat: fields[8] as bool? ?? fallback.use24HourFormat,
      numeralStyle: fields[9] as NumeralStyle? ?? fallback.numeralStyle,
      boldText: fields[10] as bool? ?? fallback.boldText,
      showTranslation: fields[11] as bool? ?? fallback.showTranslation,
      contentOverrideDate: fields[12] as String?,
      contentOverrideIndex: fields[13] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, WidgetConfig obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.font)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.textColor)
      ..writeByte(3)
      ..write(obj.backgroundColor)
      ..writeByte(4)
      ..write(obj.showBackground)
      ..writeByte(5)
      ..write(obj.showDate)
      ..writeByte(6)
      ..write(obj.showSeconds)
      ..writeByte(7)
      ..write(obj.showWeekday)
      ..writeByte(8)
      ..write(obj.use24HourFormat)
      ..writeByte(9)
      ..write(obj.numeralStyle)
      ..writeByte(10)
      ..write(obj.boldText)
      ..writeByte(11)
      ..write(obj.showTranslation)
      ..writeByte(12)
      ..write(obj.contentOverrideDate)
      ..writeByte(13)
      ..write(obj.contentOverrideIndex);
  }
}
