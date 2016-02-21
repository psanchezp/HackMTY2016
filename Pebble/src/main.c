#include <pebble.h>

#define KEY_BUTTON_UP   0
#define KEY_BUTTON_DOWN 1
#define KEY_DATA 5

static Window *s_main_window;
static TextLayer *s_output_layer;
static int slide = 1;
static int s_uptime = 0;

void vibrations (int times){
    static const uint32_t const segments[] = { 200, 100, 400 };
    while (times > 0){
        VibePattern pat = {
            .durations = segments,
            .num_segments = ARRAY_LENGTH(segments),
        };
        vibes_enqueue_custom_pattern(pat);
        times --;
    }
}

static void tick_handler(struct tm *tick_time, TimeUnits units_changed) {
        // Get time since launch
        int seconds = s_uptime % 60;
        int minutes = (s_uptime % 3600) / 60;
        int hours = s_uptime / 3600;
        
        // Increment s_uptime
        s_uptime++;
        
        //Uptime Vibration
        if (seconds == 5 && minutes == 0){
            vibrations(3);
        }
        else if (seconds == 0 && minutes == 1){
            vibrations(3);
        }
}

static void send(int key, int value) {
  DictionaryIterator *iter;
  app_message_outbox_begin(&iter);

  dict_write_int(iter, key, &value, sizeof(int), true);

  app_message_outbox_send();
}

static void outbox_sent_handler(DictionaryIterator *iter, void *context) {
  // Ready for next command
    switch (slide){
        case 1:
            text_layer_set_text(s_output_layer, "Prepbble");
            break;
        case 2:
            text_layer_set_text(s_output_layer, "NOTES");
            break;
        case 3:
            text_layer_set_text(s_output_layer, "REMAINDERS");
            break;
        default:
            text_layer_set_text(s_output_layer, "-");
            break;
    }
}

static void outbox_failed_handler(DictionaryIterator *iter, AppMessageResult reason, void *context) {
    switch (slide){
        case 1:
            text_layer_set_text(s_output_layer, "Prepbble");
            break;
        case 2:
            text_layer_set_text(s_output_layer, "NOTES");
            break;
        case 3:
            text_layer_set_text(s_output_layer, "REMAINDERS");
            break;
        default:
            text_layer_set_text(s_output_layer, "-");
            break;
    }
}

static void up_click_handler(ClickRecognizerRef recognizer, void *context) {
    slide = slide + 1;

  send(KEY_BUTTON_UP, 0);
}

static void down_click_handler(ClickRecognizerRef recognizer, void *context) {
    slide = slide - 1;
    if (slide < 1){
        slide = 1;
    }

  send(KEY_BUTTON_DOWN, 0);
}

static void click_config_provider(void *context) {
  window_single_click_subscribe(BUTTON_ID_UP, up_click_handler);
  window_single_click_subscribe(BUTTON_ID_DOWN, down_click_handler);
}

static void main_window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  const int text_height = 20;
  const GEdgeInsets text_insets = GEdgeInsets((bounds.size.h - text_height) / 2, 0);

  s_output_layer = text_layer_create(grect_inset(bounds, text_insets));
  text_layer_set_text(s_output_layer, "Prepbble");
  text_layer_set_text_alignment(s_output_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(s_output_layer));
}

static void main_window_unload(Window *window) {
  text_layer_destroy(s_output_layer);
}

static void init(void) {
  s_main_window = window_create();
  window_set_click_config_provider(s_main_window, click_config_provider);
  window_set_window_handlers(s_main_window, (WindowHandlers) {
    .load = main_window_load,
    .unload = main_window_unload,
  });
  window_stack_push(s_main_window, true);

  // Open AppMessage
  app_message_register_outbox_sent(outbox_sent_handler);
  app_message_register_outbox_failed(outbox_failed_handler);
    
  // Subscribe to TickTimerService
  tick_timer_service_subscribe(SECOND_UNIT, tick_handler);
  
  const int inbox_size = 128;
  const int outbox_size = 128;
  app_message_open(inbox_size, outbox_size);
}

static void deinit(void) {
  window_destroy(s_main_window);
}

int main(void) {
    init();
   app_event_loop();
   deinit();
 }
