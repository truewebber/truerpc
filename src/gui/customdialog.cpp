#include "customdialog.h"
#include <QLabel>
#include <QVBoxLayout>

CustomDialog::CustomDialog(QWidget *parent) : QDialog(parent) {
    QVBoxLayout* layout = new QVBoxLayout(this);
    QLabel* label = new QLabel("This is a modal dialog", this);
    layout->addWidget(label);
    setLayout(layout);
}

CustomDialog::~CustomDialog() = default;
