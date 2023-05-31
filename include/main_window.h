#ifndef MY_WINDOW_H
#define MY_WINDOW_H

#include <gtkmm.h>

class MyWindow : public Gtk::Window
{
public:
    MyWindow();
    virtual ~MyWindow();

private:
    void on_button_clicked();

    Gtk::Button m_button;
};

#endif
