/*
 * main.c
 * Sets up the timer and resets it
 */

#include <pebble.h>

static Window *s_main_window;
static TextLayer *s_output_layer;

//Layer de tiempo
static TextLayer *s_uptime_layer;
static int s_uptime = 0;
static bool b_timeOnOff = true;

/******* Methods ********/
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
  if (b_timeOnOff){  
    // Use a long-lived buffer
    static char s_uptime_buffer[32];

    // Get time since launch
    int seconds = s_uptime % 60;
    int minutes = (s_uptime % 3600) / 60;
    int hours = s_uptime / 3600;

    // Update the TextLayer
    snprintf(s_uptime_buffer, sizeof(s_uptime_buffer), "Uptime: %dh %dm %ds", hours, minutes, seconds);
    text_layer_set_text(s_uptime_layer, s_uptime_buffer);

    // Increment s_uptime
    s_uptime++;

    //Uptime Vibration
    if (seconds%5 == 0 && seconds!=0){
      vibrations(3);
    }
  }
  else{
    s_uptime = s_uptime;
  }
}

/******* Controllers **********/
static void up_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(s_output_layer, "Up pressed!");
}

static void select_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(s_output_layer, "Timer Begins");
  //vibrations(3);
  b_timeOnOff = !b_timeOnOff;
}

static void down_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(s_output_layer, "Down pressed!");
}

static void click_config_provider(void *context) {
  // Register the ClickHandlers
  window_single_click_subscribe(BUTTON_ID_UP, up_click_handler);
  window_single_click_subscribe(BUTTON_ID_SELECT, select_click_handler);
  window_single_click_subscribe(BUTTON_ID_DOWN, down_click_handler);
}

static void main_window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect window_bounds = layer_get_bounds(window_layer);

  // Create output TextLayer
  s_output_layer = text_layer_create(GRect(5, 0, window_bounds.size.w - 5, window_bounds.size.h));
  text_layer_set_font(s_output_layer, fonts_get_system_font(FONT_KEY_GOTHIC_24));
  text_layer_set_text(s_output_layer, "No button pressed yet.");
  text_layer_set_overflow_mode(s_output_layer, GTextOverflowModeWordWrap);
  layer_add_child(window_layer, text_layer_get_layer(s_output_layer));

  // Create output TextLayer
  s_uptime_layer = text_layer_create(GRect(0, 100, window_bounds.size.w, window_bounds.size.h));
  text_layer_set_font(s_output_layer, fonts_get_system_font(FONT_KEY_GOTHIC_24));
  text_layer_set_text_alignment(s_uptime_layer, GTextAlignmentCenter);
  text_layer_set_text(s_uptime_layer, "Uptime: 0h 0m 0s");
  layer_add_child(window_layer, text_layer_get_layer(s_uptime_layer));
}

static void main_window_unload(Window *window) {
  // Destroy output TextLayer
  text_layer_destroy(s_output_layer);

  // Destroy output Uptime
  text_layer_destroy(s_uptime_layer);
}

static void init() {
  // Create main Window
  s_main_window = window_create();
  window_set_window_handlers(s_main_window, (WindowHandlers) {
    .load = main_window_load,
    .unload = main_window_unload
  });
  window_set_click_config_provider(s_main_window, click_config_provider);
  window_stack_push(s_main_window, true);

  // Subscribe to TickTimerService
  tick_timer_service_subscribe(SECOND_UNIT, tick_handler);
}

static void deinit() {
  // Destroy main Window
  window_destroy(s_main_window);
}

int main(void) {
  init();
  app_event_loop();
  deinit();
}