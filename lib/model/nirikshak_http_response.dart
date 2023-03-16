class NirikshakHttpResponse {
  int status = 0;
  String statusMessage = 'N/A';
  int size = 0;
  DateTime time = DateTime.now();
  dynamic body;
  Map<String, String> headers = {};

  String get statusCodeMessage => '$status $statusMessage';
}
