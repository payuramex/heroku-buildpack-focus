# CMake generated Testfile for 
# Source directory: /app/tmp/opencv/modules/imgcodecs
# Build directory: /app/tmp/opencv/release/modules/imgcodecs
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(opencv_test_imgcodecs "/app/tmp/opencv/release/bin/opencv_test_imgcodecs" "--gtest_output=xml:opencv_test_imgcodecs.xml")
SET_TESTS_PROPERTIES(opencv_test_imgcodecs PROPERTIES  LABELS "Main;opencv_imgcodecs;Accuracy" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/accuracy")
ADD_TEST(opencv_perf_imgcodecs "/app/tmp/opencv/release/bin/opencv_perf_imgcodecs" "--gtest_output=xml:opencv_perf_imgcodecs.xml")
SET_TESTS_PROPERTIES(opencv_perf_imgcodecs PROPERTIES  LABELS "Main;opencv_imgcodecs;Performance" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/performance")
ADD_TEST(opencv_sanity_imgcodecs "/app/tmp/opencv/release/bin/opencv_perf_imgcodecs" "--gtest_output=xml:opencv_perf_imgcodecs.xml" "--perf_min_samples=1" "--perf_force_samples=1" "--perf_verify_sanity")
SET_TESTS_PROPERTIES(opencv_sanity_imgcodecs PROPERTIES  LABELS "Main;opencv_imgcodecs;Sanity" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/sanity")
