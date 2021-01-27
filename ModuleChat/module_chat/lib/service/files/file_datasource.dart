
import 'package:http/http.dart' as http;


abstract class FileDataSource{
  Future<String> DownloadFiles(String url,{Function showDownloadProgress, String pathFolderFile = ""});
  Future<http.ByteStream> UploadFile(String path, String filename);
}