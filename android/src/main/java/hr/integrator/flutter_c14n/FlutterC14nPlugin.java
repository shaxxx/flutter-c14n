package hr.integrator.flutter_c14n;

import java.util.Map;
import android.util.Log;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import nu.xom.Nodes;
import nu.xom.canonical.Canonicalizer;
import nu.xom.Builder;
import nu.xom.Document;
import nu.xom.ParsingException;

/** FlutterC14nPlugin */
public class FlutterC14nPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_c14n");
    channel.setMethodCallHandler(new FlutterC14nPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("canonicalize")) {
      String xml = call.argument("xml");
      java.lang.Integer c14nType =  call.argument("c14nType");
      String inclusiveNamespacePrefixList = call.argument("inclusiveNamespacePrefixList");
      String xPathQuery = call.argument("xPathQuery");
      canonicalize(xml, C14nType.values()[c14nType], inclusiveNamespacePrefixList, xPathQuery, result);
    } else {
      android.util.Log.d("flutter_c14n", "Method not found");
      result.notImplemented();
    }
  }

  void canonicalize(String xml, C14nType c14nType, String inclusiveNamespacePrefixList, String xPathQuery, MethodChannel.Result result ){
    InputStream is = new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8));
    Builder parser = new Builder();
    Document doc = null;

    try {
      doc = parser.build(is);
    } catch (ParsingException e) {
      e.printStackTrace();
      result.error("XOM_ERROR", "Failed to parse document", e.toString() );
      return;
    } catch (IOException e) {
      e.printStackTrace();
      result.error("IO_ERROR", "Failed to load document", e.toString() );
      return;
    }

    String cType = "";
    switch (c14nType){
      case canonicalXml:
        cType = Canonicalizer.CANONICAL_XML;
        break;
      case canonicalXmlWithComments:
        cType = Canonicalizer.CANONICAL_XML_WITH_COMMENTS;
        break;
      case exclusiveXmlC14n:
        cType = Canonicalizer.EXCLUSIVE_XML_CANONICALIZATION;
        break;
      case exclusiveXmlC14nWithComments:
        cType = Canonicalizer.EXCLUSIVE_XML_CANONICALIZATION_WITH_COMMENTS;
        break;
      case canonicalXml11:
        cType = Canonicalizer.CANONICAL_XML_11;
        break;
      case canonicalXml11WithComments:
        cType = Canonicalizer.CANONICAL_XML_11_WITH_COMMENTS;
        break;
    }

    ByteArrayOutputStream canonicalOs = new ByteArrayOutputStream();
    Canonicalizer canonicalizer = new Canonicalizer(canonicalOs,cType);
    canonicalizer.setInclusiveNamespacePrefixList(inclusiveNamespacePrefixList);

    try {
      if (xPathQuery != null && xPathQuery.length() > 0) {
        Nodes nodes = doc.query(xPathQuery);
        if (nodes.size() == 1) {
          canonicalizer.write(nodes.get(0));
        }
        else {
          canonicalizer.write(nodes);
        }
      }
      else {
        canonicalizer.write(doc);
      }
    } catch (IOException e) {
      e.printStackTrace();
      result.error("XOM_ERROR", "Canonicalization failed", e.toString() );
      return;
    }
    byte[] canonXmlBytes = canonicalOs.toByteArray();
    try {
      Log.d("XML",canonicalOs.toString("utf8"));
      result.success(canonicalOs.toString("utf8"));
    } catch (UnsupportedEncodingException e) {
      e.printStackTrace();
      result.error("XOM_ERROR", "Unsupported encoding", e.toString() );
    }
  }

  enum C14nType  {
    canonicalXml,
    canonicalXmlWithComments,
    canonicalXml11,
    canonicalXml11WithComments,
    exclusiveXmlC14n,
    exclusiveXmlC14nWithComments
  }
}
