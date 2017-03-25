
part of me.k07.mailgun;

class SendBox {
  req.NetBuilder builder;
  Config config;


  SendBox(this.builder, this.config) {
  }

  Future<pro.MiniProp> route(List<String> actions,{
    int priority:0,
    String description:"default",
    String expression: "catch_all()",
    }) async {
    String url = "https://api.mailgun.net/v3/routes";
    req.Requester requester = await this.builder.createRequester();
    req.Multipart multipart = new req.Multipart();
    multipart.add(new req.MultipartPlainText.fromTextPlain("priority", "${priority}"));
    multipart.add(new req.MultipartPlainText.fromTextPlain("description", "${description}"));
    multipart.add(new req.MultipartPlainText.fromTextPlain("expression", "${expression}"));
    for(String action in actions) {
      multipart.add(new req.MultipartPlainText.fromTextPlain("action", "${action}"));
    }
    req.Response response = await await multipart.post(requester, url,
    headers:<String,String>{"Authorization": "Basic "+conv.BASE64.encode(conv.UTF8.encode("api:"+config.secretAPIKey)) });
    print("xxs${response.status}");
    return new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false);
  }

/*
curl -s --user 'api:YOUR_API_KEY' -G \
    https://api.mailgun.net/v3/YOUR_DOMAIN_NAME/events

curl -s --user 'api:YOUR_API_KEY' -G \
      https://api.mailgun.net/v3/YOUR_DOMAIN_NAME/events \
      --data-urlencode begin='Fri, 3 May 2013 09:00:00 -0000' \
      --data-urlencode ascending=yes \
      --data-urlencode limit=25 \
      --data-urlencode pretty=yes \
      --data-urlencode recipient=joe@example.com
          String data = "";//Fri, 3 May 2013 09:00:00 -0000
    intl.DateFormat f = new intl.DateFormat("EEE, d MMM yyyy HH:mm:ss");
    int timestump = (new DateTime.now()).millisecondsSinceEpoch;
    DateTime s = new DateTime.fromMillisecondsSinceEpoch(timestump-1000*60*60, isUtc: false);
    DateTime e = new DateTime.fromMillisecondsSinceEpoch(timestump, isUtc: false);
    data = "begin="+ req.PercentEncode.encode(conv.UTF8.encode(f.format(s)+ " +0900")); 
    data += "&end="+ req.PercentEncode.encode(conv.UTF8.encode(f.format(e)+ " +0900")); 
*/
  Future<pro.MiniProp> events({Map<String,String> property:const{}}) async {
    String url = "https://api.mailgun.net/v3/${this.config.domainName}/events";
    req.Requester requester = await this.builder.createRequester();

    StringBuffer options = new StringBuffer();
    property.forEach((String k, String v){
      if(options.length > 0) {
        options.write("&");
      } else {
        options.write("?");        
      }
      options.write("${k}=${req.PercentEncode.encode(conv.UTF8.encode(v))}");
    });
    //
    print(options.toString());
    req.Response response = await requester.request(
      req.Requester.TYPE_GET, //
      url+options.toString(),
      headers:<String,String>{ //
        "Authorization": "Basic "+conv.BASE64.encode(conv.UTF8.encode("api:"+config.secretAPIKey)) ,
      }
    );
    print("xxs${response.status}");
    return new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false);
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
  Future<SendMailProp> sendMail(
    String from, List<String> to, String subject, String body, {//
      List<String> cc: const<String>[],//
      List<String> bcc:const<String>[],
      List<String> tags:const<String>[],
   }) async {
    String url = "https://api.mailgun.net/v3/${this.config.domainName}/messages";
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
    for(String t in tags) { 
      multipart.add(new req.MultipartPlainText.fromTextPlain("o:tag", t));
    }
    
    
    multipart.add(new req.MultipartPlainText.fromTextPlain("subject", subject));
    multipart.add(new req.MultipartPlainText.fromTextPlain("text", body));
    req.Response response = await await multipart.post(requester, url,
    headers:<String,String>{"Authorization": "Basic "+conv.BASE64.encode(conv.UTF8.encode("api:"+config.secretAPIKey)) });
    switch(response.status) {
      case 200:
        return new SendMailProp(//
          new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false));
          break;
      case 400:
        throw new Exception("EXCEPTION_MISSING_REQUIRED_PARAMETERS");
      case 401:
        throw new Exception("EXCEPTION_GENERIC_HTTP_ERROR");
      case 404:
        throw new Exception("EXCEPTION_GENERIC_HTTP_ERROR");
      default:
        throw new Exception("EXCEPTION_GENERIC_HTTP_ERROR");
    }
  }
}



class SendMailProp {
  pro.MiniProp prop;
  SendMailProp(this.prop) {}

  String get message => prop.getString("message", "");
  String get id => prop.getString("id", "");

  String toString(){
    return prop.toJson();
  }
}