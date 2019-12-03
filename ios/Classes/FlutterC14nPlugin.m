#import "FlutterC14nPlugin.h"
#if __has_include(<flutter_c14n/flutter_c14n-Swift.h>)
#import <flutter_c14n/flutter_c14n-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_c14n-Swift.h"
#endif

@implementation FlutterC14nPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterC14nPlugin registerWithRegistrar:registrar];
}
@end
