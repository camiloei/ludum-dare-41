manage_cursor_sprite(objects_array, obj_game_manager.current_state != EGameState.Tutorial);

#region Tutorial
if obj_game_manager.current_state == EGameState.Tutorial
{
	if current_tutorial_state == ETutorialState.BossSpawn
	{
		show_debug_message("Spawning costumer");
		current_customer = instance_create_layer(customer_spawn_pos_x, customer_spawn_pos_y, "Customer", obj_customer);
		current_customer.current_state = ECustomerState.Entering;
		current_tutorial_state = ETutorialState.BossEntering;
	}
	else if current_tutorial_state = ETutorialState.BossEntering
	{
		if current_customer.x <= obj_customer_final_position.bbox_right + 10
		{
			current_tutorial_state = ETutorialState.BossSpeaking;
		}
	}
	else if current_tutorial_state == ETutorialState.BossSpeaking
	{
		// action between dialogue cases
		if dialogues[dialogues_index] == "action_size"
		{
			obj_glass_large.interaction_hover_enabled = true;
			obj_glass_medium.interaction_hover_enabled = true;
			obj_glass_small.interaction_hover_enabled = true;
			current_tutorial_state = ETutorialState.WaitingSelectSize;
			dialogues_index += 1;
		}
		else if dialogues[dialogues_index] == "action_coffee"
		{
			obj_glass_large.interaction_hover_enabled = false;
			obj_glass_medium.interaction_hover_enabled = false;
			obj_glass_small.interaction_hover_enabled = false;
			obj_coffee.interaction_hover_enabled = true;
			current_tutorial_state = ETutorialState.WaitingSelectCoffee;
			dialogues_index += 1;
		}
		else if dialogues[dialogues_index] == "action_water"
		{
			obj_coffee.interaction_hover_enabled = false;
			obj_water_dispenser.interaction_hover_enabled = true;
			obj_milk_dispenser.interaction_hover_enabled = true;
			current_tutorial_state = ETutorialState.WaitingSelectWater;
			dialogues_index += 1;
		}
		else if dialogues[dialogues_index] == "action_sugar"
		{
			obj_water_dispenser.interaction_hover_enabled = false;
			obj_milk_dispenser.interaction_hover_enabled = false;
			
			obj_sugar.interaction_hover_enabled = true;
			obj_sweetener.interaction_hover_enabled = true;
			
			current_tutorial_state = ETutorialState.WaitingSelectSugar;
			dialogues_index += 1;
		}
		else if dialogues[dialogues_index] == "action_chocolate"
		{
			obj_sugar.interaction_hover_enabled = false;
			obj_sweetener.interaction_hover_enabled = false;
			
			obj_chocolate.interaction_hover_enabled = true;
			obj_cream.interaction_hover_enabled = true;
			obj_condensed_milk.interaction_hover_enabled = true;
			
			current_tutorial_state = ETutorialState.WaitingSelectChocolate;
			
			dialogues_index += 1;
		}
		else if dialogues[dialogues_index] == "action_deliver"
		{
			obj_chocolate.interaction_hover_enabled = false;
			obj_cream.interaction_hover_enabled = false;
			obj_condensed_milk.interaction_hover_enabled = false;
			
			current_cup_selected.draggable = true;
			
			current_tutorial_state = ETutorialState.WaitingDeliver;
			
			dialogues_index += 1;
		}
		else if dialogues[dialogues_index] == "action_finish"
		{
			current_customer.current_state = ECustomerState.Leaving;
			current_tutorial_state = ETutorialState.EndTutorial;
		}
		else 
		{
			if current_text == undefined
			{
				current_text = instance_create_layer(current_customer.x - 300, current_customer.y, "Texts", obj_text);
				current_text.content = dialogues[dialogues_index];
				current_text.char_delay = 2;
			}
			else 
			{
				if current_text.finished && mouse_check_button_pressed(mb_left)
				{
					dialogues_index += 1;
					instance_destroy(current_text);
					current_text = undefined;
				}
				else if current_text && mouse_check_button_pressed(mb_left)
				{
					current_text.skip = true;
				}
			}
		}
	}
	else if current_tutorial_state == ETutorialState.WaitingSelectSize
	{
		if obj_glass_small.is_pressed && !speaking_extras
		{
			speaking_extras = true;
			extras_text = instance_create_layer(current_customer.x - 300, current_customer.y, "Texts", obj_text);
			extras_text.content = "That’s small, big guy.\nGive me the medium one.";
			extras_text.char_delay = 2;
		}
		else if obj_glass_large.is_pressed && !speaking_extras
		{
			speaking_extras = true;
			extras_text = instance_create_layer(current_customer.x - 300, current_customer.y, "Texts", obj_text);
			extras_text.content = "That’s large.\nAnd too much coffee makes me go down the toilet.\nGive me the medium one.";
			extras_text.char_delay = 2;
		}
		else if obj_glass_medium.is_pressed && !speaking_extras
		{
			obj_glass_small.interaction_hover_enabled = false;
			obj_glass_large.interaction_hover_enabled = false;
			obj_glass_medium.interaction_hover_enabled = false;
			
			current_cup_selected = instance_create_layer(obj_interaction_text.x, obj_interaction_text.y - 100, "Draggable", obj_glass_medium);
			current_tutorial_state = ETutorialState.BossSpeaking
		}
		else 
		{
			if speaking_extras && extras_text && extras_text.finished && mouse_check_button_pressed(mb_left)
			{
				speaking_extras = false;
				instance_destroy(extras_text);
				extras_text = undefined;
			}
			else if speaking_extras && extras_text && !extras_text.finished && mouse_check_button_pressed(mb_left)
			{
				extras_text.skip = true;
			}
		}
	}
	else if current_tutorial_state == ETutorialState.WaitingSelectCoffee  
	{
		if current_coffee >= 5
		{
			obj_coffee.interaction_hover_enabled = false;
			current_tutorial_state = ETutorialState.BossSpeaking;
		}
		else if obj_coffee.is_pressed
		{
			obj_coffee.is_pressed = false;
			current_coffee += 1;
		}
	}
	else if current_tutorial_state == ETutorialState.WaitingSelectWater
	{
		if current_water == 2 && current_milk == 1
		{
			obj_water_dispenser.interaction_hover_enabled = false;
			obj_milk_dispenser.interaction_hover_enabled = false;
			current_tutorial_state = ETutorialState.BossSpeaking;
		}
		else if current_water > 2 || current_milk > 1
		{
			if !speaking_extras
			{
				speaking_extras = true;
				extras_text = instance_create_layer(current_customer.x - 300, current_customer.y, "Texts", obj_text);
				extras_text.content = "That’s not what I tell you, the coffee is ruined.\nGet rid of that cup and let’s start over.";
				extras_text.char_delay = 2;
			}
			else if speaking_extras && extras_text && extras_text.finished && mouse_check_button_pressed(mb_left)
			{
				speaking_extras = false;
				instance_destroy(extras_text);
				extras_text = undefined;
				
				obj_water_dispenser.interaction_hover_enabled = false;
				obj_milk_dispenser.interaction_hover_enabled = false;
				current_cup_selected.draggable = true;
				
				current_tutorial_state = ETutorialState.HandleFailed;
			}
			else if speaking_extras && extras_text && !extras_text.finished && mouse_check_button_pressed(mb_left)
			{
				extras_text.skip = true;
			}
		}
		else if obj_water_dispenser.is_pressed
		{
			current_water += 1;
			obj_water_dispenser.is_pressed = false;
		}
		else if obj_milk_dispenser.is_pressed
		{
			current_milk += 1;
			obj_milk_dispenser.is_pressed = false;
		}
	}
	else if current_tutorial_state == ETutorialState.HandleFailed
	{
		if current_cup_selected.is_pressed && !current_cup_selected.following_cursor
		{
			current_cup_selected.is_pressed = false;
			current_cup_selected.following_cursor = true;
		}
		else if current_cup_selected.following_cursor && obj_garbage.is_pressed
		{
			obj_garbage.is_pressed = false;
			instance_destroy(current_cup_selected);
			dialogues_index = 7;
			reset_ingredients();
			current_tutorial_state = ETutorialState.BossSpeaking;
		}
	}
	else if current_tutorial_state == ETutorialState.WaitingSelectSugar
	{
		if current_sugar == 2 && current_sweetener == 10
		{
			obj_sugar.interaction_hover_enabled = false;
			obj_sweetener.interaction_hover_enabled = false;
			current_tutorial_state = ETutorialState.BossSpeaking;
		}
		else if current_sugar > 2 || current_sweetener > 10
		{
			if !speaking_extras
			{
				speaking_extras = true;
				extras_text = instance_create_layer(current_customer.x - 300, current_customer.y, "Texts", obj_text);
				extras_text.content = "That’s not what I tell you, the coffee is ruined.\nGet rid of that cup and let’s start over.";
				extras_text.char_delay = 2;
			}
			else if speaking_extras && extras_text && extras_text.finished && mouse_check_button_pressed(mb_left)
			{
				speaking_extras = false;
				instance_destroy(extras_text);
				extras_text = undefined;
				
				obj_sugar.interaction_hover_enabled = false;
				obj_sweetener.interaction_hover_enabled = false;
			
				current_cup_selected.draggable = true;
				
				current_tutorial_state = ETutorialState.HandleFailed;
			}
			else if speaking_extras && extras_text && !extras_text.finished && mouse_check_button_pressed(mb_left)
			{
				extras_text.skip = true;
			}
		}
		else if obj_sugar.is_pressed
		{
			current_sugar += 1;
			obj_sugar.is_pressed = false;
		}
		else if obj_sweetener.is_pressed
		{
			current_sweetener += 1;
			obj_sweetener.is_pressed = false;
		}
	}
	else if current_tutorial_state == ETutorialState.WaitingSelectChocolate
	{
		if current_chocolate == 1 && current_cream == 1 && current_condensed_milk == 1
		{
			obj_chocolate.interaction_hover_enabled = false;
			obj_cream.interaction_hover_enabled = false;
			obj_condensed_milk.interaction_hover_enabled = false;
			
			current_tutorial_state = ETutorialState.BossSpeaking;
		}
		else if current_chocolate > 1 || current_cream > 1 && current_condensed_milk > 1
		{
			if !speaking_extras
			{
				speaking_extras = true;
				extras_text = instance_create_layer(current_customer.x - 300, current_customer.y, "Texts", obj_text);
				extras_text.content = "That’s not what I tell you, the coffee is ruined.\nGet rid of that cup and let’s start over.";
				extras_text.char_delay = 2;
			}
			else if speaking_extras && extras_text && extras_text.finished && mouse_check_button_pressed(mb_left)
			{
				speaking_extras = false;
				instance_destroy(extras_text);
				extras_text = undefined;
				
				obj_chocolate.interaction_hover_enabled = false;
				obj_cream.interaction_hover_enabled = false;
				obj_condensed_milk.interaction_hover_enabled = false;
			
				current_cup_selected.draggable = true;
				
				current_tutorial_state = ETutorialState.HandleFailed;
			}
			else if speaking_extras && extras_text && !extras_text.finished && mouse_check_button_pressed(mb_left)
			{
				extras_text.skip = true;
			}
		}
		else if obj_chocolate.is_pressed
		{
			current_chocolate += 1;
			obj_chocolate.is_pressed = false;
		}
		else if obj_cream.is_pressed
		{
			current_cream += 1;
			obj_cream.is_pressed = false;
		}
		else if obj_condensed_milk.is_pressed
		{
			current_condensed_milk += 1;
			obj_condensed_milk.is_pressed = false;
		}
	}
	else if current_tutorial_state == ETutorialState.WaitingDeliver
	{
		if current_customer.is_pressed
		{
			current_tutorial_state = ETutorialState.BossSpeaking;
			current_customer.is_pressed = false;
			instance_destroy(current_cup_selected);
			current_cup_selected = undefined;
		}
	}
	else if current_tutorial_state == ETutorialState.EndTutorial
	{
		if current_customer && current_customer.x > room_width + 200
		{
			show_debug_message("ending tutorial");
			instance_destroy(current_customer);
			current_customer = undefined;
			reset_ingredients();
			obj_game_manager.current_state = EGameState.WorkDayHandled;
		}
	}
}
#endregion
#region WORKDAY_HANDLED
else if obj_game_manager.current_state == EGameState.WorkDayHandled
{
	if day_ended && current_customer
	{
		if current_customer.x > room_width + 200
		{
			current_customer.current_state = ECustomerState.Idle;
			obj_game_manager.current_state = EGameState.ResumeDay;
		}
	}
	else if day_ended && current_customer == undefined
	{
		obj_game_manager.current_state = EGameState.ResumeDay;
	}
	
	if current_state != ESceneState.NonInitialized && !day_ended
	{
		current_day_time += 1;
		current_costumer_total_time += 1;
		
		if current_customer && current_costumer_total_time > current_customer.customer_wait_time
		{
			customer_failed_count += 1;
			current_state = ESceneState.HandleTimeout;
		}
		
		if current_day_time > total_day_time
		{
			reset_cups();
			
			if game_play_text != undefined
			{
				instance_destroy(game_play_text);
				game_play_text = undefined;
			}
			
			if current_customer &&
			   current_customer.current_state == ECustomerState.Idle
			{
				current_customer.current_state = ECustomerState.Leaving;
			}
			
			day_ended = true;
		}
	}
	
	var drag_valid_states = current_state == ESceneState.CustomerSpeaking ||
							current_state == ESceneState.CustomerWaitingReceive ||
							current_state == ESceneState.WaitSelectSomething;
							
	if drag_valid_states && current_cup_selected != undefined && !day_ended
	{
		if current_cup_selected.current_state == EDraggrableState.InTrash
		{
			reset_cups();
			
			allow_selecting_cup = true;
			
			current_cup_selected = undefined;
			current_cup_selected_index = 0;
			
			reset_ingredients();
		}
		else if current_cup_selected.current_state == EDraggrableState.DeliveredToCostumer
		{
			reset_cups();
			
			if game_play_text != undefined
			{
				instance_destroy(game_play_text);
				game_play_text = undefined;
			}

			if cup_requirement == current_cup_selected_index &&
			   coffee_requirement == current_coffee &&
			   milk_requirement == current_milk &&
			   water_requirement == current_water &&
			   sugar_requirement == current_sugar &&
			   sweetener_requirement == current_sweetener &&
			   chocolate_requirement == current_chocolate &&
			   cream_requirement == current_cream &&
			   condensed_milk_requirement == current_condensed_milk
			 {
				 customer_success_count += 1;
				 current_state = ESceneState.HandleSucccess;
			 }
			 else 
			 {
				current_state = ESceneState.HandleFailed;
			 }
		}
	}
	
	if current_state == ESceneState.NonInitialized && !day_ended
	{
		// Greetings MESSAGE
		greeting_message = greetings[0, irandom_range(0, array_length_1d(greetings) - 1)];
		
		// Customer Challenge Type
		customer_type = ECustomerType.StepByStep;
		
		// Cup Size
		cup_requirement = irandom_range(1, 3);
		
		// Cup Size MESSAGE
		coffee_size_message = coffee_size_messages[cup_requirement - 1];
		
		// Coffee Grams
		coffee_requirement = irandom_range(1, 10);
		
		// Coffee Grams MESSAGE
		coffee_grams_message = "With " + string(coffee_requirement) + " grams of coffee.";
		
		var mw_item;
		
		// Milk Water Selection
		if cup_requirement == 3
		{
			mw_item = milk_water_messages_large[0, array_length_1d(milk_water_messages_large) - 1];
		}
		else if cup_requirement == 2
		{
			mw_item = milk_water_messages_medium[0, array_length_1d(milk_water_messages_medium) - 1];
		}
		else if cup_requirement == 1
		{
			mw_item = milk_water_messages_small[0, array_length_1d(milk_water_messages_small) - 1];
		}
		
		water_requirement = mw_item[1];
		milk_requirement = mw_item[2];
		
		// Milk Water requirement MESSAGE
		milk_water_message = mw_item[0];
		
		sugar_requirement = irandom_range(1, 5);
		
		// Sugar MESSAGE
		sugar_message = "With " + string(sugar_requirement) + " tablespoons of sugar.";
		
		sweetener_requirement = irandom_range(1, 15);
		
		// Sweetener MESSAGE
		sweetener_message = "With " + string(sweetener_requirement) + " sweetener drops.";
		
		var extra_ingredient = irandom_range(1, 3);
		
		chocolate_requirement = 0;
		cream_requirement = 0;
		condensed_milk_requirement = 0;
		
		if extra_ingredient == 1
		{
			chocolate_requirement = 1;
			extra_ingredient_message = "and chocolate.";
		}
		else if extra_ingredient == 2
		{
			cream_requirement = 1;
			extra_ingredient_message = "and cream.";
		}
		else if extra_ingredient == 3
		{
			condensed_milk_requirement = 1;
			extra_ingredient_message = "and condensed milk.";
		}
		
		message_success = close_messages_success[0, irandom_range(0, array_length_1d(close_messages_success) - 1)];
		
		message_fail_time = close_messages_fail_time[0, irandom_range(0, array_length_1d(close_messages_fail_time) - 1)];
		
		mesaage_fail_preparation = messages_fail_preparation[0, irandom_range(0, array_length_1d(messages_fail_preparation) - 1)];
		
		// Customer Creation
		if current_customer == undefined
		{
			current_customer = instance_create_layer(customer_spawn_pos_x, customer_spawn_pos_y, "Customer", obj_customer);
		}
		
		current_costumer_total_time = 0;
		current_customer.customer_wait_time = irandom_range(2500, 3000);
		
		current_customer.current_state = ECustomerState.Entering;
		
		obj_customer_final_position.active = true;
		
		current_speak_delay = irandom_range(2, 4);
		
		set_interaction_hover_enabled_global(objects_array, true);
		
		reset_ingredients();
		
		customer_time_between_message = irandom_range(100, 120);
		
		if ds_queue_size(dialogues_queue) > 0
		{
			ds_queue_clear(dialogues_queue);
		}
		
		current_cup_selected_index = 0;
		
		ds_queue_enqueue(dialogues_queue, coffee_size_message);
		ds_queue_enqueue(dialogues_queue, coffee_grams_message);
		ds_queue_enqueue(dialogues_queue, milk_water_message);
		ds_queue_enqueue(dialogues_queue, sugar_message);
		ds_queue_enqueue(dialogues_queue, sweetener_message);
		ds_queue_enqueue(dialogues_queue, extra_ingredient_message);
		
		current_state = ESceneState.CustomerEntering;
	}
	else if current_state == ESceneState.CustomerEntering && !day_ended
	{
		if current_customer.current_state == ECustomerState.Idle
		{
			current_state = ESceneState.CustomerGreeting;
		}
	}
	else if current_state == ESceneState.CustomerGreeting && !day_ended
	{
		if game_play_text == undefined
		{
			game_play_text = instance_create_layer(current_customer.x - 300, current_customer.y, "Texts", obj_text);
			game_play_text.content = greeting_message;
			game_play_text.char_delay =  current_speak_delay;
		}
		else if game_play_text && !game_play_text.finished && mouse_check_button_pressed(mb_left)
		{
			game_play_text.skip = true;
		}
		else if game_play_text && game_play_text.finished && mouse_check_button_pressed(mb_left)
		{
			current_state = ESceneState.CustomerSpeaking;
		}
	}
	else if current_state == ESceneState.CustomerSpeaking && !day_ended
	{
		if ds_queue_size(dialogues_queue) > 0 && game_play_text == undefined
		{
			var text = ds_queue_dequeue(dialogues_queue);
			
			game_play_text = instance_create_layer(current_customer.x - 300, current_customer.y, "Texts", obj_text);
			game_play_text.content = text;
			game_play_text.char_delay =  current_speak_delay;
		}
		else if ds_queue_size(dialogues_queue) == 0
		{
			current_state = ESceneState.CustomerWaitingReceive;
		}
		else if game_play_text.finished
		{
			current_state = ESceneState.WaitSelectSomething;
		}
	}
	else if current_state == ESceneState.WaitSelectSomething && !day_ended
	{	
		customer_message_accum_time += 1;
		
		if customer_message_accum_time > customer_time_between_message
		{
			instance_destroy(game_play_text);
			game_play_text = undefined;
			customer_message_accum_time = 0;
			current_state = ESceneState.CustomerSpeaking;
		}
	}
	else if current_state == ESceneState.CustomerWaitingReceive && !day_ended
	{
		
	}
	else if current_state == ESceneState.HandleFailed && !day_ended
	{
		if game_play_text == undefined
		{
			game_play_text = instance_create_layer(current_customer.x - 300, current_customer.y, "Texts", obj_text);
			game_play_text.content = mesaage_fail_preparation;
			game_play_text.char_delay =  current_speak_delay;
		}
		else if game_play_text && !game_play_text.finished && mouse_check_button_pressed(mb_left)
		{
			game_play_text.skip = true;
		}
		else if game_play_text && game_play_text.finished && mouse_check_button_pressed(mb_left)
		{
			allow_selecting_cup = true;
			
			current_cup_selected_index = 0;
			
			reset_ingredients();
			
			ds_queue_clear(dialogues_queue);
			
			ds_queue_enqueue(dialogues_queue, coffee_size_message);
			ds_queue_enqueue(dialogues_queue, coffee_grams_message);
			ds_queue_enqueue(dialogues_queue, milk_water_message);
			ds_queue_enqueue(dialogues_queue, sugar_message);
			ds_queue_enqueue(dialogues_queue, sweetener_message);
			ds_queue_enqueue(dialogues_queue, extra_ingredient_message);
			
			instance_destroy(game_play_text);
			game_play_text = undefined;
			
			current_state = ESceneState.CustomerSpeaking;
		}
	}
	else if current_state == ESceneState.HandleTimeout && !day_ended
	{
		if game_play_text == undefined && current_customer.current_state == ECustomerState.Idle
		{
			game_play_text = instance_create_layer(current_customer.x - 300, current_customer.y, "Texts", obj_text);
			game_play_text.content = message_fail_time;
			game_play_text.char_delay =  current_speak_delay;
		}
		else if game_play_text && !game_play_text.finished && mouse_check_button_pressed(mb_left) && current_customer.current_state == ECustomerState.Idle
		{
			game_play_text.skip = true;
		}
		else if game_play_text && game_play_text.finished && mouse_check_button_pressed(mb_left)
		{
			instance_destroy(game_play_text);
			game_play_text = undefined;
			
			if current_customer && current_customer.current_state == ECustomerState.Idle
			{
				current_customer.current_state = ECustomerState.Leaving;
			}
		}
		
		if current_customer && current_customer.x > room_width + 200
		{
			reset_cups();
			
			allow_selecting_cup = true;
			current_state = ESceneState.NonInitialized;
		}
	}
	else if current_state == ESceneState.HandleSucccess && !day_ended
	{
		if game_play_text == undefined && current_customer.current_state == ECustomerState.Idle
		{
			game_play_text = instance_create_layer(current_customer.x - 300, current_customer.y, "Texts", obj_text);
			game_play_text.content = message_success;
			game_play_text.char_delay =  current_speak_delay;
		}
		else if game_play_text && !game_play_text.finished && mouse_check_button_pressed(mb_left) && current_customer.current_state == ECustomerState.Idle
		{
			game_play_text.skip = true;
		}
		else if game_play_text && game_play_text.finished && mouse_check_button_pressed(mb_left)
		{
			instance_destroy(game_play_text);
			game_play_text = undefined;
			
			reset_cups();
			
			if current_customer && current_customer.current_state == ECustomerState.Idle
			{
				current_customer.current_state = ECustomerState.Leaving;
			}
		}
		
		if current_customer && current_customer.x > room_width + 200
		{
			allow_selecting_cup = true;
			current_state = ESceneState.NonInitialized;
		}
	}
}

#endregion
else if obj_game_manager.current_state == EGameState.ResumeDay
{
	show_debug_message("DAY ENDED AND IM IN THE RESUMEEEE");
}











