import 'package:flutter/material.dart';

import 'model_config.dart';

class ConfigData {
  //
  static String url = "http://192.168.1.132:4009";
  static String urlWeb = "http://192.168.1.132:4009";
  static String urlUpload = "http://192.168.1.132:4009/api/UploadFiles";

  ///api chat
  static String urlHistoryChat= "/api/chat/get-history";
  static String urlGetListMessageByUserID= "/api/chat/getlist-message-by-userid";
  static String urlInsertMessages= "/api/chat/insert-messages";
  static String urlDownloadFileAlfresco= "/api/DownloadFileAlfresco/";


  static double heightNavigationBar = 60.0;


  // static String _pathLocalDownload = "Chat/downloads";
  // static String _pathLocalImages = "Chat/images";
  // static String _pathLocalVideos = "Chat/videos";
  // static String _pathLocalFiles = "Chat/files";
  // //
  // static String _userName = "hvgiang.hocmon";
  // static String _fullName = "Hà Văn Giang";
  // static String _userID = "14877";
  // static String _donViID = "49";
  // static String _soDienThoai = "0913148485";
  // static String _userPortalID = "741";
  // static String _userMasterID = "10237";
  // static String _phongBanID = "12304";
  // static String _maPhuongXa = "27559";
  // static String _quanHuyenID = "11243";
  // static String _token = "";

  static ModelConfig _modelConfig;

  static init(ModelConfig modelConfig){
    _modelConfig=modelConfig;
  }


  static BuildContext pageCurrentContext;

  ///config path local
  static String getPathLocalDownload() => _modelConfig.pathLocalDownload;

  static String getPathLocalImages() => _modelConfig.pathLocalImages;

  static String getPathLocalVideos() =>  _modelConfig.pathLocalVideos;

  static String getPathLocalFiles() =>  _modelConfig.pathLocalFiles;

  ///api
  // static String getUrl() =>  _modelConfig.url;
  //
  // static String getUrlWeb() =>  _modelConfig.urlWeb;
  //
  // static String getUrlUpload() =>  _modelConfig.urlUpload;

  static String getUrl() =>  url;

  static String getUrlWeb() =>  urlWeb;

  static String getUrlUpload() =>  urlUpload;

  ///config data local
  static String getURLAvatar() => "";

  static String getUserName() =>   _modelConfig.userName; //"hvgiang.hocmon";

  static String getFullName() =>  _modelConfig.fullName;//"Hà Văn Giang";

  static String getUserPortalID() =>  _modelConfig.userPortalID;

  static String getUserMasterID() =>  _modelConfig.userMasterID;

  static String getUserID() =>  _modelConfig.userID;//"14877";

  static String getDonViID() =>  _modelConfig.donViID;//"49";

  static String getSoDienThoai() =>  _modelConfig.soDienThoai;//"0913148485";

  static String getPhongBanID() =>  _modelConfig.phongBanID;

  static String getMaPhuongXa() =>  _modelConfig.maPhuongXa;

  static String getQuanHuyenID() =>  _modelConfig.quanHuyenID;
  static String getToken() =>  _modelConfig.token;

  static void setToken(String value) {
    print('token - ${value}');
    _modelConfig.token=value;
  }


  // static String logoLogin() => "images/login_image.png";
}


