library nirikshak;

import 'package:flutter/material.dart';

import 'core/nirikshak_core.dart';
import 'core/nirikshak_dio_interceptor.dart';

export 'core/nirikshak_core.dart';
export 'core/nirikshak_core.dart';
export 'core/nirikshak_dio_interceptor.dart';
export 'model/model.dart';
export 'ui/widget/nirikshak_call_error_widget.dart';
export 'ui/widget/nirikshak_call_overview_widget.dart';
export 'ui/widget/nirikshak_call_request_widget.dart';
export 'ui/widget/nirikshak_call_response_widget.dart';

class Nirikshak {
  final NirikshakCore _nirikshakCore;

  const Nirikshak._(this._nirikshakCore);

  factory Nirikshak() {
    final nirikshakCore = NirikshakCore();
    return Nirikshak._(nirikshakCore);
  }

  NirikshakDioInterceptor getDioInterceptor() {
    return NirikshakDioInterceptor(_nirikshakCore);
  }

  NirikshakCore get nirikshakCore => _nirikshakCore;

  void showNirikshak(BuildContext context) {
    _nirikshakCore.navigateToCallListScreen(context);
  }
}
