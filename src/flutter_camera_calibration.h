#ifdef __cplusplus

#include "common.h"
//#include "camera_info.h"

extern "C"
{
#endif
struct Camera_Info {
    int rows;
    int cols;
    int length;
    float* array;
};

typedef Camera_Info* Camera_InfoPtr;

    const char *opencvVersion();

    const Camera_InfoPtr camera_calibrate(int argc, char* argv[], char* filelist[]);

#ifdef __cplusplus
}
#endif
