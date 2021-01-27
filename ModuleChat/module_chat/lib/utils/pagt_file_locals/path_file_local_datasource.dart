import 'dart:io';


abstract class PathFileLocalDataSource{
  void insertCache();
  Future<Directory> getPathLocal(EPathType ePathType);
  Future<String> getPathLocalChat({EPathType ePathType,String configPathStr,Function functionGetPathStorage});
  Future<bool> checkExistFile({String path});
}

enum EPathType{
  cache,
  Storage
}