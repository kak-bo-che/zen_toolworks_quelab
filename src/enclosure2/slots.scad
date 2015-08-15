module make_slots(length, slot_count,  panel_thickness, reverse=false, slop=0){

  slot_size=length/slot_count;
  offset= reverse?slot_size:0;
  odd= (slot_count%2) == 1?1:0;
  extra = odd && !reverse?1:0;

  for(x=[0:floor((slot_count + extra)/2) - 1]){
    translate([2*x*slot_size + offset -slop/2, 0]) square([slot_size + slop, panel_thickness]);
  }
}