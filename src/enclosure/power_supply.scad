module m4_holes(){
	hole_radius = 4.2/2;
	x_offset = 150/2;
	y_offset = 50/2;
	translate([x_offset, y_offset]){
		circle(hole_radius);
	}
	translate([-x_offset, y_offset]){
		circle(hole_radius);
	}
	translate([x_offset, -y_offset]){
		circle(hole_radius);
	}
	translate([-x_offset, -y_offset]){
		circle(hole_radius);
	}

}
module powersupply(){
	difference(){
		square([215, 115], center=true);
		m4_holes();
	}
}
powersupply();