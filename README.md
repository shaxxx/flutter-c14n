# flutter_c14n

XML canonicalization for Flutter.

## Canonicalization types

On iOS uses libxml2 system library from SDK, on Android uses [XOM](http://www.xom.nu/)
Supports original C14N 1.0 spec, C14N 1.1 spec, exclusive C14n 1.0 spec (with or without comments).
To sign only part of XML with Id attribute (ie. signXmlId) you can use XPath like this

```"//*[@Id='signXmlId']/descendant-or-self::node() | //*[@Id='signXmlId']/descendant-or-self::*/@* | //*[@Id='signXmlId']/descendant-or-self::*/namespace::*```