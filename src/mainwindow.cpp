#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include <QSplitter>
#include <QTextEdit>

MainWindow::MainWindow(QWidget *parent)
        : QMainWindow(parent)
        , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    // Create a horizontal splitter widget to hold two text edit widgets
    QSplitter* splitter = new QSplitter(Qt::Horizontal, this);

    // Create the first text edit widget
    QTextEdit* textEdit1 = new QTextEdit();
    textEdit1->setPlainText("Column 1: You can type here...");

    // Create the second text edit widget
    QTextEdit* textEdit2 = new QTextEdit();
    textEdit2->setPlainText("Column 2: You can also type here...");

    // Add the text edit widgets to the splitter
    splitter->addWidget(textEdit1);
    splitter->addWidget(textEdit2);

    // Set the splitter as the central widget of the main window
    setCentralWidget(splitter);
}

MainWindow::~MainWindow()
{
    delete ui;
}
