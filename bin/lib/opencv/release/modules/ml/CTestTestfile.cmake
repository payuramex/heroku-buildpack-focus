# CMake generated Testfile for 
# Source directory: /app/tmp/opencv/modules/ml
# Build directory: /app/tmp/opencv/release/modules/ml
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(opencv_test_ml "/app/tmp/opencv/release/bin/opencv_test_ml" "--gtest_output=xml:opencv_test_ml.xml")
SET_TESTS_PROPERTIES(opencv_test_ml PROPERTIES  LABELS "Main;opencv_ml;Accuracy" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/accuracy")
