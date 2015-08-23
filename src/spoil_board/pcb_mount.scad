use <simple_spoil_board.scad>;

module xy_home(){
  translate([34, 25]){children();}
}

module derp(){
  difference(){
    spoil_board();
    xy_home() square([102, 154]) ;
  }
}
%
derp();