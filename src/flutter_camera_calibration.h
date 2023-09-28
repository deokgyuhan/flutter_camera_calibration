#ifdef __cplusplus

#include "common.h"
#include "camera_info.h"

extern "C"
{
#endif

    const char *opencvVersion();

    const Camera_InfoPtr camera_calibrate(int argc, char* argv[], char* filelist[]);

#ifdef __cplusplus
}
#endif
