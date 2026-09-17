import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/widget_config.dart';
import '../../domain/utils/kanji_clock.dart';
import '../bloc/widget_config_bloc.dart';
import '../bloc/widget_config_event.dart';
import '../bloc/widget_config_state.dart';

const Map<KanjiFont, String> kanjiFontFamilies = {
  KanjiFont.notoSansJp: 'NotoSansJP',
  KanjiFont.kosugi: 'Kosugi',
  KanjiFont.kosugiMaru: 'KosugiMaru',
  KanjiFont.shipporiMincho: 'ShipporiMincho',
};

class WidgetPreviewPage extends StatefulWidget {
  const WidgetPreviewPage({super.key});

  @override
  State<WidgetPreviewPage> createState() => _WidgetPreviewPageState();
}

class _WidgetPreviewPageState extends State<WidgetPreviewPage> {
  late Timer _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kanji Widget')),
      body: BlocBuilder<WidgetConfigBloc, WidgetConfigState>(
        builder: (context, state) {
          final config = state.config;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: _WidgetPreview(config: config, now: _now),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Text('Font', style: Theme.of(context).textTheme.titleMedium),
                    Wrap(
                      spacing: 8,
                      children: KanjiFont.values.map((f) {
                        return ChoiceChip(
                          label: Text(f.name),
                          selected: config.font == f,
                          onSelected: (_) =>
                              context.read<WidgetConfigBloc>().add(FontChanged(f)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text('Size', style: Theme.of(context).textTheme.titleMedium),
                    Wrap(
                      spacing: 8,
                      children: WidgetSize.values.map((s) {
                        return ChoiceChip(
                          label: Text(s.name),
                          selected: config.size == s,
                          onSelected: (_) =>
                              context.read<WidgetConfigBloc>().add(SizeChanged(s)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WidgetPreview extends StatelessWidget {
  final WidgetConfig config;
  final DateTime now;

  const _WidgetPreview({required this.config, required this.now});

  double _sizeToHeight(WidgetSize size) {
    switch (size) {
      case WidgetSize.small:
        return 90;
      case WidgetSize.medium:
        return 130;
      case WidgetSize.large:
        return 180;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _sizeToHeight(config.size),
      decoration: BoxDecoration(
        color: Color(config.backgroundColor),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatKanjiTime(now),
            style: TextStyle(
              fontFamily: kanjiFontFamilies[config.font],
              fontSize: 28,
              color: Color(config.textColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatKanjiDate(now),
            style: TextStyle(
              fontFamily: kanjiFontFamilies[config.font],
              fontSize: 16,
              color: Color(config.textColor),
            ),
          ),
        ],
      ),
    );
  }
}
