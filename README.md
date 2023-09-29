# flutter_camera_calibration

A new Flutter FFI plugin project.

## Getting Started

This project is a starting point for a Flutter
[FFI plugin](https://docs.flutter.dev/development/platform-integration/c-interop),
a specialized package that includes native code directly invoked with Dart FFI.

## Project structure

This template uses the following structure:

* `src`: Contains the native source code, and a CmakeFile.txt file for building
  that source code into a dynamic library.

* `lib`: Contains the Dart code that defines the API of the plugin, and which
  calls into the native code using `dart:ffi`.

* platform folders (`android`, `ios`, `windows`, etc.): Contains the build files
  for building and bundling the native code library with the platform application.

## Building and bundling native code

The `pubspec.yaml` specifies FFI plugins as follows:

```yaml
  plugin:
    platforms:
      some_platform:
        ffiPlugin: true
```

This configuration invokes the native build for the various target platforms
and bundles the binaries in Flutter applications using these FFI plugins.

This can be combined with dartPluginClass, such as when FFI is used for the
implementation of one platform in a federated plugin:

```yaml
  plugin:
    implements: some_other_plugin
    platforms:
      some_platform:
        dartPluginClass: SomeClass
        ffiPlugin: true
```

A plugin can have both FFI and method channels:

```yaml
  plugin:
    platforms:
      some_platform:
        pluginClass: SomeName
        ffiPlugin: true
```

The native build systems that are invoked by FFI (and method channel) plugins are:

* For Android: Gradle, which invokes the Android NDK for native builds.
  * See the documentation in android/build.gradle.
* For iOS and MacOS: Xcode, via CocoaPods.
  * See the documentation in ios/flutter_camera_calibration.podspec.
  * See the documentation in macos/flutter_camera_calibration.podspec.
* For Linux and Windows: CMake.
  * See the documentation in linux/CMakeLists.txt.
  * See the documentation in windows/CMakeLists.txt.

## Binding to native code

To use the native code, bindings in Dart are needed.
To avoid writing these by hand, they are generated from the header file
(`src/flutter_camera_calibration.h`) by `package:ffigen`.
Regenerate the bindings by running `flutter pub run ffigen --config ffigen.yaml`.

## Invoking native code

Very short-running native functions can be directly invoked from any isolate.
For example, see `sum` in `lib/flutter_camera_calibration.dart`.

Longer-running functions should be invoked on a helper isolate to avoid
dropping frames in Flutter applications.
For example, see `sumAsync` in `lib/flutter_camera_calibration.dart`.

## Flutter help

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# - 작업일지 - 

## 2023.06.21
* poisson surface reconstruction => 지원 라이브러리 cgal
* ubuntu에 pcl 설치 실패
* mac 에서는 현재 opencv와 pcl은 제대로 설치되어 있다. mac에서는 절대로 cmake 소스 컴파일하면 안된다. 더이상 mac에 slam관련해서는 설치 안한다. 
* opencv와 pcl로 프로그래밍하고 ubuntu에 셋팅해서 돌려보도록 한다.

   Ceres-solver iOS 빌드 => 실패
   사전에 설치해야 하는것들
   sudo port install SuiteSparse

   https://github.com/ethereon/ceres-solver-ios/blob/master/ceres-solver/docs/source/building.rst

    >cmake ../ceres-solver \
      -DCMAKE_TOOLCHAIN_FILE=../ceres-solver/cmake/iOS.cmake \
      -DEIGEN_INCLUDE_DIR=/usr/local/include/eigen3 \
      -DEigen3_DIR=/usr/local/share/eigen3/cmake
      #-Dgflags_DIR=/usr/local/Cellar/gflags/2.2.2/lib/cmake/gflags  \   -> 제외 이건 지원안함.
      -DIOS_PLATFORM=OS

    > make -j4

* 답답해서 챗GPT에게 문의후 답변내용

  OS에서 사용할 수 있는 몇 가지 그래프 최적화 라이브러리는 다음과 같습니다:


    Apple Accelerate Framework:
    Apple Accelerate Framework은 iOS와 macOS에서 사용할 수 있는 고성능 수치 계산 라이브러리입니다.
    그래프 최적화와 관련된 다양한 기능을 제공하며, 선형 대수, 신호 처리, 이미지 처리, 머신 러닝 등 다양한 분야에서 사용됩니다.

    TensorFlow Lite:
    TensorFlow Lite는 Google의 오픈 소스 머신 러닝 프레임워크인 TensorFlow의 경량 버전으로, 
    모바일 및 임베디드 기기에서 사용하기에 최적화되어 있습니다. TensorFlow Lite는 그래프 최적화 기능을 제공하며, iOS에서도 사용할 수 있습니다.
    
    Core ML:
    Core ML은 Apple의 머신 러닝 프레임워크로, iOS 및 macOS 애플리케이션에서 머신 러닝 모델을 통합할 수 있도록 지원합니다. 
    Core ML은 그래프 최적화와 모델 변환 기능을 제공하여 모델의 크기를 축소하고 실행 성능을 향상시킬 수 있습니다.
    
    Caffe2:
    Caffe2는 Facebook에서 개발한 머신 러닝 프레임워크로, 모바일 및 임베디드 기기에서의 효율적인 실행을 지원합니다. 
    Caffe2는 그래프 최적화 기능을 포함하고 있으며, iOS에서도 사용할 수 있습니다.
    
    이 외에도 iOS에서 사용할 수 있는 다른 그래프 최적화 라이브러리들이 존재할 수 있습니다. 
    선택할 라이브러리는 프로젝트의 요구사항, 사용하는 모델 및 애플리케이션의 성능 목표에 따라 다를 수 있습니다. 
    따라서 프로젝트의 요구사항을 고려하여 적절한 라이브러리를 선택하는 것이 좋습니다.

Apple Accelerate Framework 당첨

## 2023.06.28 지금까지 회고

#### 이전 작업내용 요약
- 2d 이미지를 3d로 복원하는 앱을 만들고 싶었다. 그래서 2달간 방황하면서 컴퓨터 그래픽스를 처음에 공부하였다.
  그러나 만들어 본건 없고 단지 오픈지엘하고 벌칸으로 된 예제소스를 가지고 공부하면서 컴퓨터 그래픽스 알고리즘을 보면서 책을 공부했다


- 레이트레이싱이 해보고 싶어서 이리저리 헤매다가 Scratchapixel 3.0 사이트를 참고하여 몇주간 계속 읽고 공부하기 시작했다. 아주 아주 좋았다

  -> https://www.scratchapixel.com -> 이 사이트의 몇가지 파트 빼고는 다 번역기 돌려서 읽어보고 이해하려고 했다


- 그러다가 컴퓨터 비전으로 이어졌다. 무작정 3d 복원을 하려고 찾아보다가 visual slam 을 알게되었고 오픈챗팅방에 참여하고 기초를 보면서 공부하기 시작했다.
  -> 그러면서 찾은 레퍼런스
    1.  카메라 캘리브레이션이란 ?  -> https://darkpgmr.tistory.com/32
    2.  영상 지오메트리의 호모지니어스 좌표계란 -> https://darkpgmr.tistory.com/78
    3.  https://pcl.gitbook.io/tutorial


  https://github.com/polygon-software/python-visual-odometry <- 중요
  python3 -m pip install --user matplotlib

  https://076923.github.io/posts/Python-opencv-19/

  https://github.com/abhijitmahalle/stereo-vision -> 삼각측량

  맥(macOS)에서 PointCloudLibrary(PCL) 설치하기
  https://popcorn16.tistory.com/40

  https://pcl.gitbook.io/tutorial/part-0/part00-chapter02

  에피폴라 라인을 일치시키는 렉티피케이션 => http://www.ntrexgo.com/archives/2280

  에피폴라 매트릭스 유도 => https://blog.naver.com/hms4913/220043661788

  Colmap => https://velog.io/@seosan/Colmap이란

  Edge에서 검출한 픽셀들은 곧 연속되어 있는 랜드마크를 의미하고,

  https://github.com/jacking75/examples_CMake => 사용법

  사전확률/사후확률/가능도 => https://m.blog.naver.com/bsw2428/221388415015

- 컴퓨터 그래픽스와 컴퓨터 비전은 서로 연관되어 있으면서 컴퓨터 그래픽스는 가상을 현실에 가깝게 시뮬레이션하는 것이고
  컴퓨터 비전은 현실을 가상으로 복원하는 것이라는 점에서 차이가 있고 카메라 좌표계 월드좌표계 영상좌표계 정규좌표계 등
  여러가지가 중요하다는 것을 이해하였다.


- flutter에서 2D 이미지를 복원하기 위해서 visual slam의 프론트 엔드 부분은 visual odemetry 부분을 구현해보기 위해서
  제일 많이 쓰는 opencv를 배우기 시작했다. 당연히 c++ 코드를 flutter에서 이용하기 위해서 ffi 라이브러리를 이용해서 epipolar geometry를 이용해서 특징점 추출후
  에피폴라 라인을 표시하는 opencv 예제를 이용해서 flutter에서 구현해보았다. 현재 그 전에 카메라의 정확한 내부 파라미터를 구해야 해서 카메라 캘리브레이션 기능을 포팅해보고 있다.


- 3d 복원을 위해서 pcl, open3d, colmap 등 여러 라이브러리를 찾아보고 설치해봤지만 ios에서 직접 이용할 수 있는 방법은 없고 거의 대부분이 ubuntu 리눅스에 특화되어 있다.
  개인정보때문에 앱에서 모든 기능을 다 구현하려고 했으나 한계점에 있다. 플랫폼에 따른 라이브러리 의존성 그리고 모바일앱의 컴퓨팅 리소스 부분.
  그래서 복원하는 부분은 서버로 별도로 분리해서 해보기로 구상중인데 opencv에서 2d 이미지를 분석하여 3d 좌표로 구해도 포인트 클라우드 데이터를 처리하고 메쉬로 변환하는 등의
  작업을 하려면 3d 영상을 처리하는 라이브러리인 pcl, open3d의 도움을 받아야 한다. 그리고 복원하기 위한 여러가지 등을..


- flutter를 좀더 해보기 위해서 flutter 온라인 스터디에 참여했고 파이어베이스를 가입하고 프로젝트를 만들어 놓았다.


- ios에서 지원하는 arkit을 이용한 기능을 flutter에서 예제를 가지고 해보았다.


- flutter에서 직접 네이티브 코드를 호출해야 하는 경우가 있을지 몰라서 swift 코드를 호출하는 예제를 찾아서 만들어보았다.

오늘 이렇게 작성하는 이유는 이제 프로젝트로 진행되어서 정리차원에서 작성

## 2023.06.28

* 금일 진행사항 => opencv 캘리브레이션 소스를 분석해서 flutter에 추가하는 걸 목표로 한다.
 

* 계속해서 리 대수 읽고, 알고리즘 계속 공부..

 
* ubuntu에 설치하고 centos는 삭제


* 먼저 xml로 정보 읽어서 셋팅하는 부분을 객체로 넘기는 부분에 대하여. 
  flutter에서 c++ 코드를 호출할때는 메모리 정보를 이용해야 하고 그게 아니면 앱을 시작하고
  앱에서 파일 선택해서 넘기던가 해야 한다. 직접적으로 경로를 주고 읽는 것은 불가능


* 캘리브레이션 결과중 내부 파라미터 행렬만 받아오는것 성공.. cv::Mat객체를 받아오는건 힘들다. 그래서 cv::Mat의 data만 1차원 어레이로 만들어서 넘겨주는걸로 함.
  -> setting에서 input 파일 접근안하고 플러터에서 선택한 이미지 리스트로 사용하게끔 적용 완료

(참고)
float* 로 return 하면
 ```
    final calibration  = dylib.lookupFunction<
    Pointer<Float> Function(Int32, Pointer<Pointer<Utf8>>, Pointer<Pointer<Utf8>>),
    Pointer<Float> Function(int, Pointer<Pointer<Utf8>>, Pointer<Pointer<Utf8>>)>('camera_calibrate');
    final floatArray = resultPtr.cast<Float>();
    for (int i = 0; i < 9; i++) {
    final value = floatArray[i];
    print(value);
    }
```
* 넘어온 자료를 가지고 sqlfite에 저장작업 시도

## 2023.09.11
  * 중단되었던 프로젝트를 다시 시작


  * 플러그인 형태로 카메라 캘리브레이트 기능 만들어서 배포
  

  * ios/andorid 모두 지원하고 플로그인 프로젝트로 진행하면서 작성하고 블로그로 작업일지 넘겨서 기록
  
  
  * 이번 플러그인의 작업의도는 카메라 캡쳐된 이미지 또는 파일선택에 의한 이미지든 이미지 목록을 선택하여
    opencv에서 기본적으로 제공하는 카메라 캘리브레이션 소스를 flutter에서 이용할 수 있도록 하는 것이 목표
  

  * 지금 검토해보니까 직접 프로젝트 만들어서 바인딩해서 사용할 때보다 플러그인 형태로 하려면 또 한번의 학습곡선 요구


  * 프로젝트 만들고, xml 설정파일을 추가하도록 안내할 것인가 아니면 클래스로 넘길 것인가?


  * flutter ffi plugin 만들기는 기존에 만든 플로그인과는 프로젝트 생성 명령이 다름.
    -> 출처: https://codelabs.developers.google.com/codelabs/flutter-ffigen?hl=ko


  1) 프로젝트 생성
     -> flutter create --org com.novice --template=plugin_ffi \
     --platforms=android,ios flutter_camera_calibration


  2) opencv camera calibration
     -> 출처: https://docs.opencv.org/4.x/d4/d94/tutorial_camera_calibration.html

  3) opecv 프로젝트에 적용

  4) 이제 소스도 옮겨놓고 했으니 ffi plugin 형태로 분석하고 구성하자(예정)

