include <raspberrypi2.scad>;
include <arduino.scad>
include <spindle_pwm.scad>
use <case_fan.scad>
include <vents.scad>
$fn=50;

part_offset=10;
board_buffer=5;
arduino_height=68.58;
arduino_width=53.34;
board_offset=10;

case_height=54; // 3*18
case_length=260;
case_width=120;
panel_thickness=3.1; //1.55?
hole_size=3.2;
corner_radius=10;
length_slots=11;
width_slots=7;
board_widths = arduino_width + rp_width + pwm_width + 2*board_offset + board_buffer;

module wire_pin(length, height){
  ledge_width = 2.5*panel_thickness;
  ledge_offset = (ledge_width - panel_thickness)/2;
  union(){
    square([length, panel_thickness]);
    square([panel_thickness, height+ 2*panel_thickness]);
    translate([length - panel_thickness, 0]) square([panel_thickness, height+ 2*panel_thickness]);
    translate([-ledge_offset, height]) square([2.5*panel_thickness, panel_thickness]);
    translate([length -ledge_offset - panel_thickness, height]) square([2.5*panel_thickness, panel_thickness]);

  }
}
module make_slots(length, slot_count, reverse=false, slop=0){

  slot_size=length/slot_count;
  offset= reverse?slot_size:0;
  odd= (slot_count%2) == 1?1:0;
  extra = odd && !reverse?1:0;

  for(x=[0:floor((slot_count + extra)/2) - 1]){
    translate([2*x*slot_size + offset -slop/2, 0]) square([slot_size + slop, panel_thickness]);
  }
}
module rounded_square(width, height, radius){

  hull(){
    translate([radius,         radius]) circle(r=radius);
    translate([width - radius, radius]) circle(r=radius);
    translate([radius,         height - radius]) circle(r=radius);
    translate([width - radius, height - radius]) circle(r=radius);
  }
}

module corner_stack(radius, hex_hole=false){
  hex_hole_size=5.4;
  difference() {
    circle(r=radius);
    translate([radius, 0]) square([radius, panel_thickness], center=true);
    rotate(90) translate([radius, 0]) square([radius, panel_thickness], center=true);
    if (hex_hole){
      circle(d=hex_hole_size, $fn=6);
    } else {
      circle(d=hole_size);
    }
  }
}

module aviation_connector_base(){
  intersection(){
    square([14.5, 17], center=true);
    circle(d=16);
  }
}

module barrel_connector_base(){
  circle(d=7.9);
}

module zenback(){
  square([340, 120]);
}

module arduino_up(){
  union(){
    translate([arduino_width, arduino_height + 10]) rotate(180) projection(cut=false) arduino(UNO);
    //square([arduino_width - 5, 11]); // gShield overhang
  }
}

module pwm_up(){
   //translate([pwm_width, 0]) rotate(90) spindle_pwm();
   translate([pwm_width, 0]) rotate(90) spindle_pwm_holes();

}

module pi_up(){
  //translate([rp_width, 0]) rotate(90) RaspberryPi2();
  translate([rp_width, 0]) rotate(90) RaspberryPi2MountingHoles();
}

module pi_side(){
  usb_height=16;
  usb_width=16;

  ethernet_width=16;
  ethernet_height=12.5;
  first_usb_center=56-47;
  second_usb_center=56-29;
  ethernet_center=56-10.25;

  translate([first_usb_center, usb_height/2]) square([usb_width, usb_height], center=true);
  translate([second_usb_center, usb_height/2]) square([usb_width, usb_height], center=true);
  translate([ethernet_center, ethernet_height/2]) square([ethernet_width, ethernet_height], center=true);

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

//  square([ubec_width, ubec_height]);
}

