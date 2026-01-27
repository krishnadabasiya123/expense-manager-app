import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenImageView extends StatefulWidget {
  final File imageFile;

  const FullScreenImageView({super.key, required this.imageFile});

  @override
  State<FullScreenImageView> createState() => _FullScreenImageViewState();

  static Route<dynamic>? route(RouteSettings routeSettings) {
    return MaterialPageRoute(builder: (_) => FullScreenImageView(imageFile: routeSettings.arguments as File));
  }
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(child: InteractiveViewer(child: Image.file(widget.imageFile))),
    );
  }
}
