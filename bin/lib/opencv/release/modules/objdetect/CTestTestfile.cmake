# CMake generated Testfile for 
# Source directory: /app/tmp/opencv/modules/objdetect
# Build directory: /app/tmp/opencv/release/modules/objdetect
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(opencv_test_objdetect "/app/tmp/opencv/release/bin/opencv_test_objdetect" "--gtest_output=xml:opencv_test_objdetect.xml")
SET_TESTS_PROPERTIES(opencv_test_objdetect PROPERTIES  LABELS "Main;opencv_objdetect;Accuracy" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/accuracy")
ADD_TEST(opencv_perf_objdetect "/app/tmp/opencv/release/bin/opencv_perf_objdetect" "--gtest_output=xml:opencv_perf_objdetect.xml")
SET_TESTS_PROPERTIES(opencv_perf_objdetect PROPERTIES  LABELS "Main;opencv_objdetect;Performance" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/performance")
ADD_TEST(opencv_sanity_objdetect "/app/tmp/opencv/release/bin/opencv_perf_objdetect" "--gtest_output=xml:opencv_perf_objdetect.xml" "--perf_min_samples=1" "--perf_force_samples=1" "--perf_verify_sanity")
SET_TESTS_PROPERTIES(opencv_sanity_objdetect PROPERTIES  LABELS "Main;opencv_objdetect;Sanity" WORKING_DIRECTORY "/app/tmp/opencv/release/test-reports/sanity")
