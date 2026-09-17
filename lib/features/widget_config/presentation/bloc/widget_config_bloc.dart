import 'package:flutter_bloc/flutter_bloc.dart';
import 'widget_config_event.dart';
import 'widget_config_state.dart';

class WidgetConfigBloc extends Bloc<WidgetConfigEvent, WidgetConfigState> {
  WidgetConfigBloc() : super(WidgetConfigState.initial()) {
    on<WidgetConfigLoaded>((event, emit) => emit(WidgetConfigState.initial()));
    on<FontChanged>((event, emit) =>
        emit(state.copyWith(config: state.config.copyWith(font: event.font))));
    on<SizeChanged>((event, emit) =>
        emit(state.copyWith(config: state.config.copyWith(size: event.size))));
    on<TextColorChanged>((event, emit) => emit(
        state.copyWith(config: state.config.copyWith(textColor: event.color))));
    on<BackgroundColorChanged>((event, emit) => emit(state.copyWith(
        config: state.config.copyWith(backgroundColor: event.color))));
  }
}
