# flutter_c14n

XML canonicalization for Flutter.

## Canonicalization types

On iOS uses libxml2 system library from SDK, on Android uses [XOM](http://www.xom.nu/)
Supports original C14N 1.0 spec, C14N 1.1 spec, exclusive C14n 1.0 spec (with or without comments).
To sign only part of XML with Id attribute (ie. signXmlId) you can use XPath like this

Using XPath query and specifying inclusive namespaces is not supported on iOS.
While it's possible to invoke libxml2 with these parameters results are not what you might expect.
Major part of canonicalization funcionality for digital signature is in fact located inside xmlsec library which is not available on iOS. If you need this plugin to digitaly sign only ONE specific node (which is not root node) inside XML you're out of luck.

```"//*[@Id='signXmlId']/descendant-or-self::node() | //*[@Id='signXmlId']/descendant-or-self::*/@* | //*[@Id='signXmlId']/descendant-or-self::*/namespace::*```