import 'dart:convert';

import 'package:flutter/material.dart';

extension DateTimeX on DateTime? {
  String toStringDateTime() {
    final dateTime = this;

    if (dateTime == null) {
      return '';
    }

    final amPm = dateTime.hour < 12 ? 'am' : 'pm';
    int hour = dateTime.hour % 12;
    if (hour == 0) hour = 12;

    final day = dateTime.day.addLeftPad();
    final month = dateTime.month.addLeftPad();
    final year = dateTime.year;

    final min = dateTime.minute.addLeftPad();
    final sec = dateTime.second.addLeftPad();

    return '$day/$month/$year ${hour.addLeftPad()}:$min:$sec $amPm';
  }
}

extension PadX on Object {
  String addLeftPad([
    int width = 2,
    String pad = '0',
  ]) =>
      toString().padLeft(width, pad);
}

extension ConversionX on int {
  static const int _kilobyteAsByte = 1000;
  static const int _megabyteAsByte = 1000000;
  static const int _secondAsMillisecond = 1000;
  static const int _minuteAsMillisecond = 60000;

  /// Format bytes text
  String formatBytes() {
    final bytes = this;
    if (bytes < 0) {
      return "-1 B";
    }
    if (bytes <= _kilobyteAsByte) {
      return "$bytes B";
    }
    if (bytes <= _megabyteAsByte) {
      return "${(bytes / _kilobyteAsByte).toStringAsFixed(2)} kB";
    }

    return "${(bytes / _megabyteAsByte).toStringAsFixed(2)} MB";
  }

  /// Format time in milliseconds
  String formatTime() {
    final timeInMillis = this;
    if (timeInMillis < 0) {
      return "-1 ms";
    }
    if (timeInMillis <= _secondAsMillisecond) {
      return "$timeInMillis ms";
    }
    if (timeInMillis <= _minuteAsMillisecond) {
      return "${(timeInMillis / _secondAsMillisecond).toStringAsFixed(2)} s";
    }

    final duration = Duration(milliseconds: timeInMillis);

    return "${duration.inMinutes} min ${(duration.inSeconds.remainder(60))} s "
        "${duration.inMilliseconds.remainder(1000)} ms";
  }
}

extension JsonParseX on dynamic {
  static const String _emptyBody = "Body is empty";
  static const String _unknownContentType = "Unknown";
  static const String _jsonContentTypeSmall = "content-type";
  static const String _jsonContentTypeBig = "Content-Type";
  static const String _stream = "Stream";
  static const String _applicationJson = "application/json";
  static const String _parseFailedText = "Failed to parse ";
  static const JsonEncoder encoder = JsonEncoder.withIndent('  ');

  static String parseJson(dynamic json) {
    try {
      return encoder.convert(json);
    } catch (e) {
      return json;
    }
  }

  dynamic _decodeJson() {
    try {
      return json.decode(this);
    } catch (e) {
      return this;
    }
  }

  static String formatBodyContent(dynamic body, String contentType) {
    if (body == null) {
      return _emptyBody;
    }

    if (body is String && body.isEmpty) {
      return _emptyBody;
    }

    try {
      var bodyContent = _emptyBody;

      if (!contentType.toLowerCase().contains(_applicationJson)) {
        var bodyTemp = body.toString();

        if (bodyTemp.isNotEmpty) {
          bodyContent = bodyTemp;
        }
      } else {
        if (body is String) {
          if (body.isNotEmpty) {
            if (body.contains("\n")) {
              bodyContent = body;
            } else {
              bodyContent = parseJson(body._decodeJson());
            }
          }
        } else if (body is Stream) {
          bodyContent = _stream;
        } else {
          bodyContent = parseJson(body);
        }
      }

      return bodyContent;
    } catch (e) {
      return _parseFailedText + body.toString();
    }
  }

  String getContentType() {
    if (this is! Map<String, dynamic>) return '';

    final headers = this as Map<String, dynamic>;

    if (headers.containsKey(_jsonContentTypeSmall)) {
      return headers[_jsonContentTypeSmall];
    }
    if (headers.containsKey(_jsonContentTypeBig)) {
      return headers[_jsonContentTypeBig];
    }
    return _unknownContentType;
  }
}

extension StatusColorX on int? {
  Color getStatusTextColor() {
    final status = this ?? -1;
    if (status == -1) {
      return Colors.red;
    } else if (status < 200) {
      return Colors.green;
    } else if (status >= 200 && status < 300) {
      return Colors.green;
    } else if (status >= 300 && status < 400) {
      return Colors.orange;
    } else if (status >= 400 && status < 600) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}

extension StringX on String {
  bool isContains(String content) {
    return toLowerCase().contains(content.toLowerCase());
  }
}
