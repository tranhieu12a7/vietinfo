import 'package:flutter/material.dart';
import 'package:vietinfo_core/core/log.dart';

class CoreFontSize {
  BuildContext context;
  static double _coreSize=0.0;

  void initFontSize({BuildContext context}) {
    this.context = context;
    _coreSize=getCoreSize(context: context);
  }

  double getCoreSize({BuildContext context}) {
    if (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height)
      return MediaQuery.of(context).size.height;
    return MediaQuery.of(context).size.width;
  }

 static double getFontSize(double fontSize) {
    try{
      return _coreSize * (fontSize / 100);
    }catch(error){
      appLogs(error);
      return null;
    }
  }
}
