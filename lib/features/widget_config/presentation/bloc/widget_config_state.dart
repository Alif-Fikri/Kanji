import 'package:equatable/equatable.dart';
import '../../domain/entities/widget_config.dart';

class WidgetConfigState extends Equatable {
  final WidgetConfig config;

  const WidgetConfigState({required this.config});

  factory WidgetConfigState.initial() =>
      WidgetConfigState(config: WidgetConfig.initial());

  WidgetConfigState copyWith({WidgetConfig? config}) {
    return WidgetConfigState(config: config ?? this.config);
  }

  @override
  List<Object?> get props => [config];
}
