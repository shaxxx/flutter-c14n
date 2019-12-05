import 'package:flutter/material.dart';
import 'package:flutter_c14n/flutter_c14n.dart';

void main() => runApp(MyApp());

const String xml_test =
    "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<tns:RacunZahtjev xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Id=\"signXmlId\" xmlns:tns=\"http://www.apis-it.hr/fin/2012/types/f73\">\r\n  <tns:Zaglavlje>\r\n    <tns:IdPoruke>aac7bf07-8c0b-441a-a7d9-d3bbd6a5d3b4</tns:IdPoruke>\r\n    <tns:DatumVrijeme>02.12.2019T12:48:59</tns:DatumVrijeme>\r\n  </tns:Zaglavlje>\r\n  <tns:Racun>\r\n    <tns:Oib>94418646991</tns:Oib>\r\n    <tns:USustPdv>true</tns:USustPdv>\r\n    <tns:DatVrijeme>02.12.2019T12:48:50</tns:DatVrijeme>\r\n    <tns:OznSlijed>N</tns:OznSlijed>\r\n    <tns:BrRac>\r\n      <tns:BrOznRac>541</tns:BrOznRac>\r\n      <tns:OznPosPr>PP13</tns:OznPosPr>\r\n      <tns:OznNapUr>2</tns:OznNapUr>\r\n    </tns:BrRac>\r\n    <tns:Pdv>\r\n      <tns:Porez>\r\n        <tns:Stopa>25.00</tns:Stopa>\r\n        <tns:Osnovica>7.20</tns:Osnovica>\r\n        <tns:Iznos>1.80</tns:Iznos>\r\n      </tns:Porez>\r\n    </tns:Pdv>\r\n    \r\n    \r\n    \r\n    <tns:IznosUkupno>9.00</tns:IznosUkupno>\r\n    <tns:NacinPlac>G</tns:NacinPlac>\r\n    <tns:OibOper>11111111112</tns:OibOper>\r\n    <tns:ZastKod>49b4057e847d78659e063657b8f2587e</tns:ZastKod>\r\n    <tns:NakDost>false</tns:NakDost>\r\n  </tns:Racun>\r\n</tns:RacunZahtjev>\r\n\r\n";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = xml_test;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('c14n'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(_result),
                FlatButton(
                  child: Text("Click me"),
                  onPressed: () async {
                    if (xml_test == _result) {
                      var result = await FlutterC14n.canonicalize(
                        xml_test,
                        C14nType.exclusiveXmlC14n,
                        null,
                        null,
                      );
                      setState(() {
                        _result = result;
                      });
                    } else {
                      setState(() {
                        _result = xml_test;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
