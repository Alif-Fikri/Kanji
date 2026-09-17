import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/kanji_widget_updater.dart';
import '../../data/widget_config_local_data_source.dart';
import '../../domain/entities/widget_config.dart';
import '../../domain/entities/widget_kind.dart';
import 'widget_config_event.dart';
import 'widget_config_state.dart';

class WidgetConfigBloc extends Bloc<WidgetConfigEvent, WidgetConfigState> {
  final WidgetConfigLocalDataSource _localDataSource;

  WidgetConfigBloc({WidgetConfigLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? WidgetConfigLocalDataSource(),
        super(WidgetConfigState.initial()) {
    on<WidgetConfigLoaded>(_onLoaded);
    on<FontChanged>((event, emit) => _persist(
        emit, event.kind, state.configFor(event.kind).copyWith(font: event.font)));
    on<SizeChanged>((event, emit) => _persist(
        emit, event.kind, state.configFor(event.kind).copyWith(size: event.size)));
    on<TextColorChanged>((event, emit) => _persist(emit, event.kind,
        state.configFor(event.kind).copyWith(textColor: event.color)));
    on<BackgroundColorChanged>((event, emit) => _persist(emit, event.kind,
        state.configFor(event.kind).copyWith(backgroundColor: event.color)));
    on<BackgroundVisibilityToggled>((event, emit) => _persist(
        emit,
        event.kind,
        state
            .configFor(event.kind)
            .copyWith(showBackground: event.showBackground)));
  }

  Future<void> _onLoaded(
    WidgetConfigLoaded event,
    Emitter<WidgetConfigState> emit,
  ) async {
    emit(WidgetConfigState(configs: await _localDataSource.loadAll()));
  }

  Future<void> _persist(
    Emitter<WidgetConfigState> emit,
    WidgetKind kind,
    WidgetConfig config,
  ) async {
    emit(state.withConfig(kind, config));
    await _localDataSource.save(kind, config);
    await updateHomeWidget(kind, config);
  }
}
