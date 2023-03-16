import 'package:flutter/material.dart';

import '../../model/nirikshak_http_call.dart';
import '../../utils/nirikshak_extension.dart';
import 'nirikshak_base_call_details_widget.dart';

class NirikshakCallOverviewWidget extends StatefulWidget {
  final NirikshakHttpCall call;

  const NirikshakCallOverviewWidget(this.call, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _NirikshakCallOverviewWidget();
  }
}

class _NirikshakCallOverviewWidget
    extends NirikshakBaseCallDetailsWidgetState<NirikshakCallOverviewWidget> {
  NirikshakHttpCall get _call => widget.call;

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    rows.add(getListRow("Method: ", _call.method));
    rows.add(getListRow("Server: ", _call.server));
    rows.add(getListRow("Endpoint: ", _call.endpoint));
    rows.add(
        getListRow("Started:", _call.request?.time.toStringDateTime() ?? ''));
    rows.add(
        getListRow("Finished:", _call.response?.time.toStringDateTime() ?? ''));
    rows.add(getListRow("Duration:", formatDuration(_call.duration)));
    rows.add(getListRow("Bytes sent:", formatBytes(_call.request?.size ?? 0)));
    rows.add(
        getListRow("Bytes received:", formatBytes(_call.response?.size ?? 0)));
    rows.add(getListRow("Client:", _call.client));
    rows.add(getListRow("Secure:", _call.secure.toString()));
    return Container(
      padding: const EdgeInsets.all(6),
      child: ListView(children: rows),
    );
  }
}
