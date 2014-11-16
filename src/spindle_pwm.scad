hole_size = 3.2;
module spindle_pwm(){
	difference(){
		square([76, 51]);
		translate([4, 3.5]) circle(d=hole_size);
		translate([4, 46.5]) circle(d=hole_size);
		translate([30, 2]) circle(d=hole_size);
		translate([29.5, 46.7]) circle(d=hole_size);
	}
}
spindle_pwm();