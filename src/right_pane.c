#include <gtk/gtk.h>

GtkWidget *build_right_pane() {
    GtkWidget *right_pane = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);

    // Horizontal bar with fixed height in the right pane
    GtkWidget *horizontal_bar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0);
    gtk_widget_add_css_class(horizontal_bar, "horizontal-bar"); // Add class for CSS styling
    gtk_box_append(GTK_BOX(right_pane), horizontal_bar);

    //
    GtkWidget *right_top_label = gtk_label_new("right top pane");
    gtk_box_append(GTK_BOX(horizontal_bar), right_top_label);

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

    return right_pane;
}