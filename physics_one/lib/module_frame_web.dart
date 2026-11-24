// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

class ModuleFrame extends StatefulWidget {
  const ModuleFrame({required this.title, required this.moduleUrl, super.key});

  final String title;
  final String moduleUrl;

  @override
  State<ModuleFrame> createState() => _ModuleFrameState();
}

class _ModuleFrameState extends State<ModuleFrame> {
  late final String viewType;

  @override
  void initState() {
    super.initState();
    viewType =
        'science-module-${widget.title.hashCode}-${DateTime.now().microsecondsSinceEpoch}';
    ui_web.platformViewRegistry.registerViewFactory(viewType, (viewId) {
      return html.IFrameElement()
        ..src = widget.moduleUrl
        ..title = widget.title
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'fullscreen';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(height: 620, child: HtmlElementView(viewType: viewType)),
    );
  }
}
