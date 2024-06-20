include <BOSL2/std.scad>
include <BOSL2/beziers.scad>
include <path_extrude.scad>
include <elliptical_propblade.scad>
$fn=60;

module SonexB () {
    tail_wing();
    union () {
        translate([0,0,0]) wing_left(-8);
        translate([0,0,0]) wing_right(-8);
        wing_main(-8);
    }
    main_prop();
    landing_gear();
    landing_gear_tail();

    color("#99ccff")cockpit_glass();
    cockpit_pedals(-55,15);
    cockpit_seats();
    cockpit_yoke();
    cockpit_structural();
    cockpit_flaps();
    cockpit_trim();
    cockpit_engine_ctrl();

    difference() {
        union() {
            fuselage();
            cockpit_panel_top();
            tail_fin();
        }
        // cutout rudder hinge
        difference() {
            translate([323.3,0,-1]) cylinder(r=4,h=91);
            translate([323.8,0,-1]) cylinder(r=4,h=90.9);
        }
        // cutout rudder crossing elevators
        translate([335,0,90]) cube([20,10,0.1],true);
        cockpit_cutout(); 
    }
}
module cockpit_cutout () {
    translate([-10,-49,-10]) cube([70,98,54]);
    translate([-50,-49,-10]) cube([40,98,49]);
}
module cockpit_flaps () {
    for(m=[[0,0,0],[0,1,0]])
        mirror(m) {
        translate([-3,-47,2])
            cube([3,1,15]);
        translate([-3.5,-47,17])
            cuboid([4,1,8], rounding=.4, edges="Z", $fn=20,
                anchor=BOTTOM+LEFT+FRONT, spin=[-30,0,0]);
    }
    for(y=[-46.3,46.3])
    translate([0,y,-10]) cuboid([8,.4,10], $fn=24,
        anchor=BOTTOM+RIGHT+BACK, rounding=6, edges=LEFT+TOP
    );
}
module cockpit_engine_ctrl () {
    for(y=[-3,3])
    translate([10,y,41]) {
        cylinder(r=.4, h=15, anchor=BOTTOM, orient=LEFT);
        
        cyl(r=1, l=2, anchor=TOP, orient=LEFT, chamfer=.4);
    }
}
module cockpit_trim () {
    translate([-04,-36,48]) difference(){
        cyl(d=7, l=2, chamfer=.2, orient=LEFT);
        
        for(d=[0:30:359])
        rotate([d,0,0])
        translate([1,0,3.5])
        cyl(d=1, l=1, chamfer=.1, orient=LEFT, $fn=12);
    }
}
module cockpit_structural () {
    *translate([-10,-39,40]) cuboid([1,10,8], $fn=20,
        anchor=TOP+RIGHT+BACK, rounding=8, edges=BACK+BOTTOM
    );
    translate([-46,0,-10]) difference() {
        cuboid([8,1,50], $fn=10, anchor=BOTTOM,
            rounding=.4, edges=[FRONT+RIGHT,BACK+RIGHT]);
        
        for (z=[3:8:48])
        translate([0,0,z])
            cylinder(r=2, anchor=BACK, orient=BACK, $fn=12);
    }
    
