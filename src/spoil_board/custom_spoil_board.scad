object="spoil_board";
file_type="dxf";

$fn=60;
width=240;
length=200;
extrusion_outside_width=19.5;
extrusion_inside_width=10;
extrusion_length=200;
outside_offsets = [11, 60,   161,   221.5];
inside_offsets =  [16, 65.5, 165.5, 215];


module base_plate(width, length){
	square([width, length]);
}

module extrusion_cut(width){
	depth=10;
	length=200;
	square([width, length]);
}

module x_align(){
	for(i = [0:20:220]){
		translate([i, 0])  square([10,200]);
	}
}
module y_align(){
	for(i = [10:20:190])
	{
		translate([0, i])  square([240,10]);
	}
}
module extrusion_slits(cut_offsets){
	slit_offsets=[cut_offsets[1], cut_offsets[2]];
	for(i=slit_offsets){
		translate([i, 0]) extrusion_cut(extrusion_inside_width);
	}
}
module mounting_holes(){
	diameter = 4;
	side_offset = 15;
	offsets = [[16, 26], [65.5, 75.5], [165.5, 175.5], [215, 224]];	
	center1 = offsets[0][1] + (offsets[1][0] - offsets[0][1])/2;
	center2 = offsets[1][1] + (offsets[2][0] - offsets[1][1])/2;
	center3 = offsets[2][1] + (offsets[3][0] - offsets[2][1])/2;
	centers = [center1, center2, center3];
	for(i=centers){
		translate([i, side_offset]) circle(d=diameter);
		translate([i, length - side_offset]) circle(d=diameter);
	}
}
module removed_sides(){
	left_side_start = 0;
	left_side_end = inside_offsets[0] + extrusion_inside_width;
	right_side_start = inside_offsets[3];
	right_side_end = width;
	left_side_width = left_side_end - left_side_start;
	right_side_width = right_side_end - right_side_start;
	translate([left_side_start, 0])  square([left_side_width, length]);
	translate([right_side_start, 0]) square([right_side_width, length]);
}

module spoil_board(width, length){
	center_support_width = 50;
	center_offset = length/2 - center_support_width/2; 
	translate([0, center_offset]) square([width, center_support_width]);
	difference(){
		base_plate(width, length);
		removed_sides();
		extrusion_slits(inside_offsets);
		mounting_holes();
	}
}

if(file_type=="stl"){
	if(object=="y_align") linear_extrude(height=1) y_align();
	if(object=="x_align") linear_extrude(height=1) x_align();
	if(object=="spoil_board") linear_extrude(height=1) spoil_board(width, length);
} else {
	if(object=="y_align") y_align();
	if(object=="x_align") x_align();
	if(object=="spoil_board") spoil_board(width, length);
}