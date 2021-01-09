# vietinfo_dev_core

A new Flutter package project.

## Getting Started

*nếu dùng  "get_it: ^4.0.4"

* cách dùng pub
* thì cần init
final getIt = GetIt.instance;
class ServiceLocator{
    Future init()async{
      getIt.registerSingleton<NetworkDataSource>(NetworkResponse());
    }
}
* call pub
class callApiYour{
     NetworkDataSource network;
     callApiYour(){
         this.network = getIt.get<NetworkDataSource>();
        // * nếu không dùng GetIt
        // this.network = NetworkResponse();

     }
     void post(String url,Map<String, String>  param){
          NetWorkResult dataNetWorkResult = await network.post(Uri.parse(url), body: param);
          if (dataNetWorkResult.status == ENetWorkStatus.Error) {
                  return null;
                }
          //  var data = dataNetWorkResult.dataResult as List;
          // print(data);
          //  List<YourModel> listData = [];
          //  for (var item in data) {
          //    listData.add(YourModel.fromJson(item));
          //  }
          //  return listData;
     }
     
}










