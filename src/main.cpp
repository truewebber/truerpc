#include <gtkmm/application.h>
#include "main_window.h"

int main(int argc, char* argv[])
{
    auto app = Gtk::Application::create(argc, argv, "com.truewebber.truerpc");

    MyWindow window;

    return app->run(window);
}