## 2023.09.23
* 프로젝트 구성 및 라이브러리 cmake 구성 참조: https://github.com/khoren93/flutter_camera_processing

## 2023.09.25
* The argument type 'Pointer<Pointer<Utf8>>' can't be assigned to the parameter type 'Pointer<Pointer<Char>>'.
 => https://stackoverflow.com/questions/72879925/flutter-external-dll-and-pointerchar-vs-pointerutf8
* 플러그인 프로토타입 완료 => 예제 완료 => 기기 테스트중
=> ios linker error => 내일부터 디버깅.

## 2023.09.27
* 디버깅 1번째 ios linker error -> 해결 못함.

## 2023.09.28
* 디버깅 2번째 ios linker error
  struct Camera_Info {
  int rows;
  int cols;
  int length;
  float* array;
  }; 구조체 문제...

* 디버깅 3번째 테스트만 벌써 1시간째 이런게 힘들지. 오늘은 여기까지.

## 2023.09.29
* 오늘은 반대로 안드로이드에서 디버깅 시도-> 일단, 안드로이드에서는 디버깅 성공.
* 다시 IOS에서 디버깅 시도 -> 성공
 ```
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_camera_calibration.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
s.name             = 'flutter_camera_calibration'
s.version          = '0.0.1'
s.summary          = 'A new Flutter FFI plugin project.'
s.description      = <<-DESC

A new Flutter FFI plugin project.
DESC
s.homepage         = 'http://example.com'
s.license          = { :file => '../LICENSE' }
s.author           = { 'Your Company' => 'email@example.com' }

# This will ensure the source files in Classes/ are included in the native
# builds of apps using this FFI plugin. Podspec does not support relative
# paths, so Classes contains a forwarder C file that relatively imports
# `../src/*` so that the C sources can be shared among all target platforms.
s.source           = { :path => '.' }
s.source_files = 'Classes/**/*'
s.dependency 'Flutter'
s.platform = :ios, '12.0'

# Flutter.framework does not contain a i386 slice.
s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
s.swift_version = '5.0'

# telling CocoaPods not to remove framework
    s.preserve_paths = 'opencv2.framework'

# telling linker to include opencv2 framework
s.xcconfig = {
'OTHER_LDFLAGS' => '-framework opencv2 -all_load',  // 이 부분에서 -all_load 추가해서 성공
'CLANG_CXX_LANGUAGE_STANDARD' => 'c++20',
}

# including OpenCV framework
s.vendored_frameworks = 'opencv2.framework'

# flutter_camera_calibration
s.library               = 'c++'

# module_map is needed so this module can be used as a framework
s.module_map = 'flutter_camera_calibration.modulemap'
end
 ```

* 이 플러그인 작업하고 초기 버전만 배포하고 당분간은 dart언어하고 flutter + 파이어베이스로 프로젝트하는것에 집중하자. 
