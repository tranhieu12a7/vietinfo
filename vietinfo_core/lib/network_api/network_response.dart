import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:vietinfo_core/network_api/network_datasource.dart';

class NetworkResponse extends NetworkDataSource {
  var isInternetCheck;
  int timeLimit = 10;

  NetworkResponse({timeLimit}) {
    this.timeLimit = timeLimit ?? this.timeLimit;
  }

  Future<NetWorkResult> get(
    String url, {
    Map<String, String> headers,
  }) async {
    try {
      internetConnectionChecking().then((isConnect) async {
        if (!isConnect) {
          print("------Lost Connect--------");
          // return null;
          return NetWorkResult(
              dataResult: null,
              ErrorMessages: "Not Connect Internet",
              status: ENetWorkStatus.UnConnectInternet);
        }
      });
      final response = await http
          .get(url, headers: headers)
          .timeout(Duration(seconds: timeLimit));
      final body = response.body;
      final statusCode = response.statusCode;
      if (body == null) {
        // throw RemoteDataSourceException(statusCode, 'Response body is null');
        return NetWorkResult(
            dataResult: null,
            ErrorMessages: 'Response body is null',
            status: ENetWorkStatus.Error);
      }
      final decoded = json.decode(body);
      if (statusCode < 200 || statusCode >= 300) {
        // throw RemoteDataSourceException(statusCode, decoded['message']);
        return NetWorkResult(
            dataResult: null,
            ErrorMessages: decoded['message'],
            status: ENetWorkStatus.Error);
      }
      return NetWorkResult(
          dataResult: decoded,
          ErrorMessages: null,
          status: ENetWorkStatus.Successful);
    } on http.ClientException catch (e) {
      return NetWorkResult(
          dataResult: null,
          ErrorMessages: e.message,
          status: ENetWorkStatus.Error);
    } on TimeoutException catch (e) {
      return NetWorkResult(
          dataResult: null,
          ErrorMessages: e.message,
          status: ENetWorkStatus.Error);
    } catch (e) {
      return NetWorkResult(
          dataResult: null,
          ErrorMessages: e.message,
          status: ENetWorkStatus.Error);
    }
    // return decoded;
  }

  Future<NetWorkResult> post(
    Uri url, {
    Map<String, String> headers,
    Map<String, String> body,
  }) async {
    try {
      internetConnectionChecking().then((isConnect) {
        if (!isConnect) {
          print("------Lost Connect--------");
          // return null;
          return NetWorkResult(
              dataResult: null,
              ErrorMessages: "Not Connect Internet",
              status: ENetWorkStatus.UnConnectInternet);
        }
      });
      final http.Response response = await http
          .post(url, headers: headers, body: body)
          .timeout(Duration(seconds: timeLimit));

      final bodyResponse = response.body;
      final statusCode = response.statusCode;
      if (body == null) {
        // throw RemoteDataSourceException(statusCode, 'Response body is null');
        return NetWorkResult(
            dataResult: null,
            ErrorMessages: 'Response body is null',
            status: ENetWorkStatus.Error);
      }
      final decoded = json.decode(bodyResponse);
      if (statusCode < 200 || statusCode >= 300) {
        // throw RemoteDataSourceException(statusCode, decoded['message']);
        return NetWorkResult(
            dataResult: null,
            ErrorMessages: decoded['message'],
            status: ENetWorkStatus.Error);
      }
      return NetWorkResult(
          dataResult: decoded,
          ErrorMessages: null,
          status: ENetWorkStatus.Successful);
    } on http.ClientException catch (e) {
      return NetWorkResult(
          dataResult: null,
          ErrorMessages: e.message,
          status: ENetWorkStatus.Error);
    } on TimeoutException catch (e) {
      return NetWorkResult(
          dataResult: null,
          ErrorMessages: e.message,
          status: ENetWorkStatus.Error);
    } catch (e) {
      return NetWorkResult(
          dataResult: null,
          ErrorMessages: e.message,
          status: ENetWorkStatus.Error);
    }
    // return decoded;
  }

  static Future _helper(
    String method,
    Uri url, {
    Map<String, String> headers,
    Map<String, String> body,
  }) async {
    try {
      internetConnectionChecking().then((isConnect) {
        if (!isConnect) {
          print("------Lost Connect--------");
          // return null;
          return NetWorkResult(
              dataResult: null,
              ErrorMessages: "Not Connect Internet",
              status: ENetWorkStatus.UnConnectInternet);
        }
      });
      final request = http.Request(method, url);
      if (body != null) {
        request.bodyFields = body;
      }
      if (headers != null) {
        request.headers.addAll(headers);
      }
      final streamedResponse = await request.send();

      final statusCode = streamedResponse.statusCode;
      final decoded =
          json.decode(await streamedResponse.stream.bytesToString());

      if (statusCode < 200 || statusCode >= 300) {
        // throw RemoteDataSourceException(statusCode, decoded['message']);
        return NetWorkResult(
            dataResult: null,
            ErrorMessages: decoded['message'],
            status: ENetWorkStatus.Error);
      }
      // return decoded;
      return NetWorkResult(
          dataResult: decoded,
          ErrorMessages: null,
          status: ENetWorkStatus.Successful);
    } on http.ClientException catch (e) {
      return NetWorkResult(
          dataResult: null,
          ErrorMessages: e.message,
          status: ENetWorkStatus.Error);
    } on TimeoutException catch (e) {
      return NetWorkResult(
          dataResult: null,
          ErrorMessages: e.message,
          status: ENetWorkStatus.Error);
    } catch (e) {
      return NetWorkResult(
          dataResult: null,
          ErrorMessages: e.message,
          status: ENetWorkStatus.Error);
    }
  }

  Future<NetWorkResult> put(
    Uri url, {
    Map<String, String> headers,
    body,
  }) async {
    internetConnectionChecking().then((isConnect) {
      if (!isConnect) {
        print("------Lost Connect--------");
        // return null;
        return NetWorkResult(
            dataResult: null,
            ErrorMessages: "Not Connect Internet",
            status: ENetWorkStatus.UnConnectInternet);
      }
    });
    _helper(
      'PUT',
      url,
      headers: headers,
      body: body,
    );
  }

  ///@TaiNguyen 2020-11-08: check internet connection
  static Future<bool> internetConnectionChecking() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
