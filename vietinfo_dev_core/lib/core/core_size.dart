import 'package:flutter/cupertino.dart';

abstract class CoreSizeDataSource{
    Size screenSize;
    void init(BuildContext context){
      screenSize=MediaQuery.of(context).size;
    }
    double getFontSize(double fontSize);
}
class CoreSizeResponse extends CoreSizeDataSource{
  @override
  double getFontSize(double fontSize) {
    var aaa=screenSize.width * (fontSize / 350);
      return aaa;
  }

}