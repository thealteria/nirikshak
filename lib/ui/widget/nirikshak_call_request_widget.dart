import 'package:flutter/material.dart';

import '../../model/nirikshak_http_call.dart';
import 'nirikshak_base_call_details_widget.dart';

class NirikshakCallRequestWidget extends StatefulWidget {
  final NirikshakHttpCall call;

  const NirikshakCallRequestWidget(this.call, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _NirikshakCallRequestWidget();
  }
}

class _NirikshakCallRequestWidget
    extends NirikshakBaseCallDetailsWidgetState<NirikshakCallRequestWidget> {
  NirikshakHttpCall get _call => widget.call;

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    rows.add(getListRow("Started:", _call.request?.time.toString() ?? ''));
    rows.add(getListRow("Bytes sent:", formatBytes(_call.request?.size ?? 0)));
    rows.add(getListRow(
        "Content type:", getContentType(_call.request?.headers ?? {})));

    var body = _call.request?.body;
    var bodyContent = "Body is empty";
    if (body != null && body.isNotEmpty) {
      bodyContent =
          formatBody(body, getContentType(_call.request?.headers ?? {}));
    }
    rows.add(getListRow("Body:", bodyContent));
    var formDataFields = _call.request?.formDataFields;
    if (formDataFields?.isNotEmpty == true) {
      rows.add(getListRow("Form data fields: ", ""));
      formDataFields?.forEach(
        (field) {
          rows.add(getListRow("   • ${field.name}:", field.value));
        },
      );
    }
    var formDataFiles = _call.request?.formDataFiles;
    if (formDataFiles?.isNotEmpty == true) {
      rows.add(getListRow("Form data files: ", ""));
      formDataFiles?.forEach(
        (field) {
          rows.add(getListRow("   • ${field.fileName}:",
              "${field.contentType} / ${field.length} B"));
        },
      );
    }

    var headers = _call.request?.headers;
    var headersContent = "Headers are empty";
    if (headers != null && headers.isNotEmpty) {
      headersContent = "";
    }
    rows.add(getListRow("Headers: ", headersContent));
    _call.request?.headers.forEach((header, value) {
      rows.add(getListRow("   • $header:", value.toString()));
    });
    var queryParameters = _call.request?.queryParameters;
    var queryParametersContent = "Query parameters are empty";
    if (queryParameters != null && queryParameters.isNotEmpty) {
      queryParametersContent = "";
    }
    rows.add(getListRow("Query Parameters: ", queryParametersContent));
    _call.request?.queryParameters.forEach((query, value) {
      rows.add(getListRow("   • $query:", value.toString()));
    });

    return Container(
      padding: const EdgeInsets.all(6),
      child: ListView(children: rows),
    );
  }
}
