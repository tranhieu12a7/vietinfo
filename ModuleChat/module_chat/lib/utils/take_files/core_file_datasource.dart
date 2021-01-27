import 'package:flutter/material.dart';


abstract class CoreFileDataSource{
    Future<void> takePhoto({BuildContext context, Function callBack});
    Future<void> takeVideo({BuildContext context, Function callBack});
    Future<void> takeAlbums({BuildContext context, Function callBack});
    Future<void> takeFiles({BuildContext context, Function callBack});
}