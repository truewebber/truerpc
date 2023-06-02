#include <gtk/gtk.h>
#include "main_window.h"

int main(int argc, char *argv[]) {
    GtkWidget *window;

    gtk_init(&argc, &argv);

    window = create_ui();

    gtk_main();

    return 0;
}
