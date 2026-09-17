import 'package:equatable/equatable.dart';

import '../../domain/entities/widget_config.dart';
import '../../domain/entities/widget_kind.dart';

class WidgetConfigState extends Equatable {
  final Map<WidgetKind, WidgetConfig> configs;

  const WidgetConfigState({required this.configs});

  factory WidgetConfigState.initial() => WidgetConfigState(
        configs: {
          for (final kind in WidgetKind.values) kind: WidgetConfig.initial(),
        },
      );

  WidgetConfig configFor(WidgetKind kind) =>
      configs[kind] ?? WidgetConfig.initial();

  WidgetConfigState withConfig(WidgetKind kind, WidgetConfig config) {
    return WidgetConfigState(configs: {...configs, kind: config});
  }

  @override
  List<Object?> get props => [configs];
}
