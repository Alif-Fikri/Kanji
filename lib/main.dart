import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/widget_config/data/widget_config_hive_adapters.dart';
import 'features/widget_config/presentation/bloc/widget_config_bloc.dart';
import 'features/widget_config/presentation/bloc/widget_config_event.dart';
import 'features/widget_config/presentation/pages/widget_preview_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(KanjiFontAdapter());
  Hive.registerAdapter(WidgetSizeAdapter());
  Hive.registerAdapter(WidgetConfigAdapter());
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
        theme: ThemeData(colorSchemeSeed: const Color(0xFFB33A3A)),
        home: const WidgetPreviewPage(),
      ),
    );
  }
}
