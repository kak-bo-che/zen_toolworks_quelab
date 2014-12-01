include <arduino.scad>
$fn=60;	
module arduino_mount(){
	difference(){
		boardShape(height=0.001); 
		holePlacement(boardType=UNO){
			cylinder(1, 1.6);
		}
	}
}

projection(cut=true) rotate([90,0,0]) arduino(UNO);
//projection(cut=true) {
//arduino_mount();
//}
