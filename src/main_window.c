#include <gtk/gtk.h>

const int window_initial_width = 600;
const int window_initial_height = 400;
const int left_pane_width = window_initial_width / 4;

GtkWidget* get_main_window(GtkApplication *app) {
    GtkWidget *window;
    GtkWidget *hpaned;
    GtkWidget *left_widget;
    GtkWidget *right_pane;

    // Create a new window
    window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "Vertical Paned Window");
    gtk_window_set_default_size(GTK_WINDOW(window), window_initial_width, window_initial_height);

    // Create a horizontal box to act as a paned container
    hpaned = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL);
    gtk_window_set_child(GTK_WINDOW(window), hpaned);

    // Left pane
    left_widget = gtk_label_new("Left Pane");
    gtk_paned_set_start_child(GTK_PANED(hpaned), left_widget);
    gtk_paned_set_position(GTK_PANED(hpaned), left_pane_width);

    // Right pane
    right_pane = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);
    gtk_paned_set_end_child(GTK_PANED(hpaned), right_pane);

    // Horizontal bar with fixed height in the right pane
    GtkWidget *horizontal_bar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0);
    gtk_box_append(GTK_BOX(right_pane), horizontal_bar);
    //
    GtkWidget *right_top_label = gtk_label_new("right top pane");
    gtk_box_append(GTK_BOX(horizontal_bar), right_top_label);

    return window;
}