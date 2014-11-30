// usage openscad -o case_fan.stl -D 'file_type="stl"' -D 'fan_size=60' casefan.scad
$fn=60;
file_type="dxf";

fan_size=120;
module holes(diameter, fan_diameter){
	fan_hole_spaces = [[40, 32], 
					   [50, 40], 
					   [60, 50], 
					   [70, 60], 
					   [80, 72], 
					   [92, 83], 
					   [120, 105]];

	radius = diameter/2;
	hole_distance = lookup(fan_diameter, fan_hole_spaces);
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
module case_fan(size){
	cut_radius=size/2 - 2;
	difference(){
		square(size, size, center=true);
		circle(r=cut_radius);
		holes(5.3,size);
	}
}

module extruded_fan(size){
	fan_depths = [[40, 10], 
				  [50, 10], 
				  [60, 15], 
				  [70, 15], 
				  [80, 25], 
				  [92, 25], 
				  [120, 25]];
    extrusion_depth = lookup(size, fan_depths);
    linear_extrude(height=extrusion_depth) case_fan(fan_size);
}

if (file_type=="stl"){
	extruded_fan(fan_size);
} else {
	case_fan(fan_size);
}
