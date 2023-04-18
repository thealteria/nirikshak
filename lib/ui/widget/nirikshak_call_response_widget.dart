import 'package:flutter/material.dart';

import '../../nirikshak.dart';

class NirikshakCallResponseWidget extends StatefulWidget {
  final NirikshakHttpCall call;

  const NirikshakCallResponseWidget(this.call, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _NirikshakCallResponseWidgetState();
  }
}

class _NirikshakCallResponseWidgetState
    extends NirikshakBaseCallDetailsWidgetState<NirikshakCallResponseWidget> {
  static const _imageContentType = "image";
  static const _jsonContentType = "json";
  static const _xmlContentType = "xml";
  static const _textContentType = "text";

  static const _kLargeOutputSize = 100000;
  bool _showLargeBody = false;
  bool _showUnsupportedBody = false;

  NirikshakHttpCall get _call => widget.call;

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    if (!_call.loading) {
      rows.addAll(_buildGeneralDataRows());
      rows.addAll(_buildHeadersRows());
      rows.addAll(_buildBodyRows());

      return ListView(
        padding: const EdgeInsets.all(6),
        children: rows,
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            Text("Awaiting response...")
          ],
        ),
      );
    }
  }

  List<Widget> _buildGeneralDataRows() {
    final response = _call.response;
    if (response == null) {
      return [];
    }

    List<Widget> rows = [];
    rows.add(getListRow("Received:", response.time.toString()));
    rows.add(getListRow("Bytes received:", formatBytes(response.size)));

    var status = response.status;
    var statusText = "$status";
    if (status == -1) {
      statusText = "Error";
    }

    rows.add(getListRow("Status:", statusText));
    return rows;
  }

  List<Widget> _buildHeadersRows() {
    final response = _call.response;
    if (response == null) {
      return [];
    }

    List<Widget> rows = [];
    var headers = response.headers;
    var headersContent = "Headers are empty";
    if (headers.isNotEmpty) {
      headersContent = "";
    }
    rows.add(getListRow("Headers: ", headersContent));
    response.headers.forEach((header, value) {
      rows.add(getListRow("   • $header:", value.toString()));
    });
    return rows;
  }

  List<Widget> _buildBodyRows() {
    List<Widget> rows = [];
    if (_isImageResponse()) {
      rows.addAll(_buildImageBodyRows());
    } else if (_isTextResponse()) {
      if (_isLargeResponseBody()) {
        rows.addAll(_buildLargeBodyTextRows());
      } else {
        rows.addAll(_buildTextBodyRows());
      }
    } else {
      rows.addAll(_buildUnknownBodyRows());
    }

    return rows;
  }

  List<Widget> _buildImageBodyRows() {
    List<Widget> rows = [];
    rows.add(
      Column(
        children: [
          Row(
            children: const [
              Text(
                "Body: Image",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 8),
          Image.network(
            _call.uri,
            fit: BoxFit.fill,
            headers: _buildRequestHeaders(),
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
    return rows;
  }

  List<Widget> _buildLargeBodyTextRows() {
    final response = _call.response;
    if (response == null) {
      return [];
    }

    List<Widget> rows = [];
    if (_showLargeBody) {
      return _buildTextBodyRows();
    } else {
      rows.add(getListRow("Body:",
          "Too large to show (${response.body.toString().length} Bytes)"));
      rows.add(const SizedBox(height: 8));
      rows.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          child: const Text("Show body"),
          onPressed: () {
            setState(() {
              _showLargeBody = true;
            });
          },
        ),
      );
      rows.add(const SizedBox(height: 8));
      rows.add(const Text("Warning! It will take some time to render output."));
    }
    return rows;
  }

  List<Widget> _buildTextBodyRows() {
    final response = _call.response;
    if (response == null) {
      return [];
    }

    List<Widget> rows = [];
    var headers = response.headers;
    var bodyContent = formatBody(response.body, getContentType(headers));
    rows.add(getListRow("Body:", bodyContent));
    return rows;
  }

  List<Widget> _buildUnknownBodyRows() {
    final response = _call.response;
    if (response == null) {
      return [];
    }

    List<Widget> rows = [];
    var headers = response.headers;
    var contentType = getContentType(headers);

    if (_showUnsupportedBody) {
      var bodyContent = formatBody(response.body, getContentType(headers));
      rows.add(getListRow("Body:", bodyContent));
    } else {
      rows.add(getListRow(
          "Body:",
          "Unsupported body. Nirikshak can render video/image/text body. "
              "Response has Content-Type: $contentType which can't be handled. "
              "If you're feeling lucky you can try button below to try render body"
              " as text, but it may fail."));
      rows.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          onPressed: () {
            setState(() {
              _showUnsupportedBody = true;
            });
          },
          child: const Text("Show unsupported body"),
        ),
      );
    }
    return rows;
  }

  Map<String, String> _buildRequestHeaders() {
    Map<String, String> requestHeaders = {};

    final request = _call.request;
    if (request == null) {
      return requestHeaders;
    }

    requestHeaders.addAll(
      request.headers.map(
        (String key, dynamic value) {
          return MapEntry(key, value.toString());
        },
      ),
    );
    return requestHeaders;
  }

  bool _isImageResponse() {
    return _getContentTypeOfResponse()
        .toLowerCase()
        .contains(_imageContentType);
  }

  bool _isTextResponse() {
    String responseContentTypeLowerCase =
        _getContentTypeOfResponse().toLowerCase();

    return responseContentTypeLowerCase.contains(_jsonContentType) ||
        responseContentTypeLowerCase.contains(_xmlContentType) ||
        responseContentTypeLowerCase.contains(_textContentType);
  }

  String _getContentTypeOfResponse() {
    return getContentType(_call.response?.headers ?? {});
  }

  bool _isLargeResponseBody() {
    return _call.response?.body != null &&
        (_call.response?.body?.toString() ?? '').length > _kLargeOutputSize;
  }
}
