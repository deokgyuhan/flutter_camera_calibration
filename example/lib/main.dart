import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_calibration/flutter_camera_calibration.dart' as flutter_camera_calibration;
import 'package:image_picker/image_picker.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String version;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    version = flutter_camera_calibration.opencvVersion();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'OpenCV Version: $version',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),

                ElevatedButton(
                  onPressed: () async {
                    String? filePath = "";
                    String full_path = "";

                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      filePath =  result.files.single.path;
                      full_path = filePath.toString();
                      if(filePath != null) {
                        print("----------------->filePath: " + filePath);
                        print("----------------->full path: " + full_path);
                      }
                    } else {
                      // User canceled the picker
                    }

                    // final List<XFile>? images = await _picker.pickMultiImage();
                    // final List<String> imagePaths = [];

                    // if(images != null) {
                    //   for (final image in images) {
                    //     final imagePath = image?.path ?? "none";
                    //     print("-----------"+imagePath.toString());
                    //     imagePaths.add(imagePath);
                    //   }
                    // }
                    final List<String> imagePaths = [];

                    await loadAssets();

                    if(images != null) {
                      for (final image in images) {
                        final imagePath = image?.identifier ?? "none";
                        print("-----------"+imagePath.toString());
                        imagePaths.add(imagePath);
                      }
                    }

                    final calibration_result = await flutter_camera_calibration.camera_calibrate(full_path, imagePaths);
                    // 결과 사용
                    print('------------------------------------------------------------------------->');
                    print('---------------------------------------->rows: ' + calibration_result.rows.toString());
                    print('---------------------------------------->cols: ' + calibration_result.cols.toString());
                    print('---------------------------------------->length: ' + calibration_result.length.toString());

                  },
                  child: Text("카메라 캘리브레이션"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Asset> images = <Asset>[];

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultipleImagesPicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      // _error = error;
    });
  }
}
