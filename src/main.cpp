#include "common.h"

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void Gaussian(char *);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void image_ffi (unsigned char *, unsigned int *);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void canny_detector(char *);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void epipolar(char *, char *);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
IPhone_Camera_Info* camera_calibrate(int, char** , char**);

#include "gaussian.cpp"
#include "image_ffi.cpp"
#include "canny_detector.cpp"
#include "epipolar_geometry.cpp"
#include "camera_calibrate.cpp"
