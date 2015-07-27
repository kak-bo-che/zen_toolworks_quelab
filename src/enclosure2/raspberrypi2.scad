mounting_hole_diameter=3.4;
$fn=15;
rp_width=56;
rp_height=85;
module RaspberryPi2MountingHoles(){
	rp_hole=2.75;
	translate([3.5, 3.5]) circle(d=rp_hole);
	translate([3.5, 52.5]) circle(d=rp_hole);
	translate([61.5, 3.5]) circle(d=rp_hole);
	translate([61.5, 52.5]) circle(d=rp_hole);
}
module RaspberryPi2(){
	rp_radius=3;
	difference(){
//		square([85, 56]);
		hull(){
			translate([rp_radius, rp_radius]) circle(r=rp_radius);
			translate([rp_radius, 56 - rp_radius]) circle(r=rp_radius);
			translate([85 - rp_radius, rp_radius]) circle(r=rp_radius);
			translate([85 - rp_radius, 56 - rp_radius]) circle(r=rp_radius);
		}
		RaspberryPi2MountingHoles();
	}
}
