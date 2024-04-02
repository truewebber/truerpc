#include <gtk/gtk.h>

void close_dialog(GtkWidget *widget) {
    gtk_window_close(GTK_WINDOW(widget));
}


void open_modal_dialog(GtkWidget *parent) {
    GtkWidget *dialog = gtk_window_new();

    gtk_window_set_decorated(GTK_WINDOW(dialog), false);
    gtk_window_set_modal(GTK_WINDOW(dialog), true);
    gtk_window_set_resizable(GTK_WINDOW(dialog), false);
    gtk_window_set_transient_for(GTK_WINDOW(dialog), GTK_WINDOW(parent));

    // Create a container for the dialog's content
    GtkWidget *box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0);
    gtk_window_set_child(GTK_WINDOW(dialog), box);

    // Create a close button
    GtkWidget *close_button = gtk_button_new_with_label("Close");
    g_signal_connect_swapped(close_button, "clicked", G_CALLBACK(close_dialog), dialog);
    gtk_box_append(GTK_BOX(box), close_button); // Add the button to the dialog's container box
    gtk_window_set_default_size(GTK_WINDOW(dialog), 200, 100); // Set a default size for the dialog

    gtk_window_present(GTK_WINDOW(dialog));
}

GtkWidget *build_left_pane(GtkWindow *parent_window) {
    GtkWidget *left_widget = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0);
    gtk_widget_set_hexpand(left_widget, TRUE); // Ensure the box expands horizontally

    // Create a box to take up the remaining space
    GtkWidget *spacer = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0);
    gtk_widget_add_css_class(spacer, "proto_container"); // Add class for CSS styling
    gtk_widget_set_vexpand(spacer, TRUE); // Make it expand vertically
    gtk_widget_set_hexpand(spacer, TRUE); // Expand horizontally to fill the space

    // Button at the bottom
    GtkWidget *button = gtk_button_new_with_label("+ new proto");
    gtk_widget_add_css_class(button, "add_new_proto"); // Add class for CSS styling
    gtk_widget_set_hexpand(button, TRUE); // Make the button expand to match the width of the left_widget
    gtk_widget_set_valign(button, GTK_ALIGN_END); // Align the button to the bottom

    // Connect the button's clicked signal to the handler
    g_signal_connect_swapped(button, "clicked", G_CALLBACK(open_modal_dialog), parent_window);

    // Add the spacer and button to the left_widget box
    gtk_box_append(GTK_BOX(left_widget), spacer); // This box takes all available space and pushes the button to the bottom
    gtk_box_append(GTK_BOX(left_widget), button);

    // CSS for styling
    const gchar *css =
            "box.proto_container {"
            "  background-color: #D3D3D3;" // Make the spacer box grey
            "}"
            "button.add_new_proto {"
            "  border-radius: 0px;"
            "  margin: 0px;"
            "}";

    GtkCssProvider *css_provider = gtk_css_provider_new();
    gtk_css_provider_load_from_string(css_provider, css);
    gtk_style_context_add_provider_for_display(gdk_display_get_default(),
                                               GTK_STYLE_PROVIDER(css_provider),
                                               GTK_STYLE_PROVIDER_PRIORITY_USER);

    return left_widget;
}
