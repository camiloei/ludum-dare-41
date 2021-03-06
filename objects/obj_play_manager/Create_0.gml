#region TUTORIAL_STUFF

enum ETutorialState
{
	BossSpawn,
	BossEntering,
	BossSpeaking,
	WaitingSelectSize,
	WaitingSelectCoffee,
	WaitingSelectWater,
	HandleFailed,
	WaitingSelectSugar,
	WaitingSelectChocolate,
	WaitingDeliver,
	EndTutorial
}

dialogues = [
	"Ok new guy, I'm your boss, \nand this is the thing.",
	"To make a good coffee you need to get\nthe preparation in a specific order.",
	"And make it with love.",
	"And with love a mean the exact measurement of ingredients.",
	"Or you fail.",
	"Now, make me a coffee big guy.",
	"First, you need to know the size.",
	"I want a regular one.",
	"action_size", // first action
	"Good",
	"Now, is extremely important to do all this step in order.",
	"From left to right.",
	"Or your coffee is going to stink.",
	"And here in Duckbucks we like to make things right.",
	"And with love.",
	"Always with love.",
	"So, we make the coffee to the measure\nof the customer, and in\nthe exact way that he wants.",
	"First, you have to put the grams of coffee.",
	"Yeah, here we make coffee with the whole grain.",
	"Put 5 grams in there, and one at a time.",
	"action_coffee", // section action
	"Good, now we put the liquids.",
	"The regular size have 300 millimeters of capacity.",
	"The small has 200 ml. and large has 400 ml.",
	"Every time you use the water or\nmilk dispenser, you fill it with 100 ml.",
	"If you exceed the capacity of the cup,\nthe coffee is ruined.",
	"So, having that in mind, give me 2/3 of\nwater, and the rest fill it with milk.",
	"action_water", // third action
	"Wonderful big guy, you are made to do this job.",
	"The next step is the sugar.",
	"I want 2 tablespoons of sugar.",
	"And 10 drops of sweetener.",
	"...",
	"Don’t judge me.",
	"2 tablespoons of sugar and 10 drops of sweetener.",
	"action_sugar", // fourth action
	"Excellent! That's the spirit.",
	"I can see the determination in your eyes when you do this.",
	"Finally, put some chocolate, cream and condensed milk in there, one of each.",
	"action_chocolate", // fifth action,
	"Yeah! That’s a real coffee!",
	"Now, give me that baby.",
	"action_deliver", // sixth action,
	"Aaahh, the aroma of a good coffee in the morning replenishes any soul.",
	"Well, that is all you need to know.",
	"Always do the coffee in this order,\nor the customer is going to be upset.",
	"And we don’t wants upset customers.",
	"We want happy customers.",
	"Customers fills with love.",
	"And I going to pay you for the number of\nhappy customers fills with love.",
	"It's that ok?",
	"Of course is ok.",
	"I can see it in your face.",
	"You are going to love this.",
	"Here comes the first customer",
	"You’re going to do a great job",
	"action_finish" // final action
];

current_tutorial_state = ETutorialState.BossSpawn;
current_text = undefined;
dialogues_index = 0;
speaking_extras = false;
extras_text = undefined;

#endregion

#region GAME_STUFF

enum ESceneState
{
	NonInitialized,
	CustomerEntering,
	CustomerGreeting,
	CustomerSpeaking,
	WaitSelectSomething,
	CustomerWaitingReceive,
	HandleFailed,
	HandleSucccess,
	HandleTimeout,
	CustomerLeaving
}

enum ECustomerType
{
	None,
	StepByStep
}

enum EDraggrableState
{
	Idle,
	Selected,
	FollowingCursor,
	InTrash,
	DeliveredToCostumer
}

objects_array = [
	obj_glass_large,
	obj_glass_medium,
	obj_glass_small,
	obj_sugar,
	obj_coffee,
	obj_chocolate,
	obj_cream,
	obj_condensed_milk,
	obj_milk_dispenser,
	obj_water_dispenser,
	obj_garbage,
	obj_sweetener
];

// DATA

