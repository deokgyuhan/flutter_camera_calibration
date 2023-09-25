#import "FlutterCameraCalibrationPlugin.h"
#if __has_include(<flutter_camera_calibration/flutter_camera_calibration-Swift.h>)
#import <flutter_camera_calibration/flutter_camera_calibration-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_camera_calibration-Swift.h"
#endif

@implementation FlutterCameraCalibrationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterCameraCalibrationPlugin registerWithRegistrar:registrar];
}
@end
