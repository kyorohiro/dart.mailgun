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
  }*/

  try {
    pro.MiniProp prop = await sbox.route([
      //"forward(\"mosskite@gmail.com\")",
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
