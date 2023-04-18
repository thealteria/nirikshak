library nirikshak;

import 'package:flutter/material.dart';

import 'core/core.dart';

export 'core/nirikshak_core.dart';
export 'core/nirikshak_dio_interceptor.dart';
export 'helper/nirikshak_alert_helper.dart';
export 'model/model.dart';
export 'ui/ui.dart';
export 'utils/utils.dart';

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
