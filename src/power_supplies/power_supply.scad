include <../util/slots.scad>
include <../util/rounded_square.scad>
$fn=20;
power_supply_length=215;
power_supply_width=115;
power_supply_height=50;

overall_length=300;
overall_height=70;
stepper_power_width=30;

part_separation=5;
material_thickness=3.04;
corner_radius=10;
hole_size=3.2;

base_plate_length=150 + 70;
base_plate_width=power_supply_width + 2*corner_radius+material_thickness;
module m4_holes(){
  hole_radius = 4.2/2;
  x_offset = 150/2;
  y_offset = 50/2;
  translate([x_offset, y_offset]){
    circle(hole_radius);
  }
  translate([-x_offset, y_offset]){
    circle(hole_radius);
  }
  translate([x_offset, -y_offset]){
    circle(hole_radius);
  }
  translate([-x_offset, -y_offset]){
    circle(hole_radius);
  }

}
module power_supply(){
  difference(){
    %square([215, 115], center=true);
    m4_holes();
  }
}
module power_supply_side_holes(){
  hole_diameter = 4.2;
  x_offset = 150/2;
  y_offset = 13;
  translate([x_offset, y_offset]){
    circle(d=hole_diameter);
  }
  translate([-x_offset, y_offset]){
    circle(d=hole_diameter);
  }
}
module power_supply_side(){
  difference(){
    %square([215, 50], center=true);
    power_supply_side_holes();
  }
}

module nema_with_switch(){
  square([27, 42.3], center=true);
}

module nema(){
  hole_diameter=3.2;
  square([27, 19.1], center=true);
  %square([49.5,22.5], center=true);
  translate([-20, 0]) circle(d=hole_diameter);
  translate([20, 0]) circle(d=hole_diameter);

}

module vent_legs(count=3, radius=10){
  for(x=[1:count]){
    translate([x*overall_length/(count + 1), 0]){
      hull(){
          translate([-1.5*radius, 0])circle(radius);
          translate([1.5*radius, 0]) circle(radius);
      }
    }
  }
}

module power_switch(){
  circle(12);
  %square([30, 37], center=true);
}

module stepper_power(){
  square([stepper_power_width, 110]);
}

module stepper_power_side_dc(){
  %square([stepper_power_width, 48]);
  translate([stepper_power_width/2, 9]) circle(d=10);
}

module stepper_power_side_ac(){
  %square([stepper_power_width, 48]);
  translate([stepper_power_width/2, 15.5]) square([15,20], center=true);
}

module ac_side(){
  difference(){
    side();
    translate([material_thickness, material_thickness]) stepper_power_side_ac();
    translate([material_thickness + stepper_power_width + 25, power_supply_height/2 + 10]) nema();
    translate([material_thickness + stepper_power_width + 10, 9]) circle(d=7.5);
  }
}

module dc_side(){
  difference(){
    side();
    translate([material_thickness, material_thickness]) stepper_power_side_dc();
    translate([material_thickness + stepper_power_width + 25, 2*power_supply_height/3]) circle(d=19.7);
    translate([material_thickness + stepper_power_width + 5, 17]) circle(d=7.5);
  }
}

module screw_terminal(n=2){
  terminal_height=18.6;
  divider_height=21.8;

  hole_locations = [[ 2, 28.7], [3, 38.2], [4, 47.7], [5, 57.2], [6, 66.7], [7, 76.2], [8, 85.7]];
  lengths =        [[2, 36.2], [3, 45.7], [4, 55.2], [5, 64.7], [6, 74.2], [7, 83.7], [8, 93.2]];
  hole_distance = lookup(n, hole_locations);
  length =        lookup(n, lengths);
  // translate([length/2, divider_height/2]){
      %square([length, divider_height], center=true);
      translate([-hole_distance/2, 4]) circle(d=4);
      translate([-hole_distance/2, -4]) circle(d=4);
      translate([hole_distance/2, 4]) circle(d=4);
      translate([hole_distance/2, -4]) circle(d=4);
  // }
}

module side(){
  leg_holes = floor(overall_length/5);
  difference(){
    square([overall_length, overall_height]);
    make_slots(overall_length - power_supply_length, 5, material_thickness, true);
    translate([0, overall_height]) vent_legs();
    translate([material_thickness, 0]) rotate(90) make_slots(overall_height, 5, material_thickness, true);
    translate([material_thickness, power_supply_height + 1.5]) make_slots(overall_length - power_supply_length - material_thickness, 5, material_thickness, true);
    translate([overall_length - power_supply_length, 0]){
      translate([power_supply_length/2, power_supply_height/2]) rotate(180) power_supply_side();
    }
  }
}

module front(){
  translate([0, material_thickness]) square([power_supply_width, overall_height - material_thickness]);
  translate([power_supply_width + material_thickness, 0]) rotate(90) make_slots(overall_height, 5, material_thickness, true);
  translate([0, 0]) rotate(90) make_slots(overall_height, 5, material_thickness, true);
  make_slots(power_supply_width, 5, material_thickness, true);
}

module top(){
  difference(){
    union(){
      square([overall_length - power_supply_length, power_supply_width]);
      translate([0, power_supply_width]) make_slots(overall_length - power_supply_length, 5, material_thickness, true);
      translate([0, -material_thickness]) make_slots(overall_length - power_supply_length, 5, material_thickness, true);
    }
    translate([material_thickness, 0]) rotate(90) make_slots(power_supply_width, 5, material_thickness, true);
    translate([(overall_length - power_supply_length + 13)/2, 2.4*power_supply_width/5]) power_switch();
    translate([(overall_length - power_supply_length + 30)/2, 4*power_supply_width/5]) screw_terminal(2);
    % translate([material_thickness, 0]) stepper_power();
  }
}

module bottom(){
  bottom_length = overall_length - power_supply_length - material_thickness;
  square([2*bottom_length/5, power_supply_width]);
  translate([0, power_supply_width]) make_slots(2*bottom_length/5, 2, material_thickness, true);
  translate([0, -material_thickness]) make_slots(2*bottom_length/5, 2, material_thickness, true);
}
%square([300, 300]);
ac_side();
translate([0, +part_separation + 2*overall_height]) mirror([0,1,0]) dc_side();
translate([overall_height, 2*(overall_height + part_separation + 2)]) rotate(90) front();
translate([overall_height + part_separation, 2*(overall_height + part_separation + 2)]) top();
translate([overall_length - power_supply_length + overall_height + 2*part_separation, 2*(overall_height + part_separation + 2)]) bottom();
