import 'package:flutter/material.dart';

import '../../nirikshak.dart';

class NirikshakCallErrorWidget extends StatefulWidget {
  final NirikshakHttpCall call;

  const NirikshakCallErrorWidget(this.call, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _NirikshakCallErrorWidgetState();
  }
}

class _NirikshakCallErrorWidgetState
    extends NirikshakBaseCallDetailsWidgetState<NirikshakCallErrorWidget> {
  NirikshakHttpCall get _call => widget.call;

  @override
  Widget build(BuildContext context) {
    if (_call.error != null) {
      List<Widget> rows = [];
      var error = _call.error?.error;
      var errorText = "Error is empty";
      if (error != null) {
        errorText = error.toString();
      }
      rows.add(getListRow("Error:", errorText));

      return Container(
        padding: const EdgeInsets.all(6),
        child: ListView(children: rows),
      );
    } else {
      return const Center(child: Text("Nothing to display here"));
    }
  }
}
