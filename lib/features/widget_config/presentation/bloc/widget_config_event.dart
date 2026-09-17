import 'package:equatable/equatable.dart';
import '../../domain/entities/widget_config.dart';

sealed class WidgetConfigEvent extends Equatable {
  const WidgetConfigEvent();

  @override
  List<Object?> get props => [];
}

class WidgetConfigLoaded extends WidgetConfigEvent {
  const WidgetConfigLoaded();
}

class FontChanged extends WidgetConfigEvent {
  final KanjiFont font;
  const FontChanged(this.font);

  @override
  List<Object?> get props => [font];
}

class SizeChanged extends WidgetConfigEvent {
  final WidgetSize size;
  const SizeChanged(this.size);

  @override
  List<Object?> get props => [size];
}

class TextColorChanged extends WidgetConfigEvent {
  final int color;
  const TextColorChanged(this.color);

  @override
  List<Object?> get props => [color];
}

class BackgroundColorChanged extends WidgetConfigEvent {
  final int color;
  const BackgroundColorChanged(this.color);

  @override
  List<Object?> get props => [color];
}
