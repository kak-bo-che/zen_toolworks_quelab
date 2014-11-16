$fn=60;
module nema(){
	square([27, 42.3], center=true);
}

module outlet(){
	square([25,24], center=true);
}
module power_module(){
	
	nema();
	translate([0, 55]){
		outlet();
	}
}
power_module();