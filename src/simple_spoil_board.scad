object="spoil_board";
file_type="dxf";

module base_plate(){
	square([240, 200]);
}

module long_slit(){
	length=140;
	width=6;
	union(){
		square([width,length]);
		translate([3,-5.2]) circle(r=6);
		translate([3, length+5.2]) circle(r=6);
	}
}
module short_slit(){
	union(){
		square([6,51]);
		translate([3,-5.2]) circle(r=6);
		translate([3, 56.2]) circle(r=6);
	}
}
module x_align(){
	                    square([10,200]);
	translate([20, 0])  square([10,200]);
	translate([40, 0])  square([10,200]);
	translate([60, 0])  square([10,200]);
	translate([80, 0])  square([10,200]);
	translate([100, 0]) square([10,200]);
	translate([120, 0]) square([10,200]);
	translate([140, 0]) square([10,200]);
	translate([160, 0]) square([10,200]);
	translate([180, 0]) square([10,200]);
	translate([200, 0]) square([10,200]);
	translate([220, 0]) square([10,200]);

}
module y_align(){
	translate([0, 10])  square([240,10]);
	translate([0, 30])  square([240,10]);
	translate([0, 50])  square([240,10]);
	translate([0, 70])  square([240,10]);
	translate([0, 90])  square([240,10]);
	translate([0, 110])  square([240,10]);
	translate([0, 130])  square([240,10]);
	translate([0, 150])  square([240,10]);
	translate([0, 170])  square([240,10]);
	translate([0, 190])  square([240,10]);

}
module spoil_board(){
	// 119 to 170
	difference(){
		base_plate([240, 200]);
		translate([17,30]) long_slit();
		translate([217,30]) long_slit();
		translate([67, 30]) short_slit();
		translate([167, 30]) short_slit();
		translate([67, 120]) short_slit();
		translate([167, 120]) short_slit();
	}
}

if(file_type=="stl"){
	if(object=="y_align") linear_extrude(height=1) y_align();
	if(object=="x_align") linear_extrude(height=1) x_align();
	if(object=="spoil_board") linear_extrude(height=1) spoil_board();
} else {
	if(object=="y_align") y_align();
	if(object=="x_align") x_align();
	if(object=="spoil_board") spoil_board();
}