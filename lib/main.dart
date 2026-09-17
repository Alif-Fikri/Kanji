import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'core/theme/app_theme.dart';
import 'features/widget_config/data/kanji_widget_background_callback.dart';
import 'features/widget_config/data/kanji_widget_hive_bootstrap.dart';
import 'features/widget_config/presentation/bloc/widget_config_bloc.dart';
import 'features/widget_config/presentation/bloc/widget_config_event.dart';
import 'features/widget_gallery/presentation/pages/widget_gallery_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  registerWidgetConfigHiveAdapters();
  await HomeWidget.registerInteractivityCallback(kanjiClockBackgroundCallback);
  runApp(const KanjiWidgetApp());
}

class KanjiWidgetApp extends StatelessWidget {
  const KanjiWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WidgetConfigBloc()..add(const WidgetConfigLoaded()),
      child: MaterialApp(
        title: 'Kanji Widget',
        debugShowCheckedModeBanner: false,
        theme: buildKanjiTheme(),
        home: const WidgetGalleryPage(),
      ),
    );
  }
}
