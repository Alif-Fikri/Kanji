import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'core/theme/app_theme.dart';
import 'features/widget_config/data/kanji_widget_background_callback.dart';
import 'features/widget_config/data/kanji_widget_hive_bootstrap.dart';
import 'features/widget_config/data/kanji_widget_updater.dart';
import 'features/widget_config/data/widget_config_local_data_source.dart';
import 'features/widget_config/domain/entities/widget_kind.dart';
import 'features/widget_config/domain/entities/widget_target.dart';
import 'features/widget_config/presentation/bloc/widget_config_bloc.dart';
import 'features/widget_config/presentation/bloc/widget_config_event.dart';
import 'features/widget_config/presentation/pages/widget_customise_page.dart';
import 'features/widget_gallery/presentation/pages/widget_gallery_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  registerWidgetConfigHiveAdapters();
  await HomeWidget.registerInteractivityCallback(kanjiClockBackgroundCallback);

  final configureId = await HomeWidget.initiallyLaunchedFromHomeWidgetConfigure();
  final launchUri = await HomeWidget.initiallyLaunchedFromHomeWidget();

  runApp(
    KanjiWidgetApp(
      configureTarget: _targetFromConfigureId(configureId),
      editTarget: _targetFromLaunchUri(launchUri),
    ),
  );

  unawaited(refreshInstalledWidgets(WidgetConfigLocalDataSource().load));
}

WidgetTarget? _targetFromConfigureId(String? configureId) {
  final widgetId = int.tryParse(configureId ?? '');
  if (widgetId == null) return null;
  return WidgetTarget(WidgetKind.clock, widgetId: widgetId);
}

WidgetTarget? _targetFromLaunchUri(Uri? uri) {
  if (uri?.host != 'edit') return null;
  final widgetId = int.tryParse(uri?.queryParameters['widgetId'] ?? '');
  if (widgetId == null) return null;
  return WidgetTarget(WidgetKind.clock, widgetId: widgetId);
}

class KanjiWidgetApp extends StatelessWidget {
  final WidgetTarget? configureTarget;
  final WidgetTarget? editTarget;

  const KanjiWidgetApp({super.key, this.configureTarget, this.editTarget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WidgetConfigBloc()..add(const WidgetConfigLoaded()),
      child: MaterialApp(
        title: 'Kanji Widget',
        debugShowCheckedModeBanner: false,
        theme: buildKanjiTheme(),
        home: configureTarget != null
            ? WidgetCustomisePage(target: configureTarget!, isConfiguring: true)
            : WidgetGalleryPage(editTarget: editTarget),
      ),
    );
  }
}
