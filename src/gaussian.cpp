//#include <opencv2/opencv.hpp>
//
//using namespace cv;
//
//void Gaussian(char *path) {
//    Mat img = imread(path);
//    Mat temp;
//    GaussianBlur(img, temp, Size(75, 75), 0, 0);
//    imwrite(path, temp);
//}

//#include <Accelerate/Accelerate.h>
//#include <iostream>
//
//double vectorvector_product(double * a, double * b, int dim){
//    // This function returns in res the elementwiseproduct between a and b,
//    // a and b must have the same dimension dim.
//    return cblas_ddot(dim,a,1,b,1);
//}
//
//void Gaussian(char *path){
//        double a[4] = {1.0,2.0,3.0,4.0};
//        double b[4] = {1.0,2.0,3.0,4.0};
//        double res = vectorvector_product(a,b,4);
//
//        std::cout << res << std::endl;
//}

#include <iostream>
#include <Accelerate/Accelerate.h>

void Gaussian(char *path) {
    float z[] = {-3, 4, 5, -7}; // -3 + 4i, 5 - 7i
    float sum = cblas_scasum(4, z, 1);
    std::cout << "Sum of absolute values: " << sum << std::endl;

    float a[] = {1, 2, 3, 4}; // [ 1 + 2i,  3 + 4i ]
    float b[] = {1, -2, -3, 4}; // [ 1 - 2i, -3 + 4i ]
    float alpha = 1.0f;
    cblas_caxpy(2, &alpha, a, 1, b, 1);
    std::cout << "Result: " << b[0] << " + " << b[1] << "i, " << b[2] << " + " << b[3] << "i" << std::endl;

    struct Complex {
        float real;
        float imag;
    };

    Complex c[] = { {1, 2}, {3, 4} };
    Complex d[] = { {1, -2}, {-3, 4} };
    cblas_caxpy(2, &alpha, reinterpret_cast<float*>(c), 1, reinterpret_cast<float*>(d), 1);
    for (int i = 0; i < 2; i++) {
        std::cout << "Result: " << d[i].real << " + " << d[i].imag << "i" << std::endl;
    }

    Complex e[] = { {1, 2}, {3, 4} };
    Complex f[] = { {1, -2}, {-3, 4} };
    cblas_caxpy(2, &alpha, reinterpret_cast<float*>(e), 1, reinterpret_cast<float*>(f), 1);
    for (int i = 0; i < 2; i++) {
        std::cout << "Result: " << f[i].real << " + " << f[i].imag << "i" << std::endl;
    }

    Complex g[] = { {1, 2}, {3, 4} };
    Complex h[] = { {1, -2}, {-3, 4} };
    Complex gDotH = { 0, 0 };
    cblas_cdotu_sub(2, reinterpret_cast<float*>(g), 1, reinterpret_cast<float*>(h), 1, reinterpret_cast<float*>(&gDotH));
    std::cout << "Dot product: " << gDotH.real << " + " << gDotH.imag << "i" << std::endl;
}
