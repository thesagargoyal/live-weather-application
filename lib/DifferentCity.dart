import 'dart:convert';
import 'package:http/http.dart' as http;

class DifferentCityNetwork{

  DifferentCityNetwork({this.url});

  final String url;

  Future<dynamic> getData() async{
    http.Response response=await http.get(url);
    if(response.statusCode==200){
      String data=response.body;

      var DecodeData=jsonDecode(data);

      return DecodeData;
    }else{
      print(response.statusCode);
      return null;
    }
  }

}