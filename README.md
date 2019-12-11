# flutter_c14n

XML canonicalization for Flutter.

## Canonicalization types

On iOS uses libxml2 system library from SDK, on Android uses [XOM](http://www.xom.nu/)
Supports original C14N 1.0 spec, C14N 1.1 spec, exclusive C14N 1.0 spec (with or without comments).

### iOS support
Using XPath query and specifying inclusive namespaces is not supported on iOS.
While it's possible to invoke libxml2 with these parameters results are not what you might expect.
IE. if you use XPath query like this one 

```"//*[@Id='signXmlId']/descendant-or-self::node() | //*[@Id='signXmlId']/descendant-or-self::*/@* | //*[@Id='signXmlId']/descendant-or-self::*/namespace::*"```

on XML included in example app you will get canonicalized result with everything except whitespaces, which is not valid C14N result.
In libxml2 you would need to manually check what should be included in result, which is not trivial.
Major part of canonicalization funcionality for digital signature is in fact located inside xmlsec library which is not available on iOS. If you need this plugin to digitaly sign only ONE specific node (which is not root node) inside XML you're out of luck (or you can improve this plugin).
If you need to use this to digitally sign entire XML document on iOS, this is still safe to use. Otherwise try to manually construct new xml with only one node you want to sign.

### Android support
On Android plugin supports both XPath and inclusive namespaces. [More info](http://www.xom.nu/apidocs/nu/xom/canonical/Canonicalizer.html).
Above XPath example will include all whitespaces and create valid C14N result.
If XPath result includes only one single node plugin will select entire node including all children. So instead of example above you could simply write

```"//*[@Id='signXmlId']"```

to canonicalize one single node from XML.
