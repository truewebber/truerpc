#include "main_window.h"

// Callback function for the button click event
void on_button_clicked(GtkButton *button, gpointer user_data) {
    g_print("Button clicked!\n");
}

// Function to create the UI
GtkWidget *create_ui() {
    GtkWidget *window;
    GtkWidget *button;
    GtkWidget *box;

    // Create the main window
    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "GTK Example");
    gtk_window_set_default_size(GTK_WINDOW(window), 400, 300);
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    // Create a vertical box layout
    box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
    gtk_container_add(GTK_CONTAINER(window), box);

    // Create a button and add it to the box
    button = gtk_button_new_with_label("Click Me");
    gtk_box_pack_start(GTK_BOX(box), button, TRUE, TRUE, 0);
    g_signal_connect(button, "clicked", G_CALLBACK(on_button_clicked), NULL);

    gtk_widget_show_all(window);

    return window;
}
