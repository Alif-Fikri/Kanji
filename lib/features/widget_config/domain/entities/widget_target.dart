import 'package:equatable/equatable.dart';

import 'widget_kind.dart';

class WidgetTarget extends Equatable {
  final WidgetKind kind;
  final int? widgetId;

  const WidgetTarget(this.kind, {this.widgetId});

  bool get isTemplate => widgetId == null;

  String get storageKey =>
      widgetId == null ? '${kind.name}_default' : '${kind.name}_$widgetId';

  String get imageKey => widgetId == null
      ? '${kind.name}_image'
      : '${kind.name}_image_$widgetId';

  @override
  List<Object?> get props => [kind, widgetId];
}
