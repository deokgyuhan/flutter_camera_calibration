#include "common.h"

#ifdef __cplusplus
extern "C"
{
#endif

    const char *opencvVersion();

    struct Camera_Info* camera_calibrate(int argc, char* argv[], char* filelist[]);

#ifdef __cplusplus
}
#endif
