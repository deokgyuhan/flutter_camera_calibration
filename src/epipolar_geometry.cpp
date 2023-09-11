#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>
#include <opencv2/features2d.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/calib3d.hpp>

using namespace cv;
using namespace std;

cv::Mat drawlines(cv::Mat img1, cv::Mat img2, std::vector<cv::Vec3f> lines, std::vector<cv::Point2f> pts1, std::vector<cv::Point2f> pts2) {
//    CV_Assert(img1.channels() == 1 && img2.channels() == 1);  // Grayscale images

    int r = img1.rows;
    int c = img1.cols;

    cv::cvtColor(img1, img1, cv::COLOR_GRAY2BGR);
    cv::cvtColor(img2, img2, cv::COLOR_GRAY2BGR);

    for (size_t i = 0; i < lines.size(); ++i) {
        cv::Vec3f r = lines[i];
        cv::Scalar color = cv::Scalar(rand() % 256, rand() % 256, rand() % 256);

        int x0 = 0;
        int y0 = static_cast<int>(-r[2] / r[1]);
        int x1 = c;
        int y1 = static_cast<int>(-(r[2] + r[0] * c) / r[1]);

        cv::line(img1, cv::Point(x0, y0), cv::Point(x1, y1), color, 1);
        cv::circle(img1, pts1[i], 5, color, -1);
        cv::circle(img2, pts2[i], 5, color, -1);
    }

    std::cout << "2023.06.24.===========>drawLine: " << lines.size() << endl;

    return img1;
}

void epipolar(char *path1, char *path2) {

  std::cout << "2023.06.24.===========>image1: " << path1 << endl;
  std::cout << "2023.06.24.===========>image2: " << path1 << endl;

  cv::Mat img1, img2;

  cv::Mat _img1 = cv::imread(path1, cv::IMREAD_GRAYSCALE); // left image
  cv::resize(_img1, img1, cv::Size(), 0.5, 0.5);

  cv::Mat _img2 = cv::imread(path2, cv::IMREAD_GRAYSCALE); // right image
  cv::resize(_img2, img2, cv::Size(), 0.5, 0.5);

  cv::Ptr<SIFT> sift = cv::SIFT::create();
  //keypoints 벡터
  vector<KeyPoint> kp1, kp2;

  //이미지 2장에 대한 descriptor 헹렬
  cv::Mat des1, des2;

  sift->detectAndCompute(img1, cv::Mat(), kp1, des1);
  sift->detectAndCompute(img2, cv::Mat(), kp2, des2);

    //FLANN parameter
    const static auto indexParams = new cv::flann::IndexParams();
    indexParams->setAlgorithm(cvflann::FLANN_INDEX_KDTREE);
    indexParams->setInt("trees", 5);

    const static auto searchParams = new cv::flann::SearchParams();
    searchParams->setInt("checks", 20);

    // cv::FlannBasedMatcher flann;
    const static auto flann = FlannBasedMatcher(indexParams, searchParams);

    vector<vector<cv::DMatch>> matches;

    /*
     - flann.knnMatch(des1, des2, matches, k)`에서 마지막 파라미터인 `k`는 최근접 이웃의 개수를 지정하는 매개변수
     - FLANN 기반 매처인 `cv::FlannBasedMatcher`의 `knnMatch` 함수는 각 쿼리 특징점에 대해 가장 가까운 `k`개의 이웃을 찾아 매칭 결과로 반환
     - 즉, `knnMatch` 함수는 `des1`과 `des2` 간의 특징점 매칭을 수행하고, 각 쿼리 특징점에 대해 최근접한 `k`개의 이웃을 찾아 `matches` 벡터에 저장
     - `matches` 벡터의 각 원소는 `std::vector<cv::DMatch>` 형태로 구성되어 있으며, 해당 쿼리 특징점과 최근접한 이웃들의 매칭 정보를 포함
     - 따라서 `flann.knnMatch(des1, des2, matches, 2)`는 `des1`과 `des2` 사이의 특징점 매칭을 수행하고,
       각 쿼리 특징점에 대해 최근접한 2개의 이웃을 찾아 `matches`에 저장하는 것을 의미
    */
    flann.knnMatch(des1, des2, matches, 2);

    vector<Point2f> pts1, pts2;
    float ratio_threshold = 0.8f;

    for(size_t i = 0; i <matches.size(); i++) {
        if(matches[i][0].distance < ratio_threshold * matches[i][1].distance) {
            pts2.push_back(kp2[matches[i][0].trainIdx].pt);
            pts1.push_back(kp1[matches[i][0].queryIdx].pt);
        }
    }
    Mat F, mask;
    F = findFundamentalMat(pts1, pts2, FM_LMEDS, 3.0, 0.99, mask);


    vector<cv::Vec3f> lines1, lines2;
    computeCorrespondEpilines(pts2, 2, F, lines1);
    computeCorrespondEpilines(pts1, 1, F, lines2);

    std::cout << "2023.06.24.===========>pts1.size: " << pts1.size() << endl;

    cv::Mat img5 = drawlines(img1, img2, lines1, pts1, pts2);
    cv::Mat img3 = drawlines(img2, img1, lines2, pts2, pts1);

    cv::imwrite(path1, img5);
    cv::imwrite(path2, img3);

    std::cout << "2023.06.24.===========>end " << endl;
}
