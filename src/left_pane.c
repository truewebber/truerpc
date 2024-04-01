#include <gtk/gtk.h>

void print_hello(GtkWidget *widget, gpointer data) {
    g_print("left pane's button clicked\n");
}

GtkWidget *build_left_pane() {
    GtkWidget *left_widget = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0);
    gtk_widget_set_halign(left_widget, GTK_ALIGN_CENTER);
    gtk_widget_set_valign(left_widget, GTK_ALIGN_CENTER);

    GtkWidget *button = gtk_button_new_with_label("Hello World");

    g_signal_connect(button, "clicked", G_CALLBACK(print_hello), NULL);

    gtk_box_append(GTK_BOX(left_widget), button);

    // CSS
    const gchar *css =
            "box.horizontal-bar {"
            "  min-height: 50px;"
            "  border-width: 0 0 1px 0;"
            "  border-color: #CDC7C2;"
            "  border-style: solid;"
            "}";

    GtkCssProvider *css_provider = gtk_css_provider_new();
    gtk_css_provider_load_from_string(css_provider, css);
    gtk_style_context_add_provider_for_display(gdk_display_get_default(),
                                               GTK_STYLE_PROVIDER(css_provider),
                                               GTK_STYLE_PROVIDER_PRIORITY_USER);

    return left_widget;
}