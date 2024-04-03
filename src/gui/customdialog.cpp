#include "customdialog.h"
#include <QLabel>
#include <QVBoxLayout>

CustomDialog::CustomDialog(QWidget *parent) : QDialog(parent) {
    auto layout = new QVBoxLayout(this);
    auto label = new QLabel("This is a modal dialog", this);
    layout->addWidget(label);
    setLayout(layout);
}

CustomDialog::~CustomDialog() = default;