module circuit_boards(){
  measured_arduino_offset=10;
  measured_rp_offset=8;
  translate([0, measured_arduino_offset]) arduino_up(); //pwm_height - arduino_height])
  translate([arduino_width + board_offset, 0]) pwm_up();
  translate([arduino_width + pwm_width + 2*board_offset, measured_rp_offset]) pi_up();
  translate([arduino_width + pwm_width + rp_width + 2*board_offset + board_offset,  (rp_height - ubec_height)/3  ]) ubec();
}

module base_mounting_holes(length, width, radius){
  translate([radius, radius]) circle(d=hole_size);
  translate([length - radius, radius]) circle(d=hole_size);

  translate([radius, width - radius]) circle(d=hole_size);
  translate([length - radius, width - radius]) circle(d=hole_size);
}

module power_side(){
  plate_height = case_height;
  plate_width = case_width - 3*corner_radius;
  union(){
    difference() {
     square([plate_height, plate_width]);
      translate([1*plate_height/4,   3*(plate_width/4)]) aviation_connector_base();
      translate([1.8*plate_height/4, 3*(plate_width/4)]) mirror([0,1,0]) rotate(270)  text("48V", size=3, halign= "center");
      translate([2.3*plate_height/4, 3*(plate_width/4)]) mirror([0,1,0]) rotate(270)  text("12 - 24V", size=2, halign= "center");
      translate([3*plate_height/4,   3*(plate_width/4)]) barrel_connector_base();
      translate([(plate_height - 40)/2 + 20, 30]) case_fan(40);
      translate([(plate_height - 40)/2 + 20, 55]) square([3, 5], center=true); //cable hole
    }
    translate([plate_height + panel_thickness, 0]) rotate(90) make_slots(case_width - 3*corner_radius, width_slots, true);
    translate([ 0, 0]) rotate(90) make_slots(case_width - 3*corner_radius, width_slots, true);
  }
}

module stepper_side(){
  plate_height = case_height;
  plate_width = case_width - 3*corner_radius;
  union(){
    difference(){
      square([plate_height, plate_width]);
      translate([1*plate_height/3, 1*plate_width/4]) aviation_connector_base();
      translate([2*plate_height/3, 1*plate_width/4]) barrel_connector_base();

      translate([1*plate_height/3, 2*(plate_width/4)]) aviation_connector_base();
      translate([2*plate_height/3, 2*plate_width/4]) barrel_connector_base();

      translate([1*plate_height/3, 3*(plate_width/4)]) aviation_connector_base();
      translate([2*plate_height/3, 3*plate_width/4]) barrel_connector_base();
    }
  translate([plate_height + panel_thickness, 0]) rotate(90) make_slots(case_width - 3*corner_radius, width_slots, true);
  translate([ 0, 0]) rotate(90) make_slots(case_width - 3*corner_radius, width_slots, true);
  }
}

module spindle_side(){
  plate_height = case_height;
  plate_width = case_length - 3*corner_radius;
  standoff_height=5;
  rp_2_spacer_nut=5.25;
  rp_2_board_thickness=1.6;
  centered_board_offset = (case_length - 2*corner_radius - board_widths)/2;
   //translate([(case_length - 2*corner_radius - board_widths)/2  - 1.5*corner_radius, 0]) translate([1.5*corner_radius, 0]) arduino(UNO);
   union(){
    difference(){
      union(){
        square([plate_width, plate_height]);
        translate([0, plate_height]) make_slots(case_length - 3*corner_radius, length_slots, true);
        translate([0, - panel_thickness ]) make_slots(case_length - 3*corner_radius, length_slots, true);
      }
      translate([1.5*corner_radius + 2*arduino_width/3, 3*plate_height/4]) rotate(90) aviation_connector_base();
      projection(cut=true) translate([centered_board_offset + arduino_width - 1.5*corner_radius, standoff_height]) rotate([90, 0, 180]) arduino(UNO);
      translate([centered_board_offset + arduino_width + pwm_width + 2*board_offset - 1.5*corner_radius, rp_2_spacer_nut + rp_2_board_thickness]) pi_side();
    }
    square([30,20]); //get rid of arduino power hole
  }
}
module base_plate(){
  difference() {
    rounded_square(case_length, case_width, corner_radius);
    translate([(case_length - 2*corner_radius - board_widths)/2, corner_radius + panel_thickness]) circuit_boards();
    translate([1.5*corner_radius, corner_radius - panel_thickness/2 ]) make_slots(case_length - 3*corner_radius, length_slots, true);
    translate([1.5*corner_radius, case_width -corner_radius - panel_thickness/2 ]) make_slots(case_length - 3*corner_radius, length_slots, true);
    translate([corner_radius + panel_thickness/2, 1.5*corner_radius]) rotate(90) make_slots(case_width - 3*corner_radius, width_slots, true);
    translate([case_length - corner_radius + panel_thickness/2, 1.5*corner_radius]) rotate(90) make_slots(case_width - 3*corner_radius, width_slots, true);
    base_mounting_holes(case_length, case_width, corner_radius);
    base_mounting_holes(case_length, case_width, corner_radius + corner_radius);
  }
}

