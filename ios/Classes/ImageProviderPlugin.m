#import "ImageProviderPlugin.h"
#if __has_include(<image_provider/image_provider-Swift.h>)
#import <image_provider/image_provider-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "image_provider-Swift.h"
#endif

@implementation ImageProviderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImageProviderPlugin registerWithRegistrar:registrar];
}
@end
