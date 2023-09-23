import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'flutter_camera_calibration_bindings_generated.dart';

const String _libName = 'flutter_camera_calibration';

/// The dynamic library in which the symbols for [FlutterCameraCalibrationBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final FlutterCameraCalibrationBindings _bindings = FlutterCameraCalibrationBindings(_dylib);

String opencvVersion() => _bindings.opencvVersion().cast<Utf8>().toDartString();