module filter_side(){
  plate_height = case_height;
  plate_width = case_length - 3*corner_radius;
  vent_radius=4;
  union(){
    difference(){
      square([plate_width, plate_height]);
      vents(plate_width/3, plate_height, vent_radius);
    }
    translate([0, plate_height]) make_slots(case_length - 3*corner_radius, length_slots, true);
    translate([0, - panel_thickness ]) make_slots(case_length - 3*corner_radius, length_slots, true);
  }
}

module case_top(){
  offset_to_cap_x=40.65;
  offset_to_cap_y=43.5;
  cap_diameter=28;
  slot_slop=1;
  difference(){
    rounded_square(case_length, case_width, corner_radius);
    translate([1.5*corner_radius, corner_radius - panel_thickness/2 ]) make_slots(case_length - 3*corner_radius, length_slots, true, slot_slop);
    translate([1.5*corner_radius, case_width -corner_radius - panel_thickness/2 ]) make_slots(case_length - 3*corner_radius, length_slots, true, slot_slop);
    translate([corner_radius + panel_thickness/2, 1.5*corner_radius]) rotate(90) make_slots(case_width - 3*corner_radius, width_slots, true, slot_slop);
    translate([case_length - corner_radius + panel_thickness/2, 1.5*corner_radius]) rotate(90) make_slots(case_width - 3*corner_radius, width_slots, true, slot_slop);
    base_mounting_holes(case_length, case_width, corner_radius);
    translate([(case_length - 2*corner_radius - board_widths)/2 + arduino_width + board_offset + offset_to_cap_x, corner_radius + panel_thickness+ offset_to_cap_y]) {
      translate([0, cap_diameter]) text("TOP", size=5, halign= "center");
      circle(d=cap_diameter);
      translate([cap_diameter/2 + 7, 0]) square([10, 0.5], center=true);
      translate([-(cap_diameter/2 + 7), 0]) square([10, 0.5], center=true);
      rotate(90) {
        translate([cap_diameter/2 + 7, 0]) square([10, 0.5], center=true);
        translate([-(cap_diameter/2 + 7), 0]) square([10, 0.5], center=true);
      }

    }
  }
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
  translate([1.5*corner_radius, -(case_height + part_offset)]) filter_side();
  translate([0, case_width + case_height + 2*part_offset]) case_top();
}

module rp_bridge(){
  union(){
    square([rp_width - 4, 4]);
    translate([0, 4]) make_slots(rp_width - 4, 5);
  }
}

module rp_spacer(){
  difference(){
    circle(d=6);
    circle(d=rp_hole);
  }
}

box();
translate([-30, -30]) wire_pin(ubec_width + 3*panel_thickness, 7);
translate([-60, -30]) corner_stack(corner_radius);
translate([-90, -30]) corner_stack(corner_radius, true);
translate([-30, -45]) rp_spacer();

