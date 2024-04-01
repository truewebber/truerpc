cmake_minimum_required(VERSION 3.24)

set(PROJECT_NAME TrueRPC)
set(BINARY_NAME truerpc)

project(${PROJECT_NAME} VERSION 1.0 LANGUAGES C)

# Specify C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED True)

# Find packages
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK4 REQUIRED IMPORTED_TARGET gtk4)
find_package(Protobuf REQUIRED)
find_package(gRPC REQUIRED)

# Include directories
include_directories(include ${GTK4_INCLUDE_DIRS})

# Source files
set(SOURCES
        src/main.c
        src/grpc_client.c
        src/proto_parser.c
        src/main_window.c
        src/quit.c
        src/left_pane.c
        src/right_pane.c
)

# Target executable
add_executable(${BINARY_NAME} ${SOURCES})

# Link libraries
target_link_libraries(${BINARY_NAME} PRIVATE
        PkgConfig::GTK4
        gRPC::grpc++_reflection
        gRPC::grpc++
)

if (APPLE)
    set(TrueRPC_DISPLAY_NAME TrueRPC)
    set(MACOSX_FRAMEWORK_IDENTIFIER com.truewebber.truerpc)
    set(TrueRPC_VERSION_MAJOR 0)
    set(TrueRPC_VERSION_MINOR 1)
    set(TrueRPC_VERSION_PATCH 0)
    set(TrueRPC_VERSION "${TrueRPC_VERSION_MAJOR}.${TrueRPC_VERSION_MINOR}.${TrueRPC_VERSION_PATCH}")

    # Pack MacOS bundle
    set_target_properties(${BINARY_NAME} PROPERTIES
            MACOSX_BUNDLE TRUE
            MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist.in
    )

    set(SOURCE_ICON "${CMAKE_CURRENT_SOURCE_DIR}/static/icon.tiff")
    set(DEST_DIR "${CMAKE_CURRENT_BINARY_DIR}/${BINARY_NAME}.app/Contents/Resources")

    add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory ${DEST_DIR}
            COMMAND ${CMAKE_COMMAND} -E copy ${SOURCE_ICON} ${DEST_DIR}
            COMMENT "Copying resources to bundle"
    )
endif ()