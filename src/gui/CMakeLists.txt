set(GUI_SOURCES
        mainwindow.cpp
        mainwindow.h
        mainwindow.ui
        customdialog.cpp
        customdialog.h
        customdialog.ui
)

# Include this directory in the parent scope
target_sources(${PROJECT_NAME} PRIVATE ${GUI_SOURCES})
