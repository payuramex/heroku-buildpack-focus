# CMake generated Testfile for 
# Source directory: /app/tmp/opencv/modules/highgui
# Build directory: /app/tmp/opencv/release/modules/highgui
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(opencv_test_highgui "/app/tmp/opencv/release/bin/opencv_test_highgui" "--gtest_output=xml:opencv_test_highgui.xml")
SET_TESTS_PROPERTIES(opencv_test_highgui PROPERTIES  LABELS "Main;opencv_highgui;Accuracy" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/accuracy")
