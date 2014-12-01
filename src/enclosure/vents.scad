vent_radius=4;
vent_length=30;
gap=5;
vent_and_gap=vent_length + gap;
overall_size=140;

module vent(){
	second_circle=vent_length - 2*vent_radius;
	translate([vent_radius, vent_radius]){
		hull(){
			circle(vent_radius);
			translate([second_circle, 0]) circle(vent_radius);
		}
	}
}

module vents(){
	x_count = overall_size/vent_and_gap;
	y_count = overall_size/(2*vent_radius + gap);
	vents_with_gaps_x = x_count*vent_length;
	vents_with_gaps_y = y_count*(vent_radius*2 + gap);
	start_offset_x = (overall_size - vents_with_gaps_x)/2;
	start_offset_y = (overall_size - vents_with_gaps_y)/2;
	echo(vents_with_gaps_y);
	for(y=[0:y_count-1]){
		for(i=[0:x_count-1]){
			translate([start_offset_x + i*(vent_length+gap), start_offset_y + y*(2*vent_radius + gap)]) vent();
		}
	}	
}

difference(){
	//square(overall_size);
	vents();
}