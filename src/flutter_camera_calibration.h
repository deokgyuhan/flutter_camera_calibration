#ifdef __cplusplus

#include "common.h"
#include "camera_info.h"

extern "C"
{
#endif

    const char *opencvVersion();

    Camera_Info* camera_calibrate(int argc, char* argv[], char* filelist[]);

#ifdef __cplusplus
}
#endif
