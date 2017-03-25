import 'package:me.k07.httprequest/request.dart' as req;
import 'package:me.k07.httprequest/request_io.dart' as req;
import 'package:me.k07.mailgun/netbox.dart' as box;
import 'package:me.k07.prop/prop.dart' as pro;
import './config.dart';

main() async {
  //config;
  req.NetBuilder builder = new req.IONetBuilder();
  box.SendBox sbox = new box.SendBox(builder, config);
  box.RouteBox rbox = new box.RouteBox(builder, config);
  /*
  try {
    box.SendMailProp prop = await sbox.sendMail(
      "Excited User <postmaster@${config.domainName}>"
 //     "Excited User <postmaster@kyorohiro.info>"
      , [
      "kyorohiro@gmail.com",
      "mosskite@gmail.com"
     // ,"test@kyorohiro.info"
    ], "test", "body",tags: ["A","B","C"]);
    print(prop.prop.toJson());
  } catch(e) {
    print("${e}");
  }*/
/*
  try {
    pro.MiniProp prop = await sbox.events(property: {"tags":"A", "event":"failed"});
    print(prop.toJson());
  } catch(e) {
    print("${e}");
  }
  
  {
    "items":[
      {
        "actions":["stop()"],
        "created_at":"Sat, 25 Mar 2017 17:13:12 GMT",
        "description":"default",
        "expression":"catch_all()",
        "id":"58d6a528d0303a4976122c03",
        "priority":0},{"actions":["stop()"],
        "created_at":"Sat, 25 Mar 2017 16:54:54 GMT",
        "description":"default",
        "expression":"catch_all()",
        "id":"58d6a0defa6095c7318eea18",
        "priority":0
      },
      {
        "actions":
          [
            "forward(\"kyorohiro@gmail.com\")"
          ],
          "created_at":"Sat, 25 Mar 2017 16:38:58 GMT",
          "description":"default",
          "expression":"catch_all()",
          "id":"58d69d22aa3de60ac050d837",
          "priority":0
       }
     ],
     "total_count":3
   }
  
  
  */

  try {
    pro.MiniProp prop = await rbox.update([
      "forward(\"mosskite@gmail.com\")",
      "stop()"]);
    print(prop.toJson());
  } catch(e) {
    print("${e}");
  }
  try {
    pro.MiniProp prop = await rbox.get();
    print(prop.toJson());
  } catch(e) {
    print("${e}");
  }
 
}
