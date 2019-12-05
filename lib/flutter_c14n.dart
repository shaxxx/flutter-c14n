import 'dart:async';

import 'package:flutter/services.dart';

enum C14nType {
  canonicalXml,
  canonicalXmlWithComments,
  canonicalXml11,
  canonicalXml11WithComments,
  exclusiveXmlC14n,
  exclusiveXmlC14nWithComments
}

const Map<C14nType, String> canonicalNamespaces = {
  C14nType.canonicalXml: "http://www.w3.org/TR/2001/REC-xml-c14n-20010315",
  C14nType.canonicalXml11: "http://www.w3.org/2006/12/xml-c14n11",
  C14nType.canonicalXml11WithComments:
      "http://www.w3.org/2006/12/xml-c14n11#WithComments",
  C14nType.canonicalXmlWithComments:
      "http://www.w3.org/TR/2001/REC-xml-c14n-20010315#WithComments",
  C14nType.exclusiveXmlC14n: "http://www.w3.org/2001/10/xml-exc-c14n#",
  C14nType.exclusiveXmlC14nWithComments:
      "http://www.w3.org/2001/10/xml-exc-c14n#WithComments",
};

const String xml_namespace = "http://www.w3.org/XML/1998/namespace";

class FlutterC14n {
  static const MethodChannel _channel = const MethodChannel('flutter_c14n');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> canonicalize(
    String xml,
    C14nType c14nType,
    List<String> inclusiveNamespacePrefixList,
    String xPathQuery,
  ) async {
    Map<String, dynamic> args = {
      "xml": xml,
      "c14nType": c14nType.index,
      "inclusiveNamespacePrefixList": inclusiveNamespacePrefixList,
      "xPathQuery": xPathQuery,
    };
    try {
      return await _channel.invokeMethod("canonicalize", args);
    } on PlatformException catch (e) {
      return e.message;
    }
  }
}
