#include <gtk/gtk.h>

const char bundle_name[] = "com.truewebber.truerpc";
const int window_initial_width = 600;
const int window_initial_height = 400;
const int left_pane_width = window_initial_width / 4;

void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window;
    GtkWidget *hpaned;
    GtkWidget *left_widget;
    GtkWidget *right_widget;

    // Create a new window
    window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "Vertical Paned Window");
    gtk_window_set_default_size(GTK_WINDOW(window), window_initial_width, window_initial_height);

    // Create a horizontal box to act as a paned container
    hpaned = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL);
    gtk_window_set_child(GTK_WINDOW(window), hpaned);

    // Create two child widgets for the panes
    left_widget = gtk_label_new("Left Pane");
    right_widget = gtk_label_new("Right Pane");

    // Add children to the horizontal box
    // Note: You might want to wrap these widgets or use custom containers to control their sizes more precisely.
    gtk_paned_set_start_child(GTK_PANED(hpaned), left_widget);
    gtk_paned_set_end_child(GTK_PANED(hpaned), right_widget);

    gtk_paned_set_position(GTK_PANED(hpaned), left_pane_width);

    // Show the window.
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
