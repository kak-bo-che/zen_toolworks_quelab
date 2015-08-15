include <slots.scad>
include <rounded_square.scad>
power_supply_length=215;
power_supply_width=115;
power_supply_height=50;
material_thickness=3.1;
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
    square([215, 50], center=true);
    power_supply_side_holes();
  }
}
module side(){
  estop_height=50;
  height_div=floor((power_supply_height + estop_height)/material_thickness);
  height=height_div*material_thickness;
  length=base_plate_length - 3*corner_radius;
  union(){
    square([length, height]);
    translate([0, height]) make_slots(length, 7, material_thickness, true);
    translate([0, -material_thickness]) make_slots(length, 7, material_thickness, true);
  }
}

module front(){
  estop_height=50;
  height_div=floor((power_supply_height + estop_height)/material_thickness);
  height=height_div*material_thickness;
  length=base_plate_width - 3*corner_radius;
  union(){
    square([length, height]);
    translate([0, height]) make_slots(length, 5, material_thickness, true);
    translate([0, -material_thickness]) make_slots(length, 5, material_thickness, true);
  }
}
module base_plate(){
  length=base_plate_length;
  width=power_supply_width + 2*corner_radius+material_thickness;
  difference(){
    translate([0, -width/2]) rounded_square(length, width, corner_radius);
    translate([0, -width/2]) rounded_square_mounting_holes(length, width, corner_radius, hole_size );
    translate([1.5*corner_radius, power_supply_width/2]) make_slots(length - 3*corner_radius, 7, material_thickness, true);
    translate([1.5*corner_radius, -power_supply_width/2 -material_thickness]) make_slots(length - 3*corner_radius, 7, material_thickness, true);
    translate([length - corner_radius, 0]) rotate(90) translate([-(width - 3*corner_radius)/2, -material_thickness/2]) make_slots(width - 3*corner_radius, 5, material_thickness, true);
  }
}
translate([1.5*corner_radius, 100])  side();
translate([base_plate_length + 40, -base_plate_width/2])  front();
difference(){
  base_plate();
  power_supply();
}