import 'package:hive/hive.dart';

import '../domain/entities/widget_config.dart';

const int kanjiFontTypeId = 1;
const int widgetSizeTypeId = 2;
const int widgetConfigTypeId = 3;

class KanjiFontAdapter extends TypeAdapter<KanjiFont> {
  @override
  final int typeId = kanjiFontTypeId;

  @override
  KanjiFont read(BinaryReader reader) => KanjiFont.values[reader.readByte()];

  @override
  void write(BinaryWriter writer, KanjiFont obj) =>
      writer.writeByte(obj.index);
}

class WidgetSizeAdapter extends TypeAdapter<WidgetSize> {
  @override
  final int typeId = widgetSizeTypeId;

  @override
  WidgetSize read(BinaryReader reader) => WidgetSize.values[reader.readByte()];

  @override
  void write(BinaryWriter writer, WidgetSize obj) =>
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
    return WidgetConfig(
      font: fields[0] as KanjiFont,
      size: fields[1] as WidgetSize,
      textColor: fields[2] as int,
      backgroundColor: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WidgetConfig obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.font)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.textColor)
      ..writeByte(3)
      ..write(obj.backgroundColor);
  }
}
