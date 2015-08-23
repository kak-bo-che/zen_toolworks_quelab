object="circuit_board";
file_type="dxf";

length=240;
width=200;
long_slit_length=140;
short_slit_length=51;
start_x=32;
start_y=24;
// Common Measurements:
// 51.10 x 76.15
// 101.61 x 153.02
// board_length=51.10; //101.61
// board_width=76.15; //153.02
board_length=101.61;
board_width=153.02;

module base_plate(){
	square([length, width]);
}

module slit_holes(diameter=12, center=false, divisions=8, positions=[1,4,7]){
	slit_width=6;
	module nut_holes(hole_diameter){
		for(position=positions){
			translate([slit_width/2, position*long_slit_length/divisions]) circle(d=hole_diameter);
		}
		// translate([slit_width/2, long_slit_length/divisions]) circle(d=hole_diameter);
		// translate([slit_width/2, (divisions/2)*long_slit_length/divisions]) circle(d=hole_diameter);
		// translate([slit_width/2, (divisions-1)*long_slit_length/divisions]) circle(d=hole_diameter);
	}
	if(center == false){
		nut_holes(diameter);
	} else {
		translate([-slit_width/2, -long_slit_length/2]) {
			nut_holes(diameter);
		}
	}
}

module long_slit(center=false){
	length=140;
	end_radius=6;
	width=6;
	module slits(){
		union(){
			square([width,long_slit_length]);
			translate([3,-5.2]) circle(r=end_radius);
			translate([3, long_slit_length+5.2]) circle(r=end_radius);
		}
	}
	if(center == false){
		slits();
	} else {
		translate([-width/2, -long_slit_length/2]) {
		  slits();
		}
	}
}

module short_slit(center=false){
	width=6;
	end_radius=6;
	module slit(){
		union(){
			square([width,short_slit_length]);
			translate([3,-5.2]) circle(r=end_radius);
			translate([3, short_slit_length+5.2]) circle(r=end_radius);
		}
	}
	if(center == false){
		slit();
	} else {
		translate([-width/2, -long_slit_length/2]) {
		  slit();
		}
	}
}
module z_probe_slit(){
	circle(d=15);
	// length=10;
	// width=30;
	// square([length, width]);
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
module spoil_board(){
	// 119 to 170

	difference(){
		base_plate();
//		translate([17,30]) long_slit();
		translate([20, width/2]) long_slit(true);
		translate([20, width/2]) slit_holes(12, true);
		translate([220,width/2]) long_slit(true);
		translate([220, width/2]) slit_holes(12, true);

		translate([170,width/2]) long_slit(true);
		translate([170, width/2]) slit_holes(12, true, 12, [1,3,9,11]);
		translate([70,width/2]) long_slit(true);

		// translate([67, 30]) short_slit();
//		translate([170, 30]) short_slit(true); //30
		// translate([67, 120]) short_slit(true);
		// translate([170, 3*width/4]) short_slit(true); //120
		// translate([170, width/2]) slit_holes(12, true);
	}
}

module circuit_board_cutout(board_length, board_width){
	difference(){
		base_plate();
		translate([start_x, start_y]){
			square([board_length, board_width]);
			circle(d=6);
			translate([board_length, 0]) circle(d=6);
			translate([0, board_width]) circle(d=6);
			translate([board_length, board_width]) circle(d=6);
		}
		translate([20, width/2]) slit_holes(6, true);
		translate([170, width/2]) slit_holes(6, true, 12, [1,3,9,11]);
		translate([220, width/2]) slit_holes(6, true);
		translate([70, start_y+board_width]) z_probe_slit();
	}
}

module circuit_board_cover(board_length, board_width){
	reduced_length=board_length - 4;
	reduced_width=board_width - 4;

	difference(){
		base_plate();
		translate([start_x, start_y]){
			translate([2,2]) square([reduced_length, reduced_width]);
		}
		translate([20, width/2]) slit_holes(6, true);
		translate([170, width/2]) slit_holes(6, true, 12, [1,3,9,11]);
		translate([220, width/2]) slit_holes(6, true);
		translate([70, start_y+board_width]) z_probe_slit();
	}
}


if(file_type=="stl"){
	if(object=="y_align") linear_extrude(height=1) y_align();
	if(object=="x_align") linear_extrude(height=1) x_align();
	if(object=="spoil_board") linear_extrude(height=1) spoil_board();
	if(object=="circuit_board") linear_extrude(height=1) circuit_board_cutout(board_length, board_width);
} else {
	if(object=="y_align") y_align();
	if(object=="x_align") x_align();
	if(object=="spoil_board") spoil_board();
	if(object=="circuit_board")  {
		spoil_board();
		//translate([length + 10, 0])
		%circuit_board_cutout(board_length, board_width);
		//translate([length + 10, -(width + 10)])
		%circuit_board_cover(board_length, board_width);

	}
}