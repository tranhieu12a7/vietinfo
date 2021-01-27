library vietinfo_dev_core;

import 'package:flutter/cupertino.dart';
import 'package:vietinfo_dev_core/core/core_size.dart';
import 'package:vietinfo_dev_core/core/shared_prefs.dart';


export 'package:vietinfo_dev_core/network_api/network_datasource.dart';
export 'package:vietinfo_dev_core/network_api/network_response.dart';
export 'package:vietinfo_dev_core/widgets/widget_screen.dart';

export 'package:shared_preferences/shared_preferences.dart';
export 'package:vietinfo_dev_core/core/shared_prefs.dart';

CoreSizeDataSource core;

class VietInfoDev{
  static init( ){
    core=new CoreSizeResponse();
    SharedPrefs.initializer();
  }
}