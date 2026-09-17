import 'package:equatable/equatable.dart';

import '../../domain/entities/widget_config.dart';
import '../../domain/entities/widget_kind.dart';

sealed class WidgetConfigEvent extends Equatable {
  const WidgetConfigEvent();

  @override
  List<Object?> get props => [];
}

class WidgetConfigLoaded extends WidgetConfigEvent {
  const WidgetConfigLoaded();
}

class FontChanged extends WidgetConfigEvent {
  final WidgetKind kind;
  final KanjiFont font;
  const FontChanged(this.kind, this.font);

  @override
  List<Object?> get props => [kind, font];
}

class SizeChanged extends WidgetConfigEvent {
  final WidgetKind kind;
  final WidgetSize size;
  const SizeChanged(this.kind, this.size);

  @override
  List<Object?> get props => [kind, size];
}

class TextColorChanged extends WidgetConfigEvent {
  final WidgetKind kind;
  final int color;
  const TextColorChanged(this.kind, this.color);

  @override
  List<Object?> get props => [kind, color];
}

class BackgroundColorChanged extends WidgetConfigEvent {
  final WidgetKind kind;
  final int color;
  const BackgroundColorChanged(this.kind, this.color);

  @override
  List<Object?> get props => [kind, color];
}

class BackgroundVisibilityToggled extends WidgetConfigEvent {
  final WidgetKind kind;
  final bool showBackground;
  const BackgroundVisibilityToggled(this.kind, this.showBackground);

  @override
  List<Object?> get props => [kind, showBackground];
}
