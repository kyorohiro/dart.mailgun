library me.k07.mailgun;
import 'package:me.k07.prop/prop.dart' as pro;
import 'package:me.k07.httprequest/request.dart' as req;
import 'dart:async';
import 'dart:convert' as conv;


part './src/send.dart';

class ErrorProp {
  pro.MiniProp prop;
  ErrorProp(this.prop) {}
  //"errorCode"
  //"errorMessage"
  int get errorCode => prop.getNum("errorCode", 0);
  String get errorMessage => prop.getString("errorMessage", "");
}

class Config {
 String publicAPIKey = "";
 String secretAPIKey = "";
 String yourDomainName = "";
}