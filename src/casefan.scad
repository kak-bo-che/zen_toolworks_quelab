$fn=60;
fan_sizes =   [40, 50, 60, 70, 80, 92, 120];
hole_spaces = [32, 40, 50, 60, 72, 83, 105];
module holes(diameter){
	radius = diameter/2;
	hole_distance = 105;
	hole_space = hole_distance/2;
	translate([hole_space,hole_space]){
		circle(r=radius);
	}

	translate([-hole_space,hole_space]){
		circle(r=radius);
	}
	translate([-hole_space,-hole_space]){
		circle(r=radius);
	}
	translate([hole_space,-hole_space]){
		circle(r=radius);
	}
	
}
module case_fan(){
	difference(){
		square(120,120, center=true);
		circle(58);
		holes(5.3);
	}
}
case_fan();
