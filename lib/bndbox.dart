import 'package:flutter/material.dart';

class BndBox extends StatefulWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  const BndBox(
      this.results, this.previewH, this.previewW, this.screenH, this.screenW,
      {Key? key})
      : super(key: key);

  @override
  State<BndBox> createState() => _BndBoxState();
}

class _BndBoxState extends State<BndBox> {
  int check(List<String> gaugeResults) {
    int len = gaugeResults.length;
    if (len > 2) {
      for (int i = 2; i <= len + 1; i++) {
        if ((gaugeResults[i - 2] == "Left Eyes") &&
            (gaugeResults[i - 1] == "Closed Eyes") &&
            (gaugeResults[i] == "Right Eyes")) {
          return 1;
        }
      }
    }
    return 0;
  }

  // List<String> gaugedResults = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderStrings() {
      double offset = 60;
      bool emergency = false;
      return widget.results.map((re) {
        String label = re["label"];
        double confidenceLevel = re["confidence"];
        offset = offset + 14;
        return Positioned(
          left: 20,
          top: offset,
          width: widget.screenW,
          height: widget.screenH,
          child: Text(
            "$label with ${(confidenceLevel * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              color: Color(0Xff674d3c),
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList();
    }

    return Stack(children: _renderStrings());
  }
}
