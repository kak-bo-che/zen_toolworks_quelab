$fn=20;
include <raspberrypi2.scad>;
include <arduino.scad>
include <spindle_pwm.scad>
use <case_fan.scad>
include <vents.scad>

part_offset=5;

arduino_height=68.58;
arduino_width=53.34;
board_offset=10;

case_height=50;
case_length=260;
case_width=120;
panel_thickness=3; //1.55?
hole_size=3.2;
corner_radius=10;
board_widths = arduino_width + rp_width + pwm_width + 2*board_offset + part_offset;

module rounded_square(width, height, radius){
  // frame_hole_diameter=2*radius;
  // x_y_frame_offset=frame_hole_diameter/2/sqrt(2);

  hull(){
    translate([radius,         radius]) circle(r=radius);
    translate([width - radius, radius]) circle(r=radius);
    translate([radius,         height - radius]) circle(r=radius);
    translate([width - radius, height - radius]) circle(r=radius);
  }
}
module corner_stack(radius){
  difference() {
    circle(r=radius);
    translate([radius, 0]) square([radius, panel_thickness], center=true);
    rotate(90) translate([radius, 0]) square([radius, panel_thickness], center=true);
    circle(d=hole_size);
  }
}

module aviation_connector_base(){
  intersection(){
    square([14.5, 17], center=true);
    circle(d=15.7);
  }
}

module barrel_connector_base(){
  circle(d=7.9);
}

module zenback(){
  square([340, 120]);
}

module arduino_up(){
  translate([arduino_width, arduino_height]) rotate(180) projection(cut=true) arduino();
  translate([0, -10]) square([arduino_width, 10]);
}

module pwm_up(){
   translate([pwm_width, 0]) rotate(90) spindle_pwm();
}

module pi_up(){
  translate([rp_width, 0]) rotate(90) RaspberryPi2();
}

ubec_height=35;
ubec_width=18;

module ubec_mounts(){
  translate([-panel_thickness, 0]) square([panel_thickness, panel_thickness], center=true);
  translate([ubec_width + panel_thickness, 0]) square([panel_thickness, panel_thickness], center=true);
}
module ubec(){
  translate([0, ubec_height/3]) ubec_mounts();
  translate([0, 2*ubec_height/3]) ubec_mounts();

  square([ubec_width, ubec_height]);
}

module circuit_boards(){
  translate([0, pwm_height - arduino_height]) arduino_up();
  translate([arduino_width + board_offset, 0]) pwm_up();
  translate([arduino_width + pwm_width + 2*board_offset, 0]) pi_up();
  translate([arduino_width + pwm_width + rp_width + 2*board_offset + board_offset,  (rp_height - ubec_height)/3  ]) ubec();
}

module base_plate(){
  difference() {
    rounded_square(case_length, case_width, corner_radius);
    //square([case_length, case_width]);
    translate([(case_length - 2*corner_radius - board_widths)/2, board_offset/2 + 2*part_offset]) circuit_boards();
  }
}

module power_side(){
  plate_height = case_height;
  plate_width = case_width - 3*corner_radius;
  difference() {
   square([plate_height, plate_width]);
    translate([3*plate_height/4,   3*(plate_width/4)]) aviation_connector_base();
    translate([2*plate_height/4, 3*(plate_width/4)]) rotate(270)  text("48V", size=2, halign= "center");
    translate([1.5*plate_height/4, 3*(plate_width/4)]) rotate(270)  text("12 - 24V", size=2, halign= "center");
    translate([1*plate_height/4,   3*(plate_width/4)]) barrel_connector_base();
    translate([25, 30]) case_fan(40);
  }
}

module stepper_side(){
  plate_height = case_height;
  plate_width = case_width - 3*corner_radius;
  difference(){
    square([plate_height, plate_width]);
    translate([1*plate_height/3, 1*plate_width/4]) aviation_connector_base();
    translate([2*plate_height/3, 1*plate_width/4]) barrel_connector_base();

    translate([1*plate_height/3, 2*(plate_width/4)]) aviation_connector_base();
    translate([2*plate_height/3, 2*plate_width/4]) barrel_connector_base();

    translate([1*plate_height/3, 3*(plate_width/4)]) aviation_connector_base();
    translate([2*plate_height/3, 3*plate_width/4]) barrel_connector_base();
  }
}

module spindle_side(){
  plate_height = case_height;
  plate_width = case_length - 3*corner_radius;
  square([plate_width, plate_height]);
}

module fan_side(){
  plate_height = case_height;
  plate_width = case_length - 3*corner_radius;
  vent_radius=3;
  difference(){
    square([plate_width, plate_height]);
    vents(plate_width/3, plate_height, vent_radius);
  }
}

module case_top(){
  rounded_square(case_length, case_width, corner_radius);
}

module corners(length, width){
  translate([corner_radius, corner_radius]) corner_stack(corner_radius);
  translate([length - corner_radius, corner_radius]) rotate(90) corner_stack(corner_radius);

  translate([corner_radius, width - corner_radius]) rotate(270) corner_stack(corner_radius);
  translate([length - corner_radius, width - corner_radius]) rotate(180) corner_stack(corner_radius);
}
module box(){
  base_plate();
  translate([case_length+part_offset,  1.5*corner_radius]) power_side();
  translate([-(part_offset + case_height), 1.5*corner_radius]) stepper_side();
  translate([1.5*corner_radius, case_width + part_offset]) spindle_side();
  translate([1.5*corner_radius, -(case_height + part_offset)]) fan_side();
  translate([0, case_width + case_height + 2*part_offset]) case_top();
}
difference() {
  box();
  corners(case_length, case_width);
}
