$fn=20;

case_length=100;
case_width=100;
min_height=40;
panel_thickness=3.1; //3.1, 1.55, 5.7 ?

corner_pieces = floor(min_height/panel_thickness);
case_height=corner_pieces*panel_thickness;
corner_radius=10;
length_slots=7;
width_slots=7;

hole_size=3.2;
part_separation=10;

module corner_stack(hex_hole=false){
  hex_hole_size=5.4;
  radius = corner_radius;
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

module make_slots(length, slot_count,  panel_thickness, reverse=false, slop=0){

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

module rounded_square_clamping_holes(length, width, radius, hole_size){
  translate([radius, radius]) circle(d=hole_size);
  translate([length - radius, radius]) circle(d=hole_size);
  translate([radius, width - radius]) circle(d=hole_size);
  translate([length - radius, width - radius]) circle(d=hole_size);
}

module width_side(){
  plate_height = case_height;
  plate_width = case_width - 3*corner_radius;
  union(){
    square([plate_height, plate_width]);
    translate([plate_height + panel_thickness -0.0001, 0]) rotate(90) make_slots(case_width - 3*corner_radius, width_slots, panel_thickness, true);
    rotate(90) make_slots(case_width - 3*corner_radius, width_slots, panel_thickness, true);
  }
}

module length_side(){
  plate_height = case_height;
  plate_width = case_length - 3*corner_radius;
  standoff_height=5;
  centered_board_offset = (case_length - 2*corner_radius - board_widths)/2;
  union(){
    square([plate_width, plate_height]);
    translate([0, plate_height]) make_slots(case_length - 3*corner_radius, length_slots, panel_thickness, true);
    translate([0, - panel_thickness ]) make_slots(case_length - 3*corner_radius, length_slots, panel_thickness, true);
  }
}

module base(){
  difference() {
    rounded_square(case_length, case_width, corner_radius);
    translate([1.5*corner_radius, corner_radius - panel_thickness/2 ]) make_slots(case_length - 3*corner_radius, length_slots, panel_thickness, true);
    translate([1.5*corner_radius, case_width -corner_radius - panel_thickness/2 ]) make_slots(case_length - 3*corner_radius, length_slots, panel_thickness, true);
    translate([corner_radius + panel_thickness/2, 1.5*corner_radius]) rotate(90) make_slots(case_width - 3*corner_radius, width_slots, panel_thickness, true);
    translate([case_length - corner_radius + panel_thickness/2, 1.5*corner_radius]) rotate(90) make_slots(case_width - 3*corner_radius, width_slots, panel_thickness, true);
    rounded_square_clamping_holes(case_length, case_width, corner_radius);
  }
}

translate([-case_length/2, -case_width/2]) base();
translate([-case_length/2, case_width/2 + 2*part_separation + case_height]) base();

translate([1.5*corner_radius -case_length/2, +case_width/2 + part_separation]) length_side();
translate([1.5*corner_radius -case_length/2, -case_width/2 - case_height - part_separation]) length_side();

translate([-case_length/2 - part_separation - case_height, -case_width/2 + 1.5*corner_radius]) width_side();
translate([+case_length/2 + part_separation, -case_width/2 + 1.5*corner_radius]) width_side();

translate([-case_length/2 + corner_radius, -case_width/2 - 2*case_height - part_separation]){
  corner_pieces_per_base=floor(case_length/(2*corner_radius + part_separation));
  rows = floor(corner_pieces*4/corner_pieces_per_base);
  for(y=[0:rows]){
    for(x=[0:corner_pieces_per_base]){
        translate([2*x*corner_radius + x*part_separation/2, -(2*corner_radius*y + y*part_separation)]) corner_stack();
    }
  }
}

