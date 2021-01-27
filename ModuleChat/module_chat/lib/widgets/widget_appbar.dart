

import 'package:flutter/material.dart';
import 'package:module_chat/config/config_style.dart';

class WidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final BuildContext buildContext;

  WidgetAppBar({Key key,this.buildContext,this.title, this.height = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: (){
                    // ConfigSetting.getNavigator().popNavigation(buildContext);
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: StyleColor.colorPrime,
                  ),
                ),
                SizedBox(
                  width: 23,
                ),
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${title}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: StyleFontSize.fontSizeTitleDefault,fontFamily: StyleFontFamily.SarabunMedium),
                    ),
                    Text("Đang hoạt động" ,style: TextStyle(
                      fontFamily: StyleFontFamily.SarabunRegular
                    ),),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 2,
              color: Color(0xffd6e1f0),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
