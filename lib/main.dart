import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/widget_config/presentation/bloc/widget_config_bloc.dart';
import 'features/widget_config/presentation/pages/widget_preview_page.dart';

void main() {
  runApp(const KanjiWidgetApp());
}

class KanjiWidgetApp extends StatelessWidget {
  const KanjiWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WidgetConfigBloc(),
      child: MaterialApp(
        title: 'Kanji Widget',
        theme: ThemeData(colorSchemeSeed: const Color(0xFFB33A3A)),
        home: const WidgetPreviewPage(),
      ),
    );
  }
}
