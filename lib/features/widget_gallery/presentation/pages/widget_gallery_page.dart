import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';

import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/washi_background.dart';
import '../../../widget_config/domain/entities/widget_kind.dart';
import '../../../widget_config/domain/entities/widget_target.dart';
import '../../../widget_config/presentation/bloc/widget_config_bloc.dart';
import '../../../widget_config/presentation/bloc/widget_config_event.dart';
import '../../../widget_config/presentation/bloc/widget_config_state.dart';
import '../../../widget_config/presentation/pages/widget_customise_page.dart';
import '../widgets/widget_gallery_tile.dart';

class WidgetGalleryPage extends StatefulWidget {
  const WidgetGalleryPage({super.key});

  @override
  State<WidgetGalleryPage> createState() => _WidgetGalleryPageState();
}

class _WidgetGalleryPageState extends State<WidgetGalleryPage> {
  late Timer _ticker;
  DateTime _now = DateTime.now();
  List<HomeWidgetInfo> _installed = const [];

  @override
  void initState() {
    super.initState();
    _loadInstalled();
    _ticker = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  Future<void> _loadInstalled() async {
    final installed = await HomeWidget.getInstalledWidgets();
    if (!mounted) return;
    setState(() {
      _installed = installed.where((w) => w.androidWidgetId != null).toList();
    });

    final bloc = context.read<WidgetConfigBloc>();
    for (final info in _installed) {
      bloc.add(WidgetTargetOpened(_targetOf(info)));
    }
  }

  WidgetTarget _targetOf(HomeWidgetInfo info) {
    final kind = WidgetKind.values.firstWhere(
      (candidate) => candidate.androidProvider == info.androidClassName,
      orElse: () => WidgetKind.clock,
    );
    return WidgetTarget(kind, widgetId: info.androidWidgetId);
  }

  Future<void> _openCustomise(WidgetTarget target) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WidgetCustomisePage(target: target),
      ),
    );
    await _loadInstalled();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return WashiBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlocBuilder<WidgetConfigBloc, WidgetConfigState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: _loadInstalled,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            '字',
                            style: TextStyle(
                              fontFamily: 'ZenOldMincho',
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kanji Widget',
                                style: Theme.of(context).textTheme.headlineMedium
                                    ?.copyWith(fontSize: 27, height: 1.15),
                              ),
                              Text(
                                'Choose a widget for your home screen',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: scheme.onSurface.withAlpha(140),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    if (_installed.isNotEmpty) ...[
                      const SectionHeader(label: 'On your home screen'),
                      for (final info in _installed) ...[
                        Builder(
                          builder: (context) {
                            final target = _targetOf(info);
                            return WidgetGalleryTile(
                              kind: target.kind,
                              config: state.configFor(target),
                              now: _now,
                              onTap: () => _openCustomise(target),
                            );
                          },
                        ),
                        const SizedBox(height: 26),
                      ],
                      const SizedBox(height: 4),
                      const SectionHeader(label: 'Add a widget'),
                    ],
                    for (final kind in WidgetKind.values) ...[
                      WidgetGalleryTile(
                        kind: kind,
                        config: state.configFor(WidgetTarget(kind)),
                        now: _now,
                        onTap: kind.isAvailable
                            ? () => _openCustomise(WidgetTarget(kind))
                            : null,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
