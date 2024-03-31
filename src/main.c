#include <gtk/gtk.h>
#include <main_window.h>

const char bundle_name[] = "com.truewebber.truerpc";

void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window = get_main_window(app);

    gtk_widget_set_visible(window, true);
}

int main(int argc, char *argv[]) {
    // Initialize GTK.
    gtk_init();

    // Create a new application.
    GtkApplication *app = gtk_application_new(bundle_name, G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);

    // Run the application.
    int status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);

    return status;
}
