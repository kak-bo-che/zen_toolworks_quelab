module rounded_square(width, height, radius){
  hull(){
    translate([radius,         radius]) circle(r=radius);
    translate([width - radius, radius]) circle(r=radius);
    translate([radius,         height - radius]) circle(r=radius);
    translate([width - radius, height - radius]) circle(r=radius);
  }
}

module rounded_square_mounting_holes(length, width, radius, hole_size){
  translate([radius, radius]) circle(d=hole_size);
  translate([length - radius, radius]) circle(d=hole_size);

  translate([radius, width - radius]) circle(d=hole_size);
  translate([length - radius, width - radius]) circle(d=hole_size);
}
