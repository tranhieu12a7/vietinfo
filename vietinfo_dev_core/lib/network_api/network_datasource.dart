
abstract class NetworkDataSource {
  Future<NetWorkResult> get(
      String url, {
        Map<String, String> headers,
      });

  Future<NetWorkResult> post(
      Uri url, {
        Map<String, String> headers,
        Map<String, String> body,
      });

  Future<NetWorkResult> put(
      Uri url, {
        Map<String, String> headers,
        body,
      });
}

class NetWorkResult {
  final ENetWorkStatus status;
  final dynamic dataResult;
  final String ErrorMessages;

  NetWorkResult({this.status, this.dataResult, this.ErrorMessages});
}
enum ENetWorkStatus {
  Successful,
  Error,
  UnConnectInternet,
  Timeout,
  Authentication,
}