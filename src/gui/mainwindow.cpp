#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QSplitter>
#include <QWidget>
#include <QPushButton>
#include <QVBoxLayout>
#include <QDialog>
#include <QLabel>

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent), ui(new Ui::MainWindow) {
    ui->setupUi(this);

    // Create a horizontal splitter widget to hold two text edit widgets
    auto splitter = new QSplitter(Qt::Horizontal, this);

    splitter->setStyleSheet(R"(
    QSplitter::handle {
        background-color: #cfcfcf; /* Light grey background */
        border: 1px solid #b1b1b1; /* Slightly darker border for some depth */
        width: 1px;
    }

    QSplitter::handle:hover {
        background-color: #aaaaaa; /* Darker grey when hovered */
    }

    QSplitter::handle:vertical {
        height: 1px; /* Vertical handle height */
    }
)");

    // Create the left widget (red) and a layout for its contents
    auto leftWidget = new QWidget();
    auto leftLayout = new QVBoxLayout(leftWidget);
//    leftWidget->setStyleSheet("background-color: red;");

    // Create the top box for the left widget and set its background
    auto topBox = new QWidget();
    topBox->setStyleSheet("background-color: lightgrey;margin:0;"); // Use any color you prefer

    // Create the button to be placed at the bottom of the left widget
    auto button = new QPushButton("Click Me");
    button->setStyleSheet("background-color: pink;margin:0;");

    // Add the top box and button to the layout, with the top box expanding to fill the space
    leftLayout->addWidget(topBox, 1); // The '1' ensures the top box expands
    leftLayout->addWidget(button);
    leftLayout->setSpacing(0);

    // Connect the button's clicked signal to open the modal dialog
    connect(button, &QPushButton::clicked, this, [this]() {
        // Use a custom dialog if you've defined one
        // CustomDialog* dialog = new CustomDialog(this);
        auto dialog = new QDialog(this, Qt::FramelessWindowHint | Qt::WindowSystemMenuHint);
        dialog->setWindowTitle("Modal Dialog");
        dialog->setModal(true);
        dialog->setFixedSize(300,200);

        auto layout = new QVBoxLayout(dialog);
        auto label = new QLabel("This is a modal dialog", dialog);
        layout->addWidget(label);
        dialog->setLayout(layout);

        dialog->exec(); // This will block until the dialog is closed
    });

    // Ensure the layout doesn't allow for any unnecessary space around its edges
    leftLayout->setContentsMargins(0, 0, 0, 0);

    // Create the second widget and set its background to blue
    auto blueWidget = new QWidget();
    blueWidget->setStyleSheet("background-color: blue;");

    // Add the widgets to the splitter
    splitter->addWidget(leftWidget);
    splitter->addWidget(blueWidget);

    // Set the splitter as the central widget of the main window
    setCentralWidget(splitter);
}

MainWindow::~MainWindow() {
    delete ui;
}
