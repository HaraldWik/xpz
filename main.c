#include <xcb/xcb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    // 1) Connect
    xcb_connection_t *conn = xcb_connect(NULL, NULL);
    if (xcb_connection_has_error(conn)) {
        fprintf(stderr, "ERROR: Cannot open X connection\n");
        return 1;
    }

    // 2) Get the first screen
    const xcb_setup_t *setup = xcb_get_setup(conn);
    xcb_screen_iterator_t iter = xcb_setup_roots_iterator(setup);
    xcb_screen_t *screen = iter.data;

    // 3) Create a window
    xcb_window_t win = xcb_generate_id(conn);
    uint32_t mask = XCB_CW_BACK_PIXEL | XCB_CW_EVENT_MASK;
    uint32_t values[2] = {
        screen->black_pixel,
        XCB_EVENT_MASK_EXPOSURE | XCB_EVENT_MASK_KEY_PRESS
    };

    xcb_create_window(
        conn,
        XCB_COPY_FROM_PARENT,
        win,
        screen->root,
        0, 0, 400, 200, 0,
        XCB_WINDOW_CLASS_INPUT_OUTPUT,
        screen->root_visual,
        mask, values
    );

    // 4) Set window title (WM_NAME)
    const char *title = "XCB Demo — Press Keys";
    // xcb_change_property(
    //     conn,
    //     XCB_PROP_MODE_REPLACE,
    //     win,
    //     XCB_ATOM_WM_NAME,
    //     XCB_ATOM_STRING,
    //     8,
    //     strlen(title),
    //     title
    // );

    // Also set _NET_WM_NAME (UTF-8)
    xcb_intern_atom_cookie_t net_name_cookie = xcb_intern_atom(conn, 0,
        strlen("_NET_WM_NAME"), "_NET_WM_NAME");
    xcb_intern_atom_cookie_t utf8_cookie = xcb_intern_atom(conn, 0,
        strlen("UTF8_STRING"), "UTF8_STRING");

    xcb_intern_atom_reply_t *net_name_reply =
        xcb_intern_atom_reply(conn, net_name_cookie, NULL);
    xcb_intern_atom_reply_t *utf8_reply =
        xcb_intern_atom_reply(conn, utf8_cookie, NULL);

    printf("net_name: cookie: %d, value: %d\n", net_name_cookie.sequence, net_name_reply->atom);
    printf("UTF8_STRING: cookie: %d, value: %d\n", utf8_cookie.sequence, utf8_reply->atom);

    if (net_name_reply && utf8_reply) {
        xcb_change_property(
            conn,
            XCB_PROP_MODE_REPLACE,
            win,
            net_name_reply->atom,
            utf8_reply->atom,
            8,
            strlen(title),
            title
        );
    }

    free(net_name_reply);
    free(utf8_reply);

    // 5) Setup WM_DELETE_WINDOW
    xcb_intern_atom_cookie_t protocols_cookie =
        xcb_intern_atom(conn, 0, strlen("WM_PROTOCOLS"), "WM_PROTOCOLS");
    xcb_intern_atom_cookie_t delete_cookie =
        xcb_intern_atom(conn, 0, strlen("WM_DELETE_WINDOW"), "WM_DELETE_WINDOW");

    xcb_intern_atom_reply_t *protocols_reply =
        xcb_intern_atom_reply(conn, protocols_cookie, NULL);
    xcb_intern_atom_reply_t *delete_reply =
        xcb_intern_atom_reply(conn, delete_cookie, NULL);

    if (protocols_reply && delete_reply) {
        xcb_change_property(
            conn,
            XCB_PROP_MODE_REPLACE,
            win,
            protocols_reply->atom,
            XCB_ATOM_ATOM,
            32,
            1,
            &delete_reply->atom
        );
    }

    free(protocols_reply);
    free(delete_reply);

    // 6) Map the window
    xcb_map_window(conn, win);
    xcb_flush(conn);

    printf("Window created. Press keys…\n");

    // 7) Send a synthetic ConfigureNotify event to self
    xcb_configure_notify_event_t cfg = {
        .response_type = XCB_CONFIGURE_NOTIFY,
        .pad0 = 0,
        .sequence = 0,
        .event = win,
        .window = win,
        .x = 0,
        .y = 0,
        .width = 400,
        .height = 200,
        .border_width = 0,
        .override_redirect = 0,
        .pad1 = {0},
    };

    xcb_send_event(conn, 0, win, XCB_EVENT_MASK_STRUCTURE_NOTIFY, (const char *)&cfg);
    xcb_flush(conn);

    // 8) Event loop
    xcb_generic_event_t *event;
    while ((event = xcb_wait_for_event(conn))) {
        switch (event->response_type & ~0x80) {
            case XCB_EXPOSE: {
                printf("Expose event\n");
                break;
            }
            case XCB_KEY_PRESS: {
                xcb_key_press_event_t *kp = (void *)event;
                printf("Key pressed: keycode=%u\n", kp->detail);
                break;
            }
            case XCB_CLIENT_MESSAGE: {
                xcb_client_message_event_t *cm = (void *)event;
                // Check WM_DELETE_WINDOW
                if (protocols_reply && delete_reply &&
                    cm->data.data32[0] == delete_reply->atom) {
                    printf("WM_DELETE_WINDOW received, exiting\n");
                    free(event);
                    goto shutdown;
                }
                break;
            }
            default: break;
        }
        free(event);
    }

shutdown:
    xcb_disconnect(conn);
    return 0;
}
