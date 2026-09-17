import 'package:equatable/equatable.dart';

import '../../domain/entities/widget_config.dart';
import '../../domain/entities/widget_target.dart';

sealed class WidgetConfigEvent extends Equatable {
  const WidgetConfigEvent();

  @override
  List<Object?> get props => [];
}

class WidgetConfigLoaded extends WidgetConfigEvent {
  const WidgetConfigLoaded();
}

class WidgetTargetOpened extends WidgetConfigEvent {
  final WidgetTarget target;
  const WidgetTargetOpened(this.target);

  @override
  List<Object?> get props => [target];
}

class WidgetConfigChanged extends WidgetConfigEvent {
  final WidgetTarget target;
  final WidgetConfig config;
  const WidgetConfigChanged(this.target, this.config);

  @override
  List<Object?> get props => [target, config];
}
