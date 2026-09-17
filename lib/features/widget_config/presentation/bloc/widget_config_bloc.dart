import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/kanji_widget_updater.dart';
import '../../data/widget_config_local_data_source.dart';
import 'widget_config_event.dart';
import 'widget_config_state.dart';

class WidgetConfigBloc extends Bloc<WidgetConfigEvent, WidgetConfigState> {
  final WidgetConfigLocalDataSource _localDataSource;

  WidgetConfigBloc({WidgetConfigLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? WidgetConfigLocalDataSource(),
      super(WidgetConfigState.initial()) {
    on<WidgetConfigLoaded>((event, emit) async {
      emit(WidgetConfigState(configs: await _localDataSource.loadTemplates()));
    });

    on<WidgetTargetOpened>((event, emit) async {
      final config = await _localDataSource.load(event.target);
      emit(state.withConfig(event.target, config));
    });

    on<WidgetConfigChanged>((event, emit) async {
      emit(state.withConfig(event.target, event.config));
      await _localDataSource.save(event.target, event.config);
      await updateHomeWidget(event.target, event.config);
    });
  }
}
