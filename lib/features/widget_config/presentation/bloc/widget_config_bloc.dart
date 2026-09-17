import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/widget_config_local_data_source.dart';
import '../../domain/entities/widget_config.dart';
import 'widget_config_event.dart';
import 'widget_config_state.dart';

class WidgetConfigBloc extends Bloc<WidgetConfigEvent, WidgetConfigState> {
  final WidgetConfigLocalDataSource _localDataSource;

  WidgetConfigBloc({WidgetConfigLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? WidgetConfigLocalDataSource(),
        super(WidgetConfigState.initial()) {
    on<WidgetConfigLoaded>(_onLoaded);
    on<FontChanged>((event, emit) =>
        _persist(emit, state.config.copyWith(font: event.font)));
    on<SizeChanged>((event, emit) =>
        _persist(emit, state.config.copyWith(size: event.size)));
    on<TextColorChanged>((event, emit) =>
        _persist(emit, state.config.copyWith(textColor: event.color)));
    on<BackgroundColorChanged>((event, emit) =>
        _persist(emit, state.config.copyWith(backgroundColor: event.color)));
  }

  Future<void> _onLoaded(
    WidgetConfigLoaded event,
    Emitter<WidgetConfigState> emit,
  ) async {
    final config = await _localDataSource.load();
    emit(state.copyWith(config: config));
  }

  Future<void> _persist(
    Emitter<WidgetConfigState> emit,
    WidgetConfig config,
  ) async {
    emit(state.copyWith(config: config));
    await _localDataSource.save(config);
  }
}
