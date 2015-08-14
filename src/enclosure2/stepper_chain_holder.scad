module chain_mount_holes(){
  circle(d=4, $fn=20);
  translate([0, 9]) circle(d=4, $fn=20);
}

module stepper_holder(){
  casing_width=42;
  diagonal_width=54;
  zen_stepper_holder_width=62;
  overhang = zen_stepper_holder_width - casing_width;
  offset_to_channel=20;
  chain_outside_width=23;
  chain_mount_width=offset_to_channel + chain_outside_width;
  difference(){
    translate([0, -chain_mount_width/2]) square([zen_stepper_holder_width, casing_width + chain_mount_width + overhang], center=true);
    translate([0, casing_width/2]) square([10, overhang], center=true);
    difference(){
      square([casing_width, casing_width], center=true);
      difference(){
        square([casing_width, casing_width], center=true);
        rotate(45) square([diagonal_width, diagonal_width], center=true);
      }
    }
    translate([0, -(casing_width/2 + offset_to_channel + chain_outside_width)]) rotate(90) chain_mount_holes();
//    translate([0, -(casing_width/2 + offset_to_channel + chain_outside_width)]) square([chain_outside_width, chain_outside_width], center=true);
  }
}
stepper_holder();