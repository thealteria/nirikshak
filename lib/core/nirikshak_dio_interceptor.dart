import 'dart:convert';

import 'package:dio/dio.dart';

import '../nirikshak.dart';

class NirikshakDioInterceptor extends Interceptor {
  /// NirikshakCore instance
  final NirikshakCore nirikshakCore;

  /// Creates dio interceptor
  const NirikshakDioInterceptor(this.nirikshakCore);

  /// Handles dio request and creates nirikshak http call based on it
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final call = NirikshakHttpCall(options.hashCode);

    final uri = options.uri;
    call.method = options.method;
    var path = options.uri.path;
    if (path.isEmpty) {
      path = "/";
    }
    call.endpoint = path;
    call.server = uri.host;
    call.client = "Dio";
    call.uri = options.uri.toString();

    if (uri.scheme == "https") {
      call.secure = true;
    }

    final NirikshakHttpRequest request = NirikshakHttpRequest();

    final data = options.data;
    if (data == null) {
      request.size = 0;
      request.body = "";
    } else {
      if (data is FormData) {
        request.body += "Form data";

        if (data.fields.isNotEmpty == true) {
          List<NirikshakFormDataField> fields = [];
          for (final entry in data.fields) {
            fields.add(NirikshakFormDataField(entry.key, entry.value));
          }
          request.formDataFields = fields;
        }
        if (data.files.isNotEmpty == true) {
          List<NirikshakFormDataFile> files = [];
          for (var entry in data.files) {
            files.add(NirikshakFormDataFile(entry.value.filename ?? '',
                entry.value.contentType.toString(), entry.value.length));
          }

          request.formDataFiles = files;
        }
      } else {
        request.size = utf8.encode(data.toString()).length;
        request.body = data;
      }
    }

    request.time = DateTime.now();
    request.headers = options.headers;
    request.contentType = options.contentType.toString();
    request.queryParameters = options.queryParameters;

    call.request = request;
    call.response = NirikshakHttpResponse();

    nirikshakCore.addCall(call);
    return super.onRequest(options, handler);
  }

  /// Handles dio response and adds data to nirikshak http call
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final httpResponse = NirikshakHttpResponse();
    httpResponse.status = response.statusCode ?? -1;
    httpResponse.statusMessage = response.statusMessage ?? 'N/A';

    if (response.data == null) {
      httpResponse.body = "";
      httpResponse.size = 0;
    } else {
      httpResponse.body = response.data;
      httpResponse.size = utf8.encode(response.data.toString()).length;
    }

    httpResponse.time = DateTime.now();
    Map<String, String> headers = {};
    response.headers.forEach((header, values) {
      headers[header] = values.toString();
    });

    httpResponse.headers = headers;

    nirikshakCore.addResponse(httpResponse, response.requestOptions.hashCode);
    return super.onResponse(response, handler);
  }

  /// Handles error and adds data to nirikshak http call
  @override
  void onError(
    DioError error,
    ErrorInterceptorHandler handler,
  ) {
    final httpError = NirikshakHttpError();
    httpError.error = error.toString();
    if (error is Error) {
      var basicError = error;
      httpError.stackTrace = basicError.stackTrace;
    }

    nirikshakCore.addError(httpError, error.requestOptions.hashCode);
    final httpResponse = NirikshakHttpResponse();
    httpResponse.time = DateTime.now();
    if (error.response == null) {
      httpResponse.status = -1;
      httpResponse.statusMessage = error.response?.statusMessage ?? 'N/A';

      nirikshakCore.addResponse(httpResponse, error.requestOptions.hashCode);
    } else {
      httpResponse.status = error.response?.statusCode ?? -1;
      httpResponse.statusMessage = error.response?.statusMessage ?? 'N/A';

      if (error.response?.data == null) {
        httpResponse.body = "";
        httpResponse.size = 0;
      } else {
        httpResponse.body = error.response?.data;
        httpResponse.size =
            utf8.encode(error.response?.data.toString() ?? '').length;
      }
      Map<String, String> headers = {};
      error.response?.headers.forEach((header, values) {
        headers[header] = values.toString();
      });
      httpResponse.headers = headers;
      nirikshakCore.addResponse(
        httpResponse,
        error.response?.requestOptions.hashCode,
      );
    }

    return super.onError(error, handler);
  }
}
