import 'package:flutter/material.dart';

import '../../utils/nirikshak_extension.dart';

abstract class NirikshakBaseCallDetailsWidgetState<T extends StatefulWidget>
    extends State<T> {
  Widget getListRow(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            value,
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: name == 'Status:'
                  ? (int.tryParse(value) ?? -1).getStatusTextColor()
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  String formatBytes(int bytes) => bytes.formatBytes();

  String formatDuration(int duration) => duration.formatTime();

  String formatBody(dynamic body, String contentType) =>
      JsonParseX.formatBodyContent(body, contentType);

  String getContentType(Map<String, dynamic> headers) =>
      headers.getContentType();
}
