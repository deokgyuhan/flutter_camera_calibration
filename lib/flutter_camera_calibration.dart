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

Future<CameraInfoResult> cameraCalibrate(String filePath, List<String> images) async {
  final List<Pointer<Utf8>> imagePaths = [];

    for (final path in images) {
      // final imagePath = path.toNativeUtf8() ?? "none".toNativeUtf8();
     // print("-----------"+imagePath.toString());
      final imagePath = path.toNativeUtf8();
      imagePaths.add(imagePath);
    }

  // Allocate memory for the argument pointers
  final fileListOfPointerArray = calloc<Pointer<Char>>(imagePaths.length + 1);

  // Assign the argument pointers to the array
  for (var i = 0; i < imagePaths.length; i++) {
    fileListOfPointerArray[i] = imagePaths[i].cast<Char>();
  }

  final arguments = <Pointer<Char>>[
    "main".toNativeUtf8().cast<Char>(),
    filePath.toNativeUtf8().cast<Char>()
  ];

  // Allocate memory for the argument pointers
  final argPointerArray = calloc<Pointer<Char>>(arguments.length + 1);

  // Assign the argument pointers to the array
  for (var i = 0; i < arguments.length; i++) {
    argPointerArray[i] = arguments[i];
    //print("argPointerArray[i]: "+argPointerArray[i].toDartString());
  }
  // argPointerArray[arguments.length] = nullptr; // Null-terminate the array

  // Pass the arguments to the C function
  final resultPtr = _bindings.camera_calibrate(arguments.length, argPointerArray, fileListOfPointerArray);

  calloc.free(fileListOfPointerArray);
  calloc.free(argPointerArray);

  return  _convertCameraInfoPointer(resultPtr);
}

CameraInfoResult _convertCameraInfoPointer(Pointer<Camera_Info> cameraInfoPtr) {
  final cameraInfo = cameraInfoPtr.ref;
  final rows = cameraInfo.rows;
  final cols = cameraInfo.cols;
  final length = cameraInfo.length;
  final array = cameraInfo.array.asTypedList(length);

  // 반환할 Camera_Info_Result 객체 생성
  final result = CameraInfoResult(rows, cols, length, array);

  // 사용이 끝난 cameraInfoPtr 메모리 해제
  calloc.free(cameraInfoPtr);

  return result;
}

class CameraInfoResult {
  final int rows;
  final int cols;
  final int length;
  final List<double> array;

  CameraInfoResult(this.rows, this.cols, this.length, this.array);
}

class CameraIntrincMatrix {
  final int rows;
  final int cols;
  final List<double> array;

  CameraIntrincMatrix(this.rows, this.cols, this.array) {
    if (array.length != rows * cols) {
      throw ArgumentError('Array length must match rows * cols');
    }
  }

  double get(int row, int col) {
    if (row < 0 || row >= rows || col < 0 || col >= cols) {
      throw ArgumentError('Invalid row or column index');
    }
    return array[row * cols + col];
  }

  void set(int row, int col, double value) {
    if (row < 0 || row >= rows || col < 0 || col >= cols) {
      throw ArgumentError('Invalid row or column index');
    }
    array[row * cols + col] = value;
  }

  @override
  String toString() {
    const columnWidth = 12; // 각 열의 고정된 너비

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final value = get(i, j).toStringAsFixed(2); // 소수점 두 자리까지 표시
        buffer.write(value.padLeft(columnWidth)); // 오른쪽 정렬 및 너비 설정
      }
      buffer.writeln(); // 행마다 개행 문자 추가
    }
    return buffer.toString();
  }
}
