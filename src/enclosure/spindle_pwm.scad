pwm_width=51;
pwm_height=76;
module spindle_pwm(){
  hole_size = 3.2;
	difference(){
		square([pwm_height, pwm_width]);
		translate([4, 3.5]) circle(d=hole_size);
		translate([4, 46.5]) circle(d=hole_size);
		translate([30, 2]) circle(d=hole_size);
		translate([29.5, 46.7]) circle(d=hole_size);
	}
}
