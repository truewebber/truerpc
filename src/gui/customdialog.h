#ifndef TRUERPC_CUSTOMDIALOG_H
#define TRUERPC_CUSTOMDIALOG_H

#include <QDialog>

class CustomDialog : public QDialog {
Q_OBJECT

public:
    explicit CustomDialog(QWidget *parent = nullptr);

    ~CustomDialog() override;
};

#endif //TRUERPC_CUSTOMDIALOG_H
