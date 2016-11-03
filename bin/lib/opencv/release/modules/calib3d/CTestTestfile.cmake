# CMake generated Testfile for 
# Source directory: /app/tmp/opencv/modules/calib3d
# Build directory: /app/tmp/opencv/release/modules/calib3d
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(opencv_test_calib3d "/app/tmp/opencv/release/bin/opencv_test_calib3d" "--gtest_output=xml:opencv_test_calib3d.xml")
SET_TESTS_PROPERTIES(opencv_test_calib3d PROPERTIES  LABELS "Main;opencv_calib3d;Accuracy" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/accuracy")
ADD_TEST(opencv_perf_calib3d "/app/tmp/opencv/release/bin/opencv_perf_calib3d" "--gtest_output=xml:opencv_perf_calib3d.xml")
SET_TESTS_PROPERTIES(opencv_perf_calib3d PROPERTIES  LABELS "Main;opencv_calib3d;Performance" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/performance")
ADD_TEST(opencv_sanity_calib3d "/app/tmp/opencv/release/bin/opencv_perf_calib3d" "--gtest_output=xml:opencv_perf_calib3d.xml" "--perf_min_samples=1" "--perf_force_samples=1" "--perf_verify_sanity")
SET_TESTS_PROPERTIES(opencv_sanity_calib3d PROPERTIES  LABELS "Main;opencv_calib3d;Sanity" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/sanity")
