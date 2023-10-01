import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_calibration/flutter_camera_calibration.dart' as flutter_camera_calibration;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: const MyApp(),
  ));
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('flutter_camerea_calibration example'
        ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                spacerSmall,
                Text(
                  'OpenCV Version: $version',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 300,),

                Center(
                    child: ElevatedButton(
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

                    final List<XFile>? images = await _picker.pickMultiImage();
                    final List<String> imagePaths = [];

                    if(images != null) {
                      for (final image in images) {
                        final imagePath = image?.path ?? "none";
                        print("-----------"+imagePath.toString());
                        imagePaths.add(imagePath);
                      }
                    }

                    final calibration_result = await flutter_camera_calibration.cameraCalibrate(full_path, imagePaths);

                    // 결과 사용
                    print('------------------------------------------------------------------------->');
                    print('---------------------------------------->rows: ' + calibration_result.rows.toString());
                    print('---------------------------------------->cols: ' + calibration_result.cols.toString());
                    print('---------------------------------------->length: ' + calibration_result.length.toString());

                    var matrix = flutter_camera_calibration.CameraIntrincMatrix(
                        calibration_result.rows,
                        calibration_result.cols,
                        calibration_result.array,
                      );

                    print(matrix);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Camera Calibration Result \n\nCamera Intrinsic Parameters Matrix",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          content: Container(
                            width: 400,
                            height: 300,
                            child: MatrixWidget(matrix),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Close"),
                            ),
                          ],
                        );
                      },
                    );

                  },
                  child: Text("Run Camera Calibration"),
                )
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class MatrixWidget extends StatelessWidget {
  final flutter_camera_calibration.CameraIntrincMatrix matrix;

  MatrixWidget(this.matrix);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: matrix.cols,
      ),
      itemBuilder: (context, index) {
        final row = index ~/ matrix.cols;
        final col = index % matrix.cols;
        final value = matrix.get(row, col);

        return Center(
          child: Text(
            value.toStringAsFixed(2),
            style: TextStyle(fontSize: 18.0),
          ),
        );
      },
      itemCount: matrix.rows * matrix.cols,
    );
  }
}
