#include "main_window.h"

MyWindow::MyWindow()
        : m_button("Click Me")
{
    set_title("GTK Example");
    set_default_size(400, 300);

    m_button.signal_clicked().connect(sigc::mem_fun(*this, &MyWindow::on_button_clicked));
    add(m_button);

    show_all();
}

MyWindow::~MyWindow()
{
}

void MyWindow::on_button_clicked()
{
    std::cout << "Button clicked!" << std::endl;
}
