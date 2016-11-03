# CMake generated Testfile for 
# Source directory: /app/tmp/opencv/modules/shape
# Build directory: /app/tmp/opencv/release/modules/shape
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(opencv_test_shape "/app/tmp/opencv/release/bin/opencv_test_shape" "--gtest_output=xml:opencv_test_shape.xml")
SET_TESTS_PROPERTIES(opencv_test_shape PROPERTIES  LABELS "Main;opencv_shape;Accuracy" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/accuracy")
