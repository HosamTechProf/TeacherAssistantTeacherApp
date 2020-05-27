import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacherAssistant/providers/serve_url.dart';

class Auth{

  String serverUrl = ServerUrl.url;

  var status;
  var token;
  var error;

  loginData(info) async{
    String myUrl = "$serverUrl/api/auth/login";
    final response = await  http.post(myUrl,
        headers: {
          'Accept':'application/json',
        },
        body: info
    );
    status = response.body.contains('error');

    var data = json.decode(response.body);
    print(data);
    if(status){
      return data["error"];
    }else{
      _save(data["access_token"]);
      return data["access_token"];
    }
  }

  registerData(info) async{
    String myUrl = "$serverUrl/api/auth/register";
    final response = await http.post(myUrl,
        headers: {
          'Accept':'application/json'
        },
        body: info
    );
    var data = json.decode(response.body);
    print(data);
    if(response.statusCode == 200){
      _save(data["access_token"]);
      return true;
    }else{
      error = data['error'];
      return error.values.toList()[0][0];
    }
  }

  Future<List> getUserData() async{
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/api/auth/user";
    http.Response response = await http.get(myUrl,
        headers: {
          'Accept':'application/json',
          'Authorization' : 'Bearer $value'
        });
    return json.decode(response.body);
  }

  updateUserData(info) async{
    String myUrl = "$serverUrl/api/auth/user/update";
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(myUrl,
        headers: {
          'Accept':'application/json',
          'Authorization' : 'Bearer ${prefs.get('token')}'
        },
        body: info
    );
    var data = json.decode(response.body);
    print(data);
    if(response.statusCode == 200){
      return true;
    }else{
      error = data['error'];
      return error.values.toList()[0][0];
    }
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = "token";
    final value = token;
    prefs.setString(key, value);
  }


  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "token";
    final value = prefs.get(key);
    return value;
  }

}