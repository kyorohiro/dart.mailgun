
part of me.k07.mailgun;

class RouteBox {
  req.NetBuilder builder;
  Config config;


  RouteBox(this.builder, this.config) {
  }


  Future<pro.MiniProp> update(List<String> actions,{
    int priority:0,
    String description:"default",
    String expression: "catch_all()",
    id: null,
    }) async {
    String url = "https://api.mailgun.net/v3/routes";
    url += ((id==""||id==null)?"":"/${id}");
    req.Requester requester = await this.builder.createRequester();
    req.Multipart multipart = new req.Multipart();
    multipart.add(new req.MultipartPlainText.fromTextPlain("priority", "${priority}"));
    multipart.add(new req.MultipartPlainText.fromTextPlain("description", "${description}"));
    multipart.add(new req.MultipartPlainText.fromTextPlain("expression", "${expression}"));
    for(String action in actions) {
      multipart.add(new req.MultipartPlainText.fromTextPlain("action", "${action}"));
    }
    //
    //
    String boundary = multipart.createBoundary();
    List<int> dat =multipart.bakeMultiPartFromBinary(boundary);

    Map<String,String> headers = {
      "Content-Type": """multipart/form-data; boundary=${boundary}""",
      "Authorization": "Basic "+conv.BASE64.encode(conv.UTF8.encode("api:"+config.secretAPIKey))
    };
    req.Response response = await requester.request(
        ((id==""||id==null)?req.Requester.TYPE_POST:req.Requester.TYPE_PUT),//
         url, //
        data: dat, //
        headers: headers );
    return new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false);
  }


  Future<pro.MiniProp> get({int limit:100, int skip:0, int id:null}) async {
    String url = "https://api.mailgun.net/v3/routes";
    url += ((id==""||id==null)?"":"/${id}");
    req.Requester requester = await this.builder.createRequester();

    StringBuffer options = new StringBuffer();
    Map<String,String> property = {"limit":"${limit}", "skip":"${skip}"};
    property.forEach((String k, String v){
      if(v== "") {
        return;
      }
      if(options.length > 0) {
        options.write("&");
      } else {
        options.write("?");        
      }
      options.write("${k}=${req.PercentEncode.encode(conv.UTF8.encode(v))}");
    });

    req.Response response = await requester.request(
      req.Requester.TYPE_GET, 
      url+options.toString(),
      headers:<String,String>{
        "Authorization": "Basic "+conv.BASE64.encode(conv.UTF8.encode("api:"+config.secretAPIKey))
      });
    return new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false);
  }

  Future<pro.MiniProp> delete(int id) async {
    String url = "https://api.mailgun.net/v3/routes/${id}";

    req.Requester requester = await this.builder.createRequester();

    req.Response response = await requester.request(
      req.Requester.TYPE_DELETE, 
      url,
      headers:<String,String>{
        "Authorization": "Basic "+conv.BASE64.encode(conv.UTF8.encode("api:"+config.secretAPIKey))
      });
    return new pro.MiniProp.fromByte(response.response.asUint8List(), errorIsThrow: false);
  }
}