greetings = [
	"Sup! I want a",
	"Hello there! Can you give me a",
	"Hi, I need a",
	"Good day! Give me a",
	"Ok, a",
	"Hey, how its going, I want a",
	"Hello, I need a",
	"So, I want a",
	"Hey cutie, give me a",
	"Quick! a",
	"My favorite place! I want a",
	"Custom coffee? Awesome! Give me a",
	"I need coffee. And quick. Give me a"
];

coffee_size_messages = [
	"Large one, please.",
	"Medium one, please.",
	"Small one, please."
];

milk_water_messages_large = [
	["Just milk please.", 0, 4],
	["Can you put more milk than water?", 1, 3],
	["Put half water, and half milk.", 2, 2],
	["Put half water, and half milk.", 2, 2],
	["Put Water, and a just a tiny bit of milk.", 3, 1],
	["Put 3/4 of water, and the rest with milk.", 3, 1],
	["Can you put more water than milk?", 3, 1],
	["Without milk please.", 4, 0]
];

milk_water_messages_medium = [
	["Put water, and a tiny bit of milk.", 2, 1],
	["Just full water.", 3, 0],
	["Just full milk.", 0, 3],
	["Put more milk than water.", 1, 2],
	["Put more water than milk.", 2, 1]
];

milk_water_messages_small = [
	["Put half water, and half milk", 1, 1],
	["Just water please", 1, 0],
	["Just milk please", 0, 1]
];

close_messages_success = [
	"Thank you.",
	"This better be good.",
	"Finally!",
	"Thank you handsome.",
	"Yey!",
	"Wonderful.",
	"Coffee, coffee, coffee!",
	"This smells great.",
	"Lovely.",
	"Thanks!",
	"I love coffee.",
	"Coffee is love.",
	"You’re the best!",
	"You rock.",
	"Thanks sweety!",
	"Awesome!",
	"Perfect."
];

close_messages_fail_time = [
	"You take too long! I’m out.",
	"Can you be more slow? I’m going to buy in Planetbucks.",
	"I can’t wait any longer, forget the coffee!",
	"You suck. Bye.",
	"I don’t have time for this, I’m out.",
	"You take too long, goodbye."
];

messages_fail_preparation = [
	"This is not what I order! Make another one.",
	"Hey! This is not my coffee, please make me another one.",
	"You do this wrong, can you make me another with my specifications this time?",
	"Did you listen what a ask you to do? please make me another one.",
	"This is wrong, you make me a different coffee. Make another, please.",
	"Disgusting! This is not what I order, make it right this time.",
	"You mix up my specifications, make another one please.",
	"You are wrong handsome, put attention this time.",
	"Oh boy, this is disgusting, please make me another one.",
	"Great coffee, but not what I orden. Make me one more, please."
];

total_day_time = 10000;
current_day_time = 0;
current_costumer_total_time = 0;
customer_time_between_message = 15;
customer_message_accum_time = 0;

day_ended = false;

customer_success_count = 0;
customer_failed_count = 0;

current_customer = undefined;
current_cup_selected = undefined;
current_cup_selected_index = 0;
current_sugar = 0;
current_coffee = 0;
current_chocolate = 0;
current_cream = 0;
current_condensed_milk = 0;
current_milk = 0;
current_water = 0;
current_sweetener = 0;

greeting_message = "";
coffee_size_message = "";
coffee_grams_message = "";
milk_water_message = "";
sugar_message = "";
sweetener_message = "";
extra_ingredient_message = "";

message_success = "";
message_fail_time = "";
mesaage_fail_preparation = "";

dialogues_queue = ds_queue_create();

cup_requirement = 0;

coffee_requirement = 0;

milk_requirement = 0;
water_requirement = 0;

sugar_requirement = 0;
sweetener_requirement = 0;

chocolate_requirement = 0;
cream_requirement = 0;
condensed_milk_requirement = 0;

customer_spawn_pos_x = room_width + 200;
customer_spawn_pos_y = 100;

current_state = ESceneState.NonInitialized;
customer_type = ECustomerType.None;

game_play_text = undefined;

current_speak_delay = 2;

last_pressed_item = undefined;

allow_selecting_cup = true;

#endregion