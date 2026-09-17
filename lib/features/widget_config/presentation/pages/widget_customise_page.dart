import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';

import '../../../../core/theme/kanji_palette.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/washi_background.dart';
import '../../domain/entities/widget_kind.dart';
import '../bloc/widget_config_bloc.dart';
import '../bloc/widget_config_event.dart';
import '../bloc/widget_config_state.dart';
import '../widgets/color_swatch_row.dart';
import '../widgets/font_selector.dart';
import '../widgets/preview_stage.dart';

class WidgetCustomisePage extends StatefulWidget {
  final WidgetKind kind;

  const WidgetCustomisePage({super.key, required this.kind});

  @override
  State<WidgetCustomisePage> createState() => _WidgetCustomisePageState();
}

class _WidgetCustomisePageState extends State<WidgetCustomisePage> {
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

  Future<void> _pinWidget() async {
    final provider = widget.kind.androidProvider;
    if (provider == null) return;

    final supported = await HomeWidget.isRequestPinWidgetSupported() ?? false;
    if (!mounted) return;

    if (!supported) {
      _showAddInstructions();
      return;
    }
    await HomeWidget.requestPinWidget(qualifiedAndroidName: provider);
  }

  void _showAddInstructions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(KanjiPalette.kinari),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(label: 'How to add'),
            for (final step in const [
              '1.  Long-press an empty area on your home screen',
              '2.  Tap "Widgets"',
              '3.  Find "kanji_widget", then drag it onto the home screen',
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(step, style: const TextStyle(fontSize: 15)),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final kind = widget.kind;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(kind.title)),
      body: WashiBackground(
        child: BlocBuilder<WidgetConfigBloc, WidgetConfigState>(
          builder: (context, state) {
            final config = state.configFor(kind);
            final bloc = context.read<WidgetConfigBloc>();

            return ListView(
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                20,
                36,
              ),
              children: [
                PreviewStage(kind: kind, config: config, now: _now),
                const SizedBox(height: 26),
                SettingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(label: 'Font'),
                      FontSelector(
                        selected: config.font,
                        onSelected: (font) => bloc.add(FontChanged(kind, font)),
                      ),
                      const SizedBox(height: 26),
                      const SectionHeader(label: 'Size'),
                      SizeSelector(
                        selected: config.size,
                        onSelected: (size) => bloc.add(SizeChanged(kind, size)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SettingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(label: 'Text colour'),
                      ColorSwatchRow(
                        options: KanjiPalette.texts,
                        selected: config.textColor,
                        onSelected: (color) =>
                            bloc.add(TextColorChanged(kind, color)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SettingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(label: 'Background'),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Show background',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Turn off for a transparent widget',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: scheme.onSurface.withAlpha(130),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: config.showBackground,
                            onChanged: (value) => bloc.add(
                              BackgroundVisibilityToggled(kind, value),
                            ),
                          ),
                        ],
                      ),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: config.showBackground
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: ColorSwatchRow(
                            options: KanjiPalette.backgrounds,
                            selected: config.backgroundColor,
                            onSelected: (color) =>
                                bloc.add(BackgroundColorChanged(kind, color)),
                          ),
                        ),
                        secondChild: const SizedBox(width: double.infinity),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                FilledButton(
                  onPressed: _pinWidget,
                  child: const Text('Add to Home Screen'),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: _showAddInstructions,
                    child: Text(
                      'Add it manually instead',
                      style: TextStyle(color: scheme.onSurface.withAlpha(150)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
