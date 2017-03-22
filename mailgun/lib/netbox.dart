library me.k07.mailgun;
import 'package:me.k07.prop/prop.dart' as prop; 
import 'dart:async';


class ErrorProp {
  pro.MiniProp prop;
  ErrorProp(this.prop) {}
  //"errorCode"
  //"errorMessage"
  int get errorCode => prop.getNum("errorCode", 0);
  String get errorMessage => prop.getString("errorMessage", "");
}
