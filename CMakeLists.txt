cmake_minimum_required(VERSION 3.24)
project(truerpc)

set(CMAKE_CXX_STANDARD 20)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTKMM gtkmm-3.0)

include_directories(include ${GTKMM_INCLUDE_DIRS})
link_directories(${GTKMM_LIBRARY_DIRS})
add_definitions(${GTKMM_CFLAGS_OTHER})

add_executable(truerpc src/main.cpp src/main_window.cpp)
target_link_libraries(truerpc ${GTKMM_LIBRARIES})
