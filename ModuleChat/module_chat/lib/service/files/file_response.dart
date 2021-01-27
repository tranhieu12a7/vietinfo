import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/utils/logs.dart';
import 'package:path_provider/path_provider.dart';

import 'file_datasource.dart';

class FileResponse extends FileDataSource {
  ///progress là 1 function
  @override
  Future<String> DownloadFiles(String url,
      {Function showDownloadProgress, String pathFolderFile = ""}) async {
    var param = new Map<String, String>();
    print(url);
    String URL = '';
    var temp = url.split('/');
    String fileName = temp[temp.length - 1];
    if (url.contains("Alfresco")) {
      URL = ConfigData.getUrl() + '/api/DownloadFileAlfresco/';
      //URL = URL_DOWNLOAD_FILEAlfresco; print('URL file_response: $URL');
      param['fileUrl'] = url;
      param['fileName'] = fileName;
    } else {
      URL = url;
    }
    print('url : $url');

    // url = 'Alfresco/HocMon/CPXD/49/2020/7/CPXD_49_20200715114132_bv(1).jpg';
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());

    try {
      Response response;

      if (param.length > 0) {
        response = await dio.post(
          URL,
          // onReceiveProgress: (received, total) async{
          //   String dataProgress=(received / total * 100).toStringAsFixed(0);
          //   print('$dataProgress %' );
          // },
          onReceiveProgress: showDownloadProgress,

          options: Options(
              contentType: Headers.formUrlEncodedContentType,
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0),

          data: param,
        );
      } else {
        response = await dio.get(
          URL.contains(ConfigData.getUrlWeb())
              ? URL
              : ConfigData.getUrlWeb() + URL,
          // onReceiveProgress: (received, total) async{
          //   String dataProgress=(received / total * 100).toStringAsFixed(0);
          //   print('$dataProgress %' );
          //
          // },
          onReceiveProgress: showDownloadProgress,
          //Received data with List<int>
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0),
        );
      }

      ///
      // if(pathFolder.isEmpty == true){
      //   // Directory tempDir = await getTemporaryDirectory();
      //   Directory tempDir = (await getExternalStorageDirectories(type: StorageDirectory.downloads)).first;
      //   // Directory tempDir = await getApplicationDocumentsDirectory();
      //   pathFolder = tempDir.path;
      // }

      Directory tempDir;
      String tempPath;
      if(pathFolderFile.isNotEmpty == true){
        tempPath=pathFolderFile;
      }
      else{
        // Directory tempDir = await getTemporaryDirectory();
        tempDir = (await getExternalStorageDirectories(
            type: StorageDirectory.downloads))
            .first;
        // Directory tempDir = await getApplicationDocumentsDirectory();
        tempPath = tempDir.path;
      }


      File file = new File("${tempPath}/${fileName}");

      appLogs("DownloadFiles-   ${file.path}");

      file.writeAsBytesSync(response.data);
      // var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      // raf.writeFromSync(response.data);
      // await raf.close();

      return file.path;
    } catch (e) {
      appLogs(e);
      return null;
    }
  }

  // void showDownloadProgress(received, total) {
  //   if (total != -1) {
  //     print((received / total * 100).toStringAsFixed(0) + "%");
  //   }
  // }

  @override
  Future<http.ByteStream> UploadFile(String path, String filename) async {
    var postUri = Uri.parse(ConfigData.getUrlUpload());
    var request = new http.MultipartRequest("POST", postUri);
    request.fields['PhanLoai'] = 'CHAT';

    Uri uri = Uri(path: path);
    request.files.add(new http.MultipartFile.fromBytes(
        'file', await File.fromUri(uri).readAsBytes(),
        filename: filename));

    try {
      http.StreamedResponse streamedResponse = await request.send();
      if (streamedResponse.statusCode != 200) {
        return null;
      }
      return streamedResponse.stream;
    } catch (e) {
      appLogs("error - $e");
      return null;
    }
  }
}
