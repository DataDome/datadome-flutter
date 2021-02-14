#import "DatadomePlugin.h"
#if __has_include(<datadome/datadome-Swift.h>)
#import <datadome/datadome-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "datadome-Swift.h"
#endif

@implementation DatadomePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDatadomePlugin registerWithRegistrar:registrar];
}
@end
