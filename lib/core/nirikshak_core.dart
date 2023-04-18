import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../nirikshak.dart';

class NirikshakCore {
  NirikshakCore();

  final List<NirikshakHttpCall> httpCalls = <NirikshakHttpCall>[];
  final ValueNotifier<bool> isHttpCall = ValueNotifier(false);

  void addCall(NirikshakHttpCall call) {
    if (httpCalls.isEmpty) {
      httpCalls.add(call);
    } else {
      httpCalls.insert(0, call);
    }
  }

  /// Add error to exisng nirikshak http call
  void addError(NirikshakHttpError error, int requestId) {
    final selectedCall = _selectCall(requestId);

    if (selectedCall.id == -1) {
      if (kDebugMode) log("Selected call is null");
      return;
    }

    selectedCall.error = error;
  }

  /// Add response to existing nirikshak http call
  void addResponse(NirikshakHttpResponse? response, int? requestId) {
    assert(response != null, "response can't be null");
    assert(requestId != null, "requestId can't be null");
    if (response == null || requestId == null) {
      return;
    }

    final selectedCall = _selectCall(requestId);

    if (selectedCall.id == -1) {
      if (kDebugMode) log("Selected call is null");
      return;
    }
    selectedCall.loading = false;
    selectedCall.response = response;
    if (selectedCall.request?.time.millisecondsSinceEpoch != null) {
      selectedCall.duration = response.time.millisecondsSinceEpoch -
          selectedCall.request!.time.millisecondsSinceEpoch;
    }
  }

  void addHttpCall(NirikshakHttpCall nirikshakHttpCall) {
    assert(
        nirikshakHttpCall.request != null, "Http call request can't be null");
    assert(
        nirikshakHttpCall.response != null, "Http call response can't be null");
    httpCalls.add(nirikshakHttpCall);
  }

  void removeCalls() {
    httpCalls.clear();
  }

  NirikshakHttpCall _selectCall(int requestId) => httpCalls.firstWhere(
        (call) => call.id == requestId,
        orElse: () => NirikshakHttpCall(-1),
      );

  void navigateToCallListScreen(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => NirikshakCallsListScreen(this),
      ),
    );
  }
}
