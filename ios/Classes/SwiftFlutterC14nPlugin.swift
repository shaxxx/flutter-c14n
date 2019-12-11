import Flutter
import UIKit
import libxml2

enum C14nType : integer_t {
    case canonicalXml = 0
    case canonicalXmlWithComments = 1
    case canonicalXml11 = 2
    case canonicalXml11WithComments = 3
    case exclusiveXmlC14n = 4
    case exclusiveXmlC14nWithComments = 5
}

public class SwiftFlutterC14nPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_c14n", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterC14nPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            try executeFunc(call: call, result: result)
        }  catch {
            result(FlutterError(code: "UNKNOWN_ERROR", message: "flutter_c14n plugin error", details: error.localizedDescription ))
        }
    }
    
    private func executeFunc(call: FlutterMethodCall, result:FlutterResult) throws {
        let dic = call.arguments as! [String: Any]
        switch call.method {
        case "canonicalize":
            let xml : String = dic["xml"] as! String
            let c14nType = C14nType.init(rawValue: dic["c14nType"] as! integer_t)!
            let inclusiveNamespacePrefixList : String? = dic["inclusiveNamespacePrefixList"] as? String
            let xPathQuery : String? = dic["xPathQuery"] as? String
            self.canonicalize(xml:xml,c14nType: c14nType, inclusiveNamespacePrefixList: inclusiveNamespacePrefixList, xPathQuery: xPathQuery, result: result)
        default:
            print("Method not found")
            result(FlutterMethodNotImplemented)
        }
    }
       
    private func canonicalize(xml: String, c14nType: C14nType, inclusiveNamespacePrefixList : String?, xPathQuery :String?,  result : FlutterResult) {
        let cChars = xml.cString(using: String.Encoding.utf8)
        let buffer = UnsafeBufferPointer(start: UnsafePointer(cChars), count: cChars!.count)
        let options = Int32(XML_PARSE_DTDATTR.rawValue | XML_PARSE_NOENT.rawValue)
        
        xmlInitParser()
        xmlSubstituteEntitiesDefault(1);
        
        guard let xmlDoc = xmlReadMemory(buffer.baseAddress, Int32(buffer.count), "", nil, options) else {
            xmlCleanupParser()
            xmlCleanupMemory()
            errorResult(result: result)
            return
        }
                
        /*guard let xpathCtx : xmlXPathContextPtr = xmlXPathNewContext(xmlDoc) else {
            xmlFreeDoc(xmlDoc)
            xmlCleanupParser()
            xmlCleanupMemory()
            errorResult(result: result)
            return
        }
        
        
        var nsPrefixes : UnsafeMutablePointer<xmlChar>?
        if (inclusiveNamespacePrefixList != nil && inclusiveNamespacePrefixList!.count > 0){
            for ns in inclusiveNamespacePrefixList!{
                xmlXPathRegisterNs(xpathCtx, ns.key.utf8CString.map { xmlChar(bitPattern: $0) }, ns.value.utf8CString.map { xmlChar(bitPattern: $0) })
            }
        }

        var nodes : xmlNodeSetPtr!
        if (xPathQuery != nil && xPathQuery != ""){
            guard let xPathObj = xmlXPathEvalExpression( xPathQuery, xpathCtx) else {
                xmlFreeDoc(xmlDoc)
                xmlCleanupParser()
                xmlCleanupMemory()
                errorResult(result: result)
                return
            }
            nodes = xPathObj.pointee.nodesetval ?? nil
        }*/
        
        let withComments : Int32 = (c14nType == C14nType.canonicalXml11WithComments || c14nType == C14nType.exclusiveXmlC14nWithComments) ? 1 : 0
        var cType : Int32
        switch c14nType {
        case C14nType.canonicalXml:
            cType = 0
        case C14nType.canonicalXmlWithComments:
            cType = 0
        case C14nType.exclusiveXmlC14n:
            cType = 1
        case C14nType.exclusiveXmlC14nWithComments:
            cType = 1
        case C14nType.canonicalXml11:
            cType = 2
        case C14nType.canonicalXml11WithComments:
            cType = 2
        }
        var c14nResult : UnsafeMutablePointer<xmlChar>? = nil
        let c14n = xmlC14NDocDumpMemory(xmlDoc, nil, cType,nil, withComments,&c14nResult)
        if (c14n < 0){
            xmlFreeDoc(xmlDoc)
            xmlCleanupParser()
            xmlCleanupMemory()
            errorResult(result: result)
            return
        }
        xmlFreeDoc(xmlDoc)
        xmlCleanupParser()
        xmlCleanupMemory()
        result(stringFrom(xmlchar: &c14nResult!.pointee))
    }
    
    private func errorResult(result:FlutterResult){
        let errorPtr = xmlGetLastError()
        if (errorPtr != nil){
            let message = NSString(utf8String: errorPtr!.pointee.message)! as String
            let code = Int(errorPtr!.pointee.code)
            xmlResetError(errorPtr)
            xmlResetLastError()
            result(FlutterError(code: "LIBXML_ERROR", message: message, details: code))
        }
    }
    
    func stringFrom(xmlchar: UnsafePointer<xmlChar>) -> String {
        let string = xmlchar.withMemoryRebound(to: CChar.self, capacity: 1) {
            return String(validatingUTF8: $0)
        }
        return string ?? ""
    }
}



