cmake_minimum_required(VERSION 3.22)

project(truerpc)

# Find the necessary Qt packages
find_package(Qt6 REQUIRED COMPONENTS Widgets)

# If you have resources, ensure they're processed
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)

# Include the source directory
add_subdirectory(src)

target_link_libraries(${PROJECT_NAME} Qt6::Widgets)
