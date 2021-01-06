import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vietinfo_core/core/core_font_size.dart';
import 'widget_input_bloc.dart';

class WidgetInputValid extends StatefulWidget {
  final InputBorder border;
  final InputBorder enabledBorder;
  final TextInputType textInputType;
  final String placeholder;
  final TextStyle textStyle;
  final TextStyle textStylePlaceholder;
  final int maxLength;
  final int maxLines;
  final bool isShowText;
  final bool isShowIconCheck;
  final EWidgetInput eWidgetInput;
  final Function callBackDataResult;
  final String value;

  const WidgetInputValid(
      {Key key,
      this.border,
      this.value,
      this.enabledBorder,
      this.textInputType,
      this.isShowText,
      @required this.isShowIconCheck,
      @required this.placeholder,
      this.textStyle,
      this.textStylePlaceholder,
      this.maxLines,
      this.eWidgetInput,
      @required this.callBackDataResult,
      this.maxLength})
      : super(key: key);

  @override
  _WidgetInputValidState createState() => _WidgetInputValidState();
}

class _WidgetInputValidState extends State<WidgetInputValid> {
  WidgetInputBloc widgetInputBloc;

  TextEditingController textEditingController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widgetInputBloc.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widgetInputBloc = new WidgetInputBloc();
    textEditingController=new TextEditingController();
    textEditingController.text=widget.value??"";
    if(widget.value!=null){
      callCheckValid();
    }

  }


  callCheckValid(){
    switch (widget.eWidgetInput) {
      case EWidgetInput.Email:
        widgetInputBloc.emailValid(
            text: textEditingController.text);
        break;
      case EWidgetInput.Phone:
        widgetInputBloc.phoneValid(
            text: textEditingController.text);
        break;
      default:
        widgetInputBloc.textValid(
            text: textEditingController.text);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widgetInputBloc.streamControllerResult,
        builder: (context, snapshot) {
          return TextField(
            controller: textEditingController,
            onTap:(){
              callCheckValid();
            },
            onChanged: (value) {
              if (widget.maxLength != null &&
                  value.length >= widget.maxLength) {
                FocusScope.of(context).requestFocus(new FocusNode());
              }

              switch (widget.eWidgetInput) {
                case EWidgetInput.Email:
                  widgetInputBloc.emailValid(
                      text: value, callBack: widget.callBackDataResult);
                  break;
                case EWidgetInput.Phone:
                  widgetInputBloc.phoneValid(
                      text: value, callBack: widget.callBackDataResult);
                  break;
                default:
                  widgetInputBloc.textValid(
                      text: value, callBack: widget.callBackDataResult);
                  break;
              }
            },

            maxLines: widget.maxLines ?? 1,
            style: widget.textStyle ?? TextStyle(
              fontSize: CoreFontSize.getFontSize( 10.0)
            ),
                // CoreTextStyle.boldTextFont(
                //     color: Color(0xff021a1b), fontSize: CoreFontSize.titleSize),
            maxLength: widget.maxLength ?? 250,
            obscureText: widget.isShowText ?? false,
            //bỏ tự động sửa text
            autocorrect: false,
            keyboardType: widget.textInputType ?? TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                counter: SizedBox.shrink(),
                // border: InputBorder.none,
                labelStyle: snapshot.hasError
                    ? TextStyle(
                        color: Colors.red, fontSize: CoreFontSize.getFontSize( 10.0))
                    : (widget.textStylePlaceholder ??
                        TextStyle(
                            color: Color(0xff535353),
                            fontSize: CoreFontSize.getFontSize(10))),
                // errorText: snapshot.hasError ? snapshot.error : null,
                border: widget.border,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: snapshot.hasError ? Colors.red : Colors.grey),
                ),
                enabledBorder: snapshot.hasError
                    ? UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      )
                    : widget.enabledBorder,
                labelText: widget.placeholder ?? 'Nhập dữ liệu...',
                suffixIcon: (snapshot.hasData && !snapshot.hasError)
                    ? (widget.isShowIconCheck
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : SizedBox())
                    : SizedBox()),
          );
        });
  }
}
