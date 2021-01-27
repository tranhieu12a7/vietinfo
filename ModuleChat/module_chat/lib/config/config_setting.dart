import 'package:get_it/get_it.dart';
import 'package:module_chat/service/apis/api_datasource.dart';
import 'package:module_chat/service/apis/api_response.dart';
import 'package:module_chat/service/files/file_datasource.dart';
import 'package:module_chat/service/files/file_response.dart';
import 'package:module_chat/utils/pagt_file_locals/path_file_local_datasource.dart';
import 'package:module_chat/utils/pagt_file_locals/path_file_local_response.dart';
import 'package:module_chat/utils/take_files/core_file_datasource.dart';
import 'package:module_chat/utils/take_files/core_file_response.dart';
import 'package:vietinfo_dev_core/vietinfo_dev_core.dart';

final getIt = GetIt.instance;

class ConfigSetting {
  ConfigSetting() {}

  /// khi add vào source khác cấu hình ở đây
  // static NavigatorDataSource getNavigator() => getIt<NavigatorDataSource>();

  /// đăng ký abstract và class tại đây để có thể call.
  Future init() async {
    // getIt.registerSingleton<NavigatorDataSource>(NavigatorResponse(),
    //     signalsReady: true);
    // getIt.registerSingleton<NotifyEvent>(NotifyEventResponse(),
    //     signalsReady: true);
    getIt.registerSingleton<ApiDataSource>(ApiResponse(), signalsReady: true);
    getIt.registerSingleton<NetworkDataSource>(NetworkResponse(),
        signalsReady: true);
    getIt.registerSingleton<FileDataSource>(FileResponse(), signalsReady: true);
    getIt.registerSingleton<PathFileLocalDataSource>(PathFileLocalResponse(), signalsReady: true);
    // getIt.registerSingleton<LoginDataSource>(LoginResponse(), signalsReady: true);
    getIt.registerSingleton<CoreFileDataSource>(CoreFileResponse(), signalsReady: true);
  }
}
