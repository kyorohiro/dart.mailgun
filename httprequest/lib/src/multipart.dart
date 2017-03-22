part of httprequest;

class MultipartItem {
  String name;

  List<List<int>> toBytesList() {
    return [];
  }
}

class MultipartPlainText extends MultipartItem {
  String name;
  String value;
  String contentType = "text/plain";
  String charset = "UTF-8";

  List<List<int>> toBytesList() {
    List<List<int>> bufferList = [];
    bufferList.add(ASCII.encode("""Content-Disposition: form-data; name="${name}"\r\n"""));
//    bufferList.add(ASCII.encode("""Content-Type: ${contentType}; charset="${charset}"; \r\n"""));
    bufferList.add(ASCII.encode("""\r\n"""));
    bufferList.add(UTF8.encode(value));
    return bufferList;
  }

  MultipartPlainText.fromTextPlain(this.name,  this.value) {
  }
}




class MultipartBinary extends MultipartItem {
  String name;
  String fileName;
  String contentType;
  typed.ByteBuffer buffer;

  // "data:image/png:base64,xxxxx..."
  factory MultipartBinary.fromBase64(String name, String fileName, String contentType, String base64Src) {
    return new MultipartBinary.fromList(name, fileName, contentType, BASE64.decode(base64Src));
  }

  MultipartBinary.fromList(this.name, this.fileName, this.contentType, List<int> data) {
    if(data is typed.Uint8List) {
      buffer = data.buffer;
    } else {
      buffer = new typed.Uint8List.fromList(data).buffer;
    }
  }

  MultipartBinary.fromByteBuffer(this.name, this.fileName, this.contentType, this.buffer) {
  }


  List<List<int>> toBytesList() {
    List<List<int>> bufferList = [];
    bufferList.add(ASCII.encode("""Content-Disposition: form-data; name="${name}"; filename="${fileName}"\r\n"""));
    bufferList.add(ASCII.encode("""Content-Type: ${contentType}\r\n"""));
    bufferList.add(ASCII.encode("""\r\n"""));
    bufferList.add(buffer.asUint8List());
    return bufferList;
  }
}
//
// todo. dart:html version should use formdata class or blob
//
class Multipart {
  List<MultipartItem> items = [];
  Future<Response> post(Requester requester, String url, {Map<String,String> headers:null}) async {
    String boundary = "----" + Uuid.createUUID().replaceAll("-", "");
    List<int> dat =bakeMultiPartFromBinary(boundary);

    if(headers == null) {
      headers = <String,String>{};
    }
    headers["Content-Type"] = """multipart/form-data; boundary=${boundary}""";
   // print(headers);
  // print(UTF8.decode(dat));
    return await requester.request(Requester.TYPE_POST, url, //
        data: dat, //
        headers: headers );
  }

  add(MultipartItem item){
    items.add(item);
  }

  List<int> bakeMultiPartFromBinary(String boundary) {
    List<List<int>> buffer = [];
    buffer.add(ASCII.encode("""--${boundary}\r\n"""));
    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      buffer.addAll(item.toBytesList());
      buffer.add(ASCII.encode("""\r\n"""));
      buffer.add(ASCII.encode("""--${boundary}${i==items.length-1?"--":""}\r\n"""));
    }
    buffer.add(ASCII.encode("""\r\n"""));

    int length = 0;
    for (var b in buffer) {
      length += b.length;
    }
    var index = 0;
    var byteBuffer = new typed.Uint8List(length);
    for (var b in buffer) {
      byteBuffer.setAll(index, b);
      index += b.length;
    }
   // print(UTF8.decode(byteBuffer));
    return byteBuffer;
  }
}
