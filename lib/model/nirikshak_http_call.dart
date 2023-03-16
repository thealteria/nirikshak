import 'nirikshak_http_error.dart';
import 'nirikshak_http_request.dart';
import 'nirikshak_http_response.dart';

class NirikshakHttpCall {
  final int id;
  String client = "";
  bool loading = true;
  bool secure = false;
  String method = "";
  String endpoint = "";
  String server = "";
  String uri = "";
  int duration = 0;

  NirikshakHttpRequest? request;
  NirikshakHttpResponse? response;
  NirikshakHttpError? error;

  NirikshakHttpCall(this.id) {
    loading = true;
  }

  void setResponse(NirikshakHttpResponse response) {
    this.response = response;
    loading = false;
  }

  String getCurlCommand() {
    if (request == null) {
      return '';
    }

    var compressed = false;
    var curlCmd = "curl";
    curlCmd += " -X $method";
    var headers = request!.headers;
    headers.forEach((key, value) {
      if ("Accept-Encoding" == key && "gzip" == value) {
        compressed = true;
      }
      curlCmd += " -H '$key: $value'";
    });

    String requestBody = request!.body.toString();
    if (requestBody != '') {
      // try to keep to a single line and use a subshell to preserve any line breaks
      curlCmd += " --data \$'${requestBody.replaceAll("\n", "\\n")}'";
    }

    var queryParamMap = request?.queryParameters;
    int paramCount = queryParamMap?.keys.length ?? 0;
    var queryParams = "";
    if (paramCount > 0) {
      queryParams += "?";
      queryParamMap?.forEach((key, dynamic value) {
        queryParams += '$key=$value';
        paramCount -= 1;
        if (paramCount > 0) {
          queryParams += "&";
        }
      });
    }

    // If server already has http(s) don't add it again
    if (server.contains("http://") || server.contains("https://")) {
      // ignore: join_return_with_assignment
      curlCmd +=
          "${compressed ? " --compressed " : " "}${"'$server$endpoint$queryParams'"}";
    } else {
      // ignore: join_return_with_assignment
      curlCmd +=
          "${compressed ? " --compressed " : " "}${"'${secure ? 'https://' : 'http://'}$server$endpoint$queryParams'"}";
    }

    return curlCmd;
  }
}
