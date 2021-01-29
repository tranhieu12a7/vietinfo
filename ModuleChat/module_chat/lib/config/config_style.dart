import 'package:flutter/material.dart';

import 'model_config_style.dart';

class ConfigStyle {
  static ModelConfigStyle configStyle;

  static void init({ModelConfigStyle modelConfigStyle}) {
    configStyle = modelConfigStyle;
  }
}

class StyleColor {
  static Color colorPrime = ConfigStyle.configStyle?.colorPrime ?? Colors.blue;
  static Color theirItemChat =
      ConfigStyle.configStyle?.theirItemChat ?? Color(0xfff3f5f6);
  static Color theirItemChatBodyMessage =
      ConfigStyle.configStyle?.theirItemChatBodyMessage ?? Color(0xff051a39);
  static Color theirItemChatDateTimeBottom =
      ConfigStyle.configStyle?.theirItemChatDateTimeBottom ?? Color(0xffa2abb9);
  static Color myItemChat =
      ConfigStyle.configStyle?.myItemChat ?? Color(0xff2f75b5);
  static Color myItemChatBodyMessage =
      ConfigStyle.configStyle?.myItemChatBodyMessage ?? Color(0xffffffff);
  static Color myItemChatDateTime =
      ConfigStyle.configStyle?.myItemChatDateTime ?? Color(0xffa2abb9);
  static Color inputChatBackgroundColor =
      ConfigStyle.configStyle?.inputChatBackgroundColor ?? Color(0xfff3f5f6);
  static Color itemChatDateTimeColor =
      ConfigStyle.configStyle?.itemChatDateTimeColor ?? Color(0xffa2abb9);
  static Color navigationBarColorStart =
      ConfigStyle.configStyle?.navigationBarColorStart ??
          ColorExtends.fromHex('#4184d3');
  static Color navigationBarColorEnd =
      ConfigStyle.configStyle?.navigationBarColorEnd ??
          ColorExtends.fromHex('#4fc4dd');
}

class ColorExtends extends Color {
  ColorExtends(int value) : super(value);

  static Color fromHex(String hexStr) {
    final buffer = StringBuffer();
    if (hexStr.length == 6 || hexStr.length == 7) buffer.write('ff');
    buffer.write(hexStr.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class StyleFontSize {
  static double fontSizeDefault = 18.0; //14.0
  static double fontSizeTitleDefault = fontSizeDefault + 2.0;
  static double itemMessageTitleFullName = fontSizeDefault - 2.0;
  static double itemMessageBodyMessage = fontSizeDefault;
  static double itemMessageDateTime = fontSizeDefault - 2.0;
  static double itemMessageDateTimeTitle = fontSizeDefault - 2.0;

  ///giá trị cộng thêm vs default (default = 13.0)
  static double getFontSize({double valueSumWithDefault = 0.0}) {
    return fontSizeDefault + valueSumWithDefault;
  }
  static void initFontSize({double sizeDefault}) {
    fontSizeDefault = sizeDefault??fontSizeDefault;
  }
}

class StyleFontFamily {
  static const String SarabunMedium = "Sarabun-Medium";
  static const String SarabunRegular = "Sarabun-Regular";
  static const String SarabunBold = "Sarabun-Bold";
}
