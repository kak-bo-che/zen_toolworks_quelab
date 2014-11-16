$fn=60;
module micro_stepper(){
	hole_y = (35 - 20.8 - 9.8)/2;
	hole_x = 7;
	y_offset = 20.8 - 35/2;
	x_offset = 96/2 - 7;
	echo(hole_y);
	difference(){
		square([96, 35], center=true);
		translate([-x_offset - hole_y, y_offset]){
			circle(hole_y);
		}
		translate([x_offset + hole_y, y_offset]){
			circle(hole_y);
		}
	}
}
micro_stepper();