    difference() {
        union() {
            translate([5,0,-4]) cuboid([10,98,12], $fn=10, 
                rounding=.2, edges=[LEFT+TOP,TOP+RIGHT]
            );
                
            translate([40,0,-5]) cuboid([10,98,10], $fn=10, 
                rounding=.2, edges=[LEFT+TOP,TOP+RIGHT]
            );
        }
        union() {
          
            translate([5,0,-6]) cuboid([8,99,8], $fn=10, 
                rounding=.2, edges=[LEFT+TOP,TOP+RIGHT]
            );
            translate([40,0,-6]) cuboid([8,99,8], $fn=10, 
                rounding=.2, edges=[LEFT+TOP,TOP+RIGHT]
            );  
            for (y=[-40:10:40]) translate([-10,y,-5])
                cylinder(r=3, h=60, orient=RIGHT, $fn=12);
        }
    }
}
module cockpit_panel_top () {
    z=56;
    cockpit_panel = [
        [[-10,-49, 40],[ -20,-40, z], [ -20,-30, z], [-20, 0, z]],
        [[-60,-45, 40],[ -70,-30, z], [ -70,-20, z], [-70, 0, z]]
    ];
    hull() {
        bshape(cockpit_panel,false);
        mirror([0,1,0]) bshape(cockpit_panel,false);
    }
}
module cockpit_pedals (x,z) {
    for(y=[-40,4]) translate([x,y,z-20]) {
        // rudder
        color("#404040")difference() {
            cube([1,16,20]);
            translate([-.1,1,1]) cube([1.2,14,19]);
        }
        // brake
        color("#400000")translate([-3,0,8]) difference(){
            cube([1,16,12]);
            translate([-.1,1,1]) 
                cube([1.2,14,11]);
        }
    }
    for(y=[-20,24]) translate([x+2,y,z-20]) {
        color("#404040")difference() {
            cube([1,16,20]);
            translate([-.1,1,1]) cube([1.2,14,19]);
        }
        color("#400000") translate([-5,0,8]) difference() {
            cube([1,16,12]);
            translate([-.1,1,1]) 
                cube([1.2,14,11]);
        }
    }
    translate([x,49.5,z]) rotate([90,0,0])
        cylinder(r=1,h=99, $fn=10);
}
module cockpit_seats() {
    cockpit_seat();
    mirror([0,1,0])cockpit_seat();
}
module cockpit_seat() {
    minkowski() { union(){
            translate([5,6,0]) cube([10,35,4]);
            translate([15,1,0]) cube([40,40,4]);
        }
        sphere(r=1, $fn=16);
    }
    minkowski() {
        translate([50,1,6]) rotate([0,10,0]) cube([4,40,40]);
        sphere(r=1, $fn=16);
    }
}
module cockpit_yoke() {
    translate([5,0,-10]) cylinder(r=1, h=35);
    for(d=[45,-45])
    translate([5,0,25]) rotate([d,0,0]){
        cylinder(r=1, h=4);
        translate([0,0,3]) handle();
    }
}
module handle() {
    scale([.5,.4,1])
    rotate_extrude()
        polygon([
          [0,0], [2,0], [3,1], [3,2], [2.6,3], [2.6,13],[2.4,14],[2,15],[0,15]
        ]);
    difference() {
        translate([0,0,14]) scale([.8,.9,.4]) sphere(r=3);
        difference(){
            translate([0,0,14]) sphere(r=4);
            translate([-2.5,0,14]) sphere(r=4);
        }
        difference() {
            translate([0,-1,14]) sphere(r=4);
            translate([0,-2.6,14]) sphere(r=4);
        }
    }
}
module bshape(nodes,debug=false) {
    if (debug)
      debug_bezier_patches(patches=[nodes], size=1);
    else
      vnf_polyhedron(bezier_vnf(nodes, splinesteps=64));
}
module wing2d(x,y,t=2/5) {
    hull() {
        translate([y*5,y/2,0]) {
            difference() {
                scale([10,2,1]) circle(y/2);
                translate([-y*5,-10,0]) square([y*10,10]);
            }
        }
        translate([y*5,y/2,0]) {
            difference() {
                scale([10,1,1]) circle(y/2);
                translate([-y*5,0,0]) square([y*10,10]);
            }
        }
        translate([x,y*t,0]) circle(0.1);
    }
}
module wing3d(x,y,z,t=2/5) {
    linear_extrude(z) wing2d(x,y,t);
}
module wing_main (z) {
    difference() {
        translate([-30,120,z]) rotate([90,0,0])
            wing3d(100,8,240);
        
        difference() {
            translate([50,120,z+4.5]) rotate([90,0,0])
                cylinder(r=4,h=240);
            translate([50.1,120,z+4.5]) rotate([90,0,0])
                cylinder(r=4,h=240);
        }
        for (y=[-120,120])
        hull(){
            translate([80,y,z+4])
                cube([10,.4,10],true);
            translate([50,y,z+4.5])rotate([90,0,0])
                cylinder(r=4,h=.4,center=true);
        }
        hull(){
            translate([80,0,z+4])
                cube([10,102,10],true);
            translate([50,0,z+4.5]) rotate([90,0,0])
                cylinder(r=4,h=102,center=true);
        }
        translate([-40,-49.5,-10])
            cube([110,99,20]);
    }
}
module wing_left (z) { 
    difference(){
        hull() {
            translate([-30,-120,z]) rotate([90,00,0])
                wing3d(100,8,0.01);
            translate([-30,-300,z+10]) rotate([90,00,0])
                wing3d(100,8,0.01);
        }
        difference(){
            translate([50,-119,z+4.4]) rotate([86.8,0,0])
                cylinder(r=4,h=182);
            translate([50.1,-119,z+4.4]) rotate([86.8,0,0])
                cylinder(r=4,h=182);
        }
        intersection() 
        {
            translate([-31,-310,z])  cube([102,30,30]);
            translate([10,-200,z]) {
                difference(){
                    translate([0,-20,0.1])
                    scale([4,2,1])
                        cylinder(r1=46,r2=50,h=29.8);
                    scale([4,2,1])
                        cylinder(r1=46,r2=50,h=30);
                }
            }
        }
    }
}
module wing_right (z) {
    difference() {
        hull() {
            translate([-30,120,z]) rotate([90,00,0])
                wing3d(100,8,0.01);
            translate([-30,300,z+10]) rotate([90,00,0])
                wing3d(100,8,0.01);
        }
        difference(){
            translate([50,301,z+14.6]) rotate([93.2,0,0])
                cylinder(r=4,h=182);
            translate([50.1,301,z+14.6]) rotate([93.2,0,0])
                cylinder(r=4,h=182);
        }
        mirror([0,1,0])
        intersection() 
        {
            translate([-31,-310,z])  cube([102,30,30]);
            translate([10,-200,z]) {
                difference(){
                    translate([0,-20,0.1])
                    scale([4,2,1])
                        cylinder(r1=46,r2=50,h=29.8);
                    scale([4,2,1])
                        cylinder(r1=46,r2=50,h=30);
                }
            }
        }
    }
}

