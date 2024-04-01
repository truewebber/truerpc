#include <gtk/gtk.h>

#ifdef __APPLE__
gboolean macos_quit_event_handler(GtkEventControllerKey *controller, guint keyval,
                            guint keycode, GdkModifierType state, gpointer user_data) {
    if ((state & GDK_META_MASK) != 0 && keyval == GDK_KEY_q) {
        g_application_quit(G_APPLICATION(user_data));
        return TRUE;
    }
    return FALSE;
}
#endif

void handle_quit_shortcut_event(GtkApplication *app, GtkWidget *window) {
    GtkEventControllerKey *key_controller = GTK_EVENT_CONTROLLER_KEY(gtk_event_controller_key_new());

#ifdef __APPLE__
    g_signal_connect(key_controller, "key-pressed", G_CALLBACK(macos_quit_event_handler), app);
#elif __linux__
    // do nothing
#endif

    gtk_widget_add_controller(GTK_WIDGET(window), GTK_EVENT_CONTROLLER(key_controller));
}