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
  final Brightness brightness;
  final NirikshakCore _nirikshakCore;

  const Nirikshak._(this.brightness, this._nirikshakCore);

  factory Nirikshak({
    Brightness brightness = Brightness.light,
  }) {
    final nirikshakCore = NirikshakCore(brightness: brightness);
    return Nirikshak._(brightness, nirikshakCore);
  }

  NirikshakDioInterceptor getDioInterceptor() {
    return NirikshakDioInterceptor(_nirikshakCore);
  }

  NirikshakCore get nirikshakCore => _nirikshakCore;

  void showNirikshak(BuildContext context) {
    _nirikshakCore.navigateToCallListScreen(context);
  }
}
