#include <pebble.h>

Window *window; 
TextLayer *text_layer;

void init() {
  // Create the Window
  window = window_create();

  // Push to the stack, animated
  window_stack_push(window, true);

  // Create the TextLayer, for display at (0, 0),
  // and with a size of 144 x 40
  text_layer = text_layer_create(GRect(0, 0, 144, 40));

  // Set the text that the TextLayer will display
  text_layer_set_text(text_layer, "PATETOOO! ");

  // Add as child layer to be included in rendering
  layer_add_child(window_get_root_layer(window), 
    text_layer_get_layer(text_layer));
  window_set_background_color(window, GColorBlack);

  //Set click config
   window_set_click_config_provider(window, ClickConfigProvider config_provider);
}

void deinit() {
  // Destroy the Window
  window_destroy(window);
  // Destroy the TextLayer
  text_layer_destroy(text_layer);
}

//Vibrations
void vibrations(int times){
  static const uint32_t const segments[] = { 200, 100, 400 };
  if (times > 0){
      VibePattern pat = {
      .durations = segments,
      .num_segments = ARRAY_LENGTH(segments),
    };
    vibes_enqueue_custom_pattern(pat);
    times --;
  }
}

void down_single_click_handler(ClickRecognizerRef recognizer, void *context) {
  vibrations(3);
  Window *window = (Window *)context;
}

void config_provider(Window *window){
  //single click
  window_single_click_subscribe(BUTTON_ID_DONW, down_single_click_handler);
}

int main(void) {
    // Initialize the app
  init();

  // Wait for app events
  app_event_loop();

  // Deinitialize the app
  deinit();

  // App finished without error
  return 0;
}
