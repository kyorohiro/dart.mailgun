
part of me.k07.mailgun;

class SendBox {
  req.NetBuilder builder;
  Config config;


  SendBox(this.builder, this.config) {
  }

  /*
  curl -s --user 'api:YOUR_API_KEY' \
    https://api.mailgun.net/v3/YOUR_DOMAIN_NAME/messages \
    -F from='Excited User <mailgun@YOUR_DOMAIN_NAME>' \
    -F to=YOU@YOUR_DOMAIN_NAME \
    -F to=bar@example.com \
    -F subject='Hello' \
    -F text='Testing some Mailgun awesomness!'
  */
  Future<SendMailProp> sendMail(String from, List<String> to, String subject, String body, 
  {List<String> cc: const<String>[], List<String> bcc:const<String>[]}) async {
    String url = "https://api.mailgun.net/v3/${YOUR_DOMAIN_NAME}/messages";
    req.Requester requester = await this.builder.createRequester();

    //
    req.Multipart multipart = new req.Multipart();
    multipart.add(new req.MultipartPlainText.fromTextPlain("from", from));
    for(String t in to) { 
      multipart.add(new req.MultipartPlainText.fromTextPlain("to", t));
    }
    for(String c in cc) { 
      multipart.add(new req.MultipartPlainText.fromTextPlain("cc", c));
    }
    for(String b in bcc) { 
      multipart.add(new req.MultipartPlainText.fromTextPlain("bcc", b));
    }
    multipart.add(new req.MultipartPlainText.fromTextPlain("subject", subject));
    multipart.add(new req.MultipartPlainText.fromTextPlain("text", body));
    req.Response response = await await multipart.post(requester, url);
    return new SendMailProp(//
      new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
  }
}



class SendMailProp {
  pro.MiniProp prop;
  SendMailProp(this.prop) {}

  String get message => prop.getString("message", "");
  String get id => prop.getString("id", "");
}