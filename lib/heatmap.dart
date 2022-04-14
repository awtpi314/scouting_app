import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:bearscouts/data_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class HeatMap extends StatefulWidget {
  final int index;

  const HeatMap(this.index, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  Map? currentData;
  _HeatmapPainter _painter2 = _HeatmapPainter();

  @override
  void initState() {
    super.initState();

    currentData = DataManager.getDatapoint(widget.index);

    if (currentData!["location"].toString().contains("assets/")) {
      _loadUIImageFromAssetBundle(currentData!["location"]).then((image) {
        setState(() {
          _painter2.setImage(image);
          _painter2.addAllPoints(
              DataManager.getMatchDataAtIndex(widget.index).split("|"));
        });
      });
    } else if (currentData!["location"].toString().isEmpty ||
        currentData!["location"].toString().toLowerCase() == "null") {
      _loadUIImageFromAssetBundle("assets/field_image.png").then((image) {
        setState(() {
          _painter2.setImage(image);
          _painter2.addAllPoints(
              DataManager.getMatchDataAtIndex(widget.index).split("|"));
        });
      });
    } else {
      _loadUIImageFromLocalStorage(currentData!["location"]).then((image) {
        setState(() {
          _painter2.setImage(image);
          _painter2.addAllPoints(
              DataManager.getMatchDataAtIndex(widget.index).split("|"));
        });
      });
    }
  }

  String _offsetToString(UI.Offset offset) {
    double x = offset.dx / _painter2.width * 54.0;
    double y = offset.dy / _painter2.height * 26.5;
    return '(${x.toStringAsFixed(1)},${y.toStringAsFixed(1)})';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  currentData!["title"],
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                _painter2.undoLastHeatmapPoint();
              },
              icon: const Icon(Icons.undo),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        GestureDetector(
          onTapDown: (details) {
            DataManager.setMatchDataAtIndex(
              widget.index,
              DataManager.getMatchDataAtIndex(widget.index) +
                  _offsetToString(details.localPosition) +
                  "|",
            );

            setState(() {
              _painter2.addHeatmapPoint(details.localPosition);
            });
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              child: CustomPaint(
                painter: _painter2,
              ),
              width: _painter2.width.toDouble(),
              height: _painter2.height.toDouble() > 0
                  ? _painter2.height.toDouble() - 20
                  : 0,
            ),
          ),
        ),
      ],
    );
  }

  Future<UI.Image> _loadUIImageFromAssetBundle(String assetName) async {
    ByteData data = await rootBundle.load(assetName);
    var immutableImageBuffer =
        await UI.ImmutableBuffer.fromUint8List(data.buffer.asUint8List());
    var imageDescriptor =
        await UI.ImageDescriptor.encoded(immutableImageBuffer);
    UI.Codec codec = await imageDescriptor.instantiateCodec(
        targetWidth: MediaQuery.of(context).size.width.toInt() - 20);
    UI.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  Future<UI.Image> _loadUIImageFromLocalStorage(String filename) async {
    Uint8List data = await File(filename).readAsBytes();
    var immutableImageBuffer = await UI.ImmutableBuffer.fromUint8List(data);
    var imageDescriptor =
        await UI.ImageDescriptor.encoded(immutableImageBuffer);
    UI.Codec codec = await imageDescriptor.instantiateCodec(
        targetWidth: MediaQuery.of(context).size.width.toInt() - 20);
    UI.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}

class _HeatmapPainter extends ChangeNotifier implements CustomPainter {
  UI.Image? _backgroundImage;
  final List<UI.Offset> _heatmapPoints = [];

  void addAllPoints(List<String> points) {
    for (var point in points) {
      if (point.isNotEmpty) {
        point = point.substring(1, point.length - 1);
        addHeatmapPoint(UI.Offset(
          double.parse(point.split(",")[0]) / 54.0 * width,
          double.parse(point.split(",")[1]) / 26.5 * height,
        ));
      }
    }
  }

  void addHeatmapPoint(UI.Offset point) {
    _heatmapPoints.add(point);
    notifyListeners();
  }

  void undoLastHeatmapPoint() {
    _heatmapPoints.removeLast();
    notifyListeners();
  }

  void setImage(UI.Image image) {
    _backgroundImage = image;
  }

  int get width => _backgroundImage?.width ?? 0;
  int get height => _backgroundImage?.height ?? 0;

  @override
  bool? hitTest(UI.Offset position) => true;

  @override
  void paint(UI.Canvas canvas, UI.Size size) {
    if (_backgroundImage == null) {
      return;
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      UI.Paint()..color = const UI.Color(0xFF1C1B1F),
    );
    canvas.drawImage(_backgroundImage!, Offset.zero, UI.Paint());

    for (UI.Offset point in _heatmapPoints) {
      canvas.drawCircle(
        point,
        20,
        UI.Paint()
          ..shader = const RadialGradient(
            colors: [
              UI.Color(0xFFFF0000),
              UI.Color(0x00FF0000),
            ],
          ).createShader(Rect.fromCircle(
            center: point,
            radius: 20,
          )),
      );
    }
  }

  @override
  SemanticsBuilderCallback? get semanticsBuilder {
    return (Size size) {
      return <CustomPainterSemantics>[
        CustomPainterSemantics(
          rect: Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
          properties: const SemanticsProperties(
            label: 'Heatmap',
            textDirection: TextDirection.ltr,
          ),
        )
      ];
    };
  }

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
