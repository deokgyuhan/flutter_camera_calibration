# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(flutter_camera_calibration_library VERSION 0.0.1 LANGUAGES C)

add_library(flutter_camera_calibration SHARED
  "flutter_camera_calibration.c"
)

set_target_properties(flutter_camera_calibration PROPERTIES
  PUBLIC_HEADER flutter_camera_calibration.h
  OUTPUT_NAME "flutter_camera_calibration"
)

target_compile_definitions(flutter_camera_calibration PUBLIC DART_SHARED_LIB)
