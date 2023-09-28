#ifndef CAMERA_INFO_DEFINED
#define CAMERA_INFO_DEFINED

struct Camera_Info {
    int rows;
    int cols;
    int length;
    float* array;
};

typedef Camera_Info* Camera_InfoPtr;

#endif // CAMERA_INFO_DEFINED
