#include <pebble.h>

Window *window;
TextLayer *text_layer;

void init (){
	//Create window
	window = window_create();

	//Text Layer
	text_layer = text_layer_create(Grect(0, 0, 144, 40));
	text_layer_set_text(text_layer, "Hello");
	layer_add_child(window_get_root_layer(window), 
						text_layer_get_layer(text_layer));

	//Push to stack, animated
	window_stack_push(window, true);
}

void deinit() {
	//Destroy the window
	text_layer_destroy(text_layer);
	window_destroy();
}

int main(void){
	//Initialize the app
	app_event_loop();

	//Wait for app events
	init();

	//Deinitialize the app
	deinit();

	//App ends
	return 0;
}