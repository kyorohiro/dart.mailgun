
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
    req.MultipartItem item = new req.MultipartPlainText.fromTextPlain("from", from);
    req.Response response = await requester.request("POST", url);
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