module fuselage() {
    //tail section
    fuselage_back_top = [
        [[160,-50, 40], [190,-50, 90], [190,-25, 90], [190, 25, 90], [190, 50, 90], [160, 50, 40]],
        [[420, -2, 40], [420,-1.5,40], [420, -1, 40], [420,  1, 40], [420,1.5, 40], [420,  2, 40]],
    ];
    difference() {
        hull(){
            for (x=[50,-50]) translate([60,x,-10]) sphere(1, $fn=20);
            for (x=[50,-50]) translate([60,x,40]) sphere(.0001, $fn=4);
            translate([320,0,0])  cylinder(r=2, h=40);
            translate([-100,0,0]) bshape(fuselage_back_top,false);
        }
    }
    //* nose
    nose = [
        [[ 40,-50,-11], [ 25, -50,-11], [ 25, -10,-11], [ 25,  10,-11], [ 25, 50,-11], [ 40, 50,-11]],
        [[  0,-50,-10], [-50, -50,-10], [-25, -50,-10], [-25,  50,-10], [-50, 50,-10], [  0, 50,-10]],
        [[ 25,-50, 40], [-100,-50, 40], [-75, -50, 40], [-75,  50, 40], [-100,50, 40], [ 25, 50, 40]],
        [[ 25,-50, 40], [-120,-50, 40], [-110,-50, 40], [-110, 50, 40], [-120,50, 40], [ 25, 50, 40]],
        [[ 25,-50, 40], [ 10, -50, 60], [ 10, -25, 60], [ 10,  25, 60], [ 10, 50, 60], [ 25, 50, 40]],
    ];
    difference() {
        translate([-80,0,0]) hull() {
            bshape(nose,false);
            
           for (x=[50,-50]) translate([40,x,-10])
                sphere(1, $fn=20);
        }
        difference() {
            translate([-110,0,36]) scale([1,2,.8])
                sphere(40);
            
            translate([-98,0,34]) scale([1,2,.8])
                sphere(40,$fn=200);
        }
        translate([-140,0,33]) rotate([0,90,0])
            scale([0.9,3.2,1]) cylinder(h=10,r=10);
    }
    // cockpit
    hull() {
      for (x=[60,-40]) for (y=[50,-50])
        translate([x,y,-10]) sphere(1, $fn=20);
       
      for (x=[60,-55]) for (y=[50,-50])
        translate([x,y,40]) sphere(.0001, $fn=4);
    }
}

module cockpit_glass () {
    cockpit_front = [
        [[ 35,-50, 40], [ 20,-50, 60], [ 20,-25, 60], [ 20, 25, 60], [ 20, 50, 60], [ 35, 50, 40]],
        [[ 90,-50, 40], [ 65,-50, 77], [ 65,-25, 77], [ 65, 25, 77], [ 65, 50, 77], [ 90, 50, 40]],
    ];
    translate([-100,0,50])
        difference(){
            hull() bshape(cockpit_front,false);
            translate([-0.2,0,0]) scale([1.02,0.98,0.98])
                hull() bshape(cockpit_front,false);
        }
    cockpit_door = [
        [[100,-50, 40], [ 75,-50, 77], [ 75,-25, 77], [ 75, 25, 77], [ 75, 50, 77], [100, 50, 40]],
        [[100,-50, 40], [150,-50,100], [150,-25,100], [150, 25,100], [150, 50,100], [100, 50, 40]],
        [[160,-50, 40], [190,-50, 90], [190,-25, 90], [190, 25, 90], [190, 50, 90], [160, 50, 40]],
    ];
    translate([-100,0,50]) {
        difference() {
            hull() bshape(cockpit_door,false);
            scale([1.1,0.98,0.98]) translate([-10,0,0])
                hull() bshape(cockpit_door,false);
        }
    }
}
module tail_fin () {
    hull() {
        translate([260,0,00])
            sphere(2, $fn=40);
        
        translate([310,0,100]) scale([2,1,1])
            sphere(2);
        
        translate([320,0,0])
            cylinder(r=2, h=90);
        
        translate([340,0,0])
            cylinder(r=.3, h=100);
    }
}

