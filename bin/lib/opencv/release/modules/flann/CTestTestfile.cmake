# CMake generated Testfile for 
# Source directory: /app/tmp/opencv/modules/flann
# Build directory: /app/tmp/opencv/release/modules/flann
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(opencv_test_flann "/app/tmp/opencv/release/bin/opencv_test_flann" "--gtest_output=xml:opencv_test_flann.xml")
SET_TESTS_PROPERTIES(opencv_test_flann PROPERTIES  LABELS "Main;opencv_flann;Accuracy" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/accuracy")
