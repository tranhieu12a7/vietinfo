import 'package:flutter/material.dart';
import 'package:module_chat/config/config_data.dart';
import 'package:module_chat/models/class_firebase.dart';
import 'package:module_chat/utils/logs.dart';
import 'package:overlay_support/overlay_support.dart';


abstract class NotifyEvent extends ChangeNotifier {
  Map<dynamic, dynamic> notifyMessages;
  objdata dataMessages;

  List<ModelEvent> listListener = [];

  void inputDataMessages(dynamic data);

  void inputNotifyMessages(dynamic notifyData);

  void callListener({String key});

  void removeAllListener({String key});

  void addItemListener({String key, VoidCallback function});

  void showNotifySnackbar(BuildContext context, [bool isShow = true]);
}

class NotifyEventResponse extends NotifyEvent {
  @override
  void inputDataMessages(dynamic data) {
    this.dataMessages = data as objdata;
    // notifyListeners();
  }

  @override
  void inputNotifyMessages(notifyData) {
    this.notifyMessages = notifyData as Map<dynamic, dynamic>;
  }

  @override
  void showNotifySnackbar(BuildContext context, [bool isShow = true]) {
    if (isShow)
      showSnackbar(
          buildContext: context,
          title: notifyMessages["title"],
          body: notifyMessages["body"],
          data: notifyMessages['data']);
  }

  void showSnackbar(
      {BuildContext buildContext,
      String title = "",
      String body = "",
      dynamic data}) {
    showOverlayNotification((buildContext) {
      return Container(
        margin: EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical:
                MediaQuery.of(buildContext).padding.top + ConfigData.heightNavigationBar),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Card(
          child: ListTile(
            contentPadding: EdgeInsets.all(5.0),
            title: Text(
              title,
              maxLines: 1,
              // style: CoreTextStyle.boldTextFont(fontSize: 16),
            ),
            subtitle: Text(
              body,
            ),
            onTap: () {
              OverlaySupportEntry.of(buildContext).dismiss();
              String key = data['key'];
              int id = data['id'];
              navigatorFromKeyNofitication(key, id: id);
            },
          ),
        ),
      );
    }, duration: Duration(seconds: 3));
  }

  void navigatorFromKeyNofitication(String key, {int id = 0}) {}

  @override
  void callListener({String key}) {
    // appLogs("callListener - listListener: ${listListener.where((element) => element.key == key).length}");
    listListener.lastWhere((element) => element.key == key).function?.call();
    // notifyListeners();
  }

  @override
  void removeAllListener({String key = ""}) {
    for (var item in listListener) {
      if (item.key == key) {
        removeListener(item.function);
        listListener.remove(item);
        break;
      }
      removeListener(item.function);
    }
  }

  @override
  void addItemListener({String key, VoidCallback function}) {
    listListener.add(new ModelEvent(function: function, key: key));
    this.addListener(function);
  }
}

class ModelEvent {
  final VoidCallback function;
  final String key;

  ModelEvent({this.function, this.key});
}