module tail_wing () {
    difference() {
        hull() {
            translate([280,0,38]) scale([2,1,1])
                sphere(2, $fn=40);
            
            for (y = [-100,100]) {
                translate([310,y,38]) scale([2,1,1])
                    sphere(2, $fn=40);
            
                translate([320,y,38])
                    sphere(2, $fn=40);
            
                translate([340,y,38])
                    sphere(.3, $fn=40);
            }
        }
        translate([323.6,0,0]) {
            for (y=[-90,90]) hull() {
                translate([30,y,38])
                    cube([10,.4,10],true);
                translate([0,y,38])rotate([90,0,0])
                    cylinder(r=4,h=.4,center=true);
            }
            hull(){
                translate([30,0,38])
                    cube([10,20,10],true);
                translate([0,0,38])rotate([90,0,0])
                    cylinder(r=4,h=4.6,center=true);
            }
            
            difference() {
                translate([0,90,38]) rotate([90,0,0])
                    cylinder(r=4,h=180);
                translate([0.1,90,38]) rotate([90,0,0])
                    cylinder(r=4,h=180);
            }
        }
        translate([320,0,0])
            cylinder(r=2, h=90);
    }
}
module landing_gear () {
    // struts
    offset = 40;
    landing_gear_strut = [
        [-offset,0,0],[7,0,0],[10,0,.5],[11.75,0,1],[13,0,2],[14,0,4],[24,0,28],[26,0,31]
    ];
    for (y=[-40,40]) translate([-15,y,-11.8]) rotate([180,0,y*(9/4)])
        path_extrude(exShape=[[10,1],[10,0],[0,0],[0,1]], exPath=[
            for(a=landing_gear_strut) [0,5,0] + a 
        ]);
    // housing
    for (y = [-70,70]) {
    difference() {
        hull() {
            translate([-15, y,-40]) scale([2,.5,1])
                sphere(r=10);
                    
            translate([15, y, -42])
                sphere(r=1);
        }
        // bottom cutoff
        difference() {
            translate([-26, y,-40]) scale([2,1,0.5])
                sphere(r=24);
            translate([-26, y,-32]) scale([2,1,0.5])
                sphere(r=24);
        }
    }
    // wheels
    translate([-15,y,-60]) rotate([90,0,0]) scale([.33,.33,.25])
        rotate_extrude() {
            translate([-16, 2, 0]) circle(r = 10, $fn=21);
            translate([-16,-2, 0]) circle(r = 10, $fn=21);
            translate([-11,-10,0])square([11,20]);
        }
    }
}
module landing_gear_tail () {
    // strut
    translate([310,0,0]) rotate([0,99.3,0])
        cylinder(r=.4, h=27, $fn=8);
    
    difference() {
        translate([340,0,-5.318]) rotate([0,9.3,0]) scale([1.4,.6,1])
            linear_extrude(.8) circle(r=3);
        translate([341,0,-5.5]) rotate([0,9.3,0]) scale([1.4,.6,1])
            linear_extrude(1) circle(r=3);
    }
    // wheel
    translate([340,.5,-5]) rotate([90,0,0]) {
        minkowski($fn=20) {
            cylinder(r=1,h=1);
            sphere(r=1,$fn=20);
        }
        translate([0,0,-1.5]) cylinder(r=.1,h=4,$fn=10);
    }
}
module main_prop(blades=2) {
    //nose cone
    translate([-140,0,33]) {
        rotate([0,90,0]) 
            cylinder(h=20,r=10);
        rotate([9,0,0]) scale([2,1,1]) 
            sphere(r=10);
        translate([-16,0,0]) rotate([0,90,180])
            propeller(blades=blades, propdia=120, hubdia=18, fairing=4);
    }
}
SonexB();