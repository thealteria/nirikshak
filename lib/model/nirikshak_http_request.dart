import 'dart:io';

import 'nirikshak_form_data_file.dart';
import 'nirikshak_from_data_field.dart';

class NirikshakHttpRequest {
  int size = 0;
  DateTime time = DateTime.now();
  Map<String, dynamic> headers = {};
  dynamic body = "";
  String contentType = "";
  List<Cookie> cookies = [];
  Map<String, dynamic> queryParameters = {};
  List<NirikshakFormDataFile> formDataFiles = [];
  List<NirikshakFormDataField> formDataFields = [];
}
