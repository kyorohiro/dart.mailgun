import 'package:me.k07.httprequest/request.dart' as req;
import 'package:me.k07.httprequest/request_io.dart' as req;
import 'package:me.k07.mailgun/netbox.dart' as box;
import './config.dart';

main() async {
  //config;
  req.NetBuilder builder = new req.IONetBuilder();
  box.SendBox sbox = new box.SendBox(builder, config);
  box.SendMailProp prop = await sbox.sendMail("postmaster@${config.domainName}", ["kyorohiro@gmail.com"], "test", "body");
  print(prop);
}
