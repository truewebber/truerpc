#include <gtk/gtk.h>
#include <left_pane.h>
#include <right_pane.h>

const int window_initial_width = 900;
const int window_initial_height = 600;
const int left_pane_width = window_initial_width / 4;

GtkWidget *get_main_window(GtkApplication *app) {
    GtkWidget *window;
    GtkWidget *hpaned;

    // Create a new window
    window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "Vertical Paned Window");
    gtk_window_set_default_size(GTK_WINDOW(window), window_initial_width, window_initial_height);

    // Create a horizontal box to act as a paned container
    hpaned = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL);
    gtk_window_set_child(GTK_WINDOW(window), hpaned);

    GtkWidget *left_pane = build_left_pane();
    gtk_paned_set_start_child(GTK_PANED(hpaned), left_pane);
    gtk_paned_set_position(GTK_PANED(hpaned), left_pane_width);

    GtkWidget *right_pane = build_right_pane();
    gtk_paned_set_end_child(GTK_PANED(hpaned), right_pane);

    return window;
}