// OpenSCAD 2019.05
// (c) Joseph M. Haas, KE0FF, 04/30/2022
// Distribution and use of this file or its contents governed by the
//	GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007
//
// Yeti Drain Knob, REV-001
// Joe Haas, KE0FF, 01/06/2022
// This is an enlarged "circular wrench" (A.K.A., "knob") which allows a Yeti cooler
//	drain plug to be easily tightened and removed.  It attaches to the cooler via a
//	clip-lanyard.
//
// Rev-003, 4/30/2022
//	code cleanup and added conditionals
//	added rev code (bottom inside)
// Rev-002, 4/15/2022
//	removed lanyard tab and replaced with axial hole.
//

//----------------------------------------------------------------------------------------------------------------------
// User defined parameters.  Modify these to suit a particular application
// NOTE: All data in this file is in mm
//----------------------------------------------------------------------------------------------------------------------
// render conditionals
lanyard = 1;			// if "1", print lanyard "chevron", else print a simple thru-hole
debug = 0;				// if "1", enable debug features

// parametric variables:

height = 30;			// hieght of base cylinder (chamfer adds to this to get the overall height)
dia = 60;				// overall diameter
chamfer = 6;			// major chamfer dim
cylseg = 64;			// $fn value for large cylinders (reduce for faster render, but less accurate cylinder)
ydia = 21.5;			// central cylinder opening diameter
yheight = 21+(.2*25.4);	// inside max height
idia = 40;				// major ID
wrib = 6;				// width of slots to accept the "cross-tabs" of the Yeti drain plug
knurl_width = 6.5;		// Knurl (grips) dims
knurl_depth = 2;
knurl_height = 20;
knurl_cham = 2;

/////////////////////////////////////////////////////
// main STL rendering struct

color("lightslategray",1.0)
difference(){
	union(){
		// mid cham
		translate([0,0,height-knurl_height]) cylinder(r1=dia/2, r2 = (dia/2)-chamfer, h=chamfer, $fn=cylseg, center=false);
		color("lightslategray",1.0)
		difference(){
			union(){
				// top cham
				translate([0,0,height]) cylinder(r1=dia/2, r2 = (dia/2)-chamfer, h=chamfer, $fn=cylseg, center=false);
				// main body
				cylinder(r=dia/2, h=height, $fn=cylseg, center=false);
				// lanyard tab
				if(lanyard == 1){
					translate([0,0,height+chamfer-5]) rotate([90,-45,0]) top_loop();
				}
			}
			// remove the yeti drain-plug profile
			// cut the knurls
			translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
			rotate([0,0,30]) translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
			rotate([0,0,60]) translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
			rotate([0,0,90]) translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
			rotate([0,0,120]) translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
			rotate([0,0,150]) translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
			rotate([0,0,180]) translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
			rotate([0,0,210]) translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
			rotate([0,0,240]) translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
			rotate([0,0,270]) translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
			rotate([0,0,300]) translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
			rotate([0,0,330]) translate([0,(dia/2)-knurl_depth,height-knurl_height]) knurl();
		}
	}
	// cutaway (debug)
	if(debug == 1){
		translate([0,0,-.1]) cube([100,100,100]);
	}
	// end-debug

	if(lanyard != 1){
		// top cs
		translate([0,0,35.1])
			cylinder(r1=lhole, r2=lhole+lcham, h=lcham, $fn=32, center=true);
		// lanyard hole
		cylinder(r=.125*25.4, h=40, $fn=16);
	}
	// The "yknob()" module instantiates the inner cut-out which is intended to mate with the drain-plug head
	translate([0,0,-.01]) yknob();
	// rev# text
	rotate([0,0,15])
		translate([(idia/2)-10,(idia/2)-10,height-knurl_height-4-.02]) rotate([180,0,22]) linear_extrude(1) text("3", size=7);					// version & PN texts
}

///////////////////////////////////////////////////////////////////////////////////////////////
// MODULES... /////////////////////////////////////////////////////////////////////////////////

ledge = (dia-(2*chamfer)-.1)/sqrt(2);
lhole = 3;
erad = 10;
lthick = 10;
lcham = 2;

module top_loop(){
	difference(){
		union(){
			difference(){
				cube([ledge,ledge,lthick], center=true);										// main body
				translate([ledge/2,ledge/2,0]) cube([2*erad,2*erad,lthick+.1], center=true);	// corner notch
			}
			translate([(ledge/2)-erad,(ledge/2)-erad,0])										// corner-round
				cylinder(r=erad, h=lthick-(2*lcham), $fn=32, center=true);
			translate([(ledge/2)-erad,(ledge/2)-erad,(lthick-lcham)/2])							// top round cham
				cylinder(r1=erad, r2=erad-lcham, h=lcham, $fn=32, center=true);
			translate([(ledge/2)-erad,(ledge/2)-erad,-(lthick-lcham)/2])						// bot round cham
				cylinder(r2=erad, r1=erad-lcham, h=lcham, $fn=32, center=true);
		}
		// edge chams
		translate([0,(ledge/2)+.85,lthick/2]) rotate([45,0,0]) cube([ledge+2,2*lcham,2*lcham], center=true);
		translate([0,(ledge/2)+.85,-lthick/2]) rotate([45,0,0]) cube([ledge+2,2*lcham,2*lcham], center=true);
		translate([(ledge/2)+.85,0,lthick/2]) rotate([0,45,0]) cube([2*lcham,ledge+2,2*lcham], center=true);
		translate([(ledge/2)+.85,0,-lthick/2]) rotate([0,45,0]) cube([2*lcham,ledge+2,2*lcham], center=true);

		// lanyard hole
		translate([(ledge/2)-erad,(ledge/2)-erad,0]) cylinder(r=lhole, h=lthick+.01, $fn=32, center=true);
		// top cs
		translate([(ledge/2)-erad,(ledge/2)-erad,(lthick/2)])
			cylinder(r1=lhole, r2=lhole+lcham, h=lcham, $fn=32, center=true);
		// bot cs
		translate([(ledge/2)-erad,(ledge/2)-erad,-(lthick/2)])
			cylinder(r2=lhole, r1=lhole+lcham, h=lcham, $fn=32, center=true);
		// main cleave
		translate([-ledge/1.5,ledge/1.5,-lthick]) rotate([0,0,-135]) cube([2*ledge,2*ledge,2*lthick]);
	}
}

module yknob(){
		cylinder(r=ydia/2, h=yheight, $fn=cylseg, center=false);	// main cylinder
		cylinder(r=idia/2, h=5, $fn=cylseg, center=false);			// base relief
		cube([wrib,idia,2*yheight], center=true);					// cut-outs to match the drain-plug "kunrls"
		cube([idia,wrib,2*yheight], center=true);
}

module knurl(){
		// main channel
		translate([-knurl_width/2,0,0]) cube([knurl_width,2*knurl_depth,knurl_height+20]);
		// chamfers
		translate([-knurl_width/2,knurl_depth-knurl_cham,0]) rotate([0,0,45]) cube([knurl_width,knurl_depth,knurl_height+20]);
		translate([knurl_width/2,knurl_depth-knurl_cham,0]) rotate([0,0,45]) cube([knurl_width,knurl_depth,knurl_height+20]);
}

// EOF
