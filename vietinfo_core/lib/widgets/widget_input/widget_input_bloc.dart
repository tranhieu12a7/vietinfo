import 'dart:async';

enum EWidgetInput {
  ///check email
  Email,

  ///check số điện thoại
  Phone,

  ///check giá trị rỗng
  Text,
}

class WidgetInputBloc {
  StreamController streamController = StreamController();

  Stream get streamControllerResult => streamController.stream;

  void dispose() {
    streamController.close();
  }

  void emailValid({String text, Function callBack}) {
    var email = text;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid && text.length > 0) {
      callBack?.call(text);
      streamController.sink.add(text);
    } else {
      callBack?.call(null);
      streamController.sink.addError("");
    }
  }

  void textValid({String text, Function callBack}) {
    var textResult = text.indexOf(" ") == 0 ? text.substring(1) : text;
    if (textResult.length > 0) {
      callBack?.call(text);
      streamController.sink.add(text);
    } else {
      callBack?.call(null);
      streamController.sink.addError("");
    }
  }

  void phoneValid({String text, Function callBack}) {
    Pattern pattern = r'([a-zA-Z!@#\$%\^\&*~\(\)]|[\s]|[^(\+84|[0-9];?])';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(text) && text.length > 0) {
      callBack?.call(text);
      streamController.sink.add(text);
    } else {
      callBack?.call(null);
      streamController.sink.addError("");
    }
  }
}
