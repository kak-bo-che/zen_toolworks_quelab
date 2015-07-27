
module vent(vent_radius){
  circle(vent_radius);
}

module vents(length, width, radius){
  vent_diameter = 2*radius;
  gap = radius;
  vent_and_gap= vent_diameter + gap;

  x_count = floor(length/vent_and_gap);
  y_count = floor(width/vent_and_gap);
  echo(y_count);
  vents_with_gaps_x = x_count*vent_and_gap - gap;
  vents_with_gaps_y = y_count*vent_and_gap - gap;
  start_offset_x = (length - vents_with_gaps_x)/2;
  start_offset_y = (width - vents_with_gaps_y)/2;
  difference(){
    translate([radius + start_offset_x,radius + start_offset_y]){
      for(y=[0:y_count-1]){
        for(i=[0:x_count-1]){
          translate([i*(vent_diameter+gap), y*(2*radius + gap)]) vent(radius);
        }
      }
    }
  }
}
