library module_chat;
import 'package:module_chat/config/config_style.dart';
import 'package:module_chat/config/model_config.dart';

import 'config/config_data.dart';
import 'config/config_setting.dart';
import 'config/model_config_style.dart';

export 'package:module_chat/config/model_config.dart';
export 'package:module_chat/history/history_main.dart';


class ModuleChat{
  void initConfig( ModelConfigStyle modelConfigStyle){
    ConfigSetting().init();
    ConfigStyle.init(modelConfigStyle: modelConfigStyle);
  }
  void initData({ModelConfig modelConfig}){
    ConfigData.init(modelConfig);
  }
}