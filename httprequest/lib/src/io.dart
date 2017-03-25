part of iover;

class IONetBuilder extends NetBuilder {
  Future<Requester> createRequester() async {
    return new IORequester();
  }
}

class IORequester extends Requester {
  Future<Response> request(String type, String url, {Object data: null, Map<String, String> headers: null}) async {
    if (headers == null) {
      headers = {};
    }
    //print("[A1] ${type} ${url} ${headers}");
   /// print("${UTF8.decode(data)}");
    io.HttpClient client = new io.HttpClient(context: io.SecurityContext.defaultContext);

   // print("[A2]");
   //url = "https://google.com";
    io.HttpClientRequest req = await client.openUrl(type, Uri.parse(url));

  //  print("[A3]");
    for (String k in headers.keys) {
      req.headers.add(k, headers[k]);
    }
    req.followRedirects = true;
    if (data != null) {
      if(data is String) {
       req.write(data);
      } else {
       req.add(data);
     }
   }
   // print("[A4]");
   io.HttpClientResponse res = await req.close();
    List<List<int>> v = await res.toList();
   // print("[A5]");
    Map<String, List<String>> headerss = {};
    res.headers.forEach((String name, List<String> values) {
      headerss[name] = new List.from(values);
    });


    int length = 0;
    v.forEach((vv)=>length+=vv.length);
    typed.Uint8List vv = new typed.Uint8List(length);
    int index = 0;
    v.forEach((List<int> v){
      vv.setAll(index, v);
      index += v.length;
    });
   // print(UTF8.decode(vv,allowMalformed: true));
    var ret = new Response(res.statusCode, headerss, new typed.Uint8List.fromList(vv).buffer);
   // print("[A8]");
    return ret;
  }
}
