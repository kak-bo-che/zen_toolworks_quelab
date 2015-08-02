mounting_hole_diameter=3.4;
$fn=15;
rp_width=56;
rp_height=85;
rp_hole=2.75;

module RaspberryPi2MountingHoles(){

	translate([3.5, 3.5]) circle(d=rp_hole);
	translate([3.5, 52.5]) circle(d=rp_hole);
	translate([61.5, 3.5]) circle(d=rp_hole);
	translate([61.5, 52.5]) circle(d=rp_hole);
}
module RaspberryPi2(){
	rp_radius=3;
  first_usb_center=47;
  second_usb_center=29;

	difference(){
//		square([85, 56]);
		union(){
			hull(){
				translate([rp_radius, rp_radius]) circle(r=rp_radius);
				translate([rp_radius, 56 - rp_radius]) circle(r=rp_radius);
				translate([85 - rp_radius, rp_radius]) circle(r=rp_radius);
				translate([85 - rp_radius, 56 - rp_radius]) circle(r=rp_radius);
			}
			translate([rp_height + 1, first_usb_center]) square([2, 15], center=true);
			translate([rp_height + 1, second_usb_center]) square([2, 15], center=true);
		}
		RaspberryPi2MountingHoles();
	}
}
