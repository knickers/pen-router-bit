// Resolution
$fn = 32; // [24:1:48]

// Inner sleve inner diameter
inner_D = 3.4;
// Inner sleve pen tip diameter
inner_d = 2.5;
// Inner sleve height
inner_h = 30;

// Outer sleve outer diameter
outer_D = 6.35;
// Outer sleve height
outer_h = 50;

// Spring standoff
standoff = 10;

// Tolerance between inner and outer sleve
T = 0.2;

mid = inner_D + (outer_D - inner_D)/2;

module outer() {
	difference() {
		cylinder(d=outer_D, h=outer_h); // Outer Shell
		union() {
			translate([0, 0, standoff])
				cylinder(d=mid+T, h=outer_h-standoff-1); // Inner Shell
			translate([0, 0, outer_h-1])
				cylinder(d1=mid+T, d2=mid, h=1); // Taper Locker
		}
		translate([0, 0, 1])
			cylinder(d=inner_D+T*2, h=standoff); // Spring standoff
		translate([0, 0, outer_h-2])
			cylinder(d=mid, h=3); // Top render helper
	}
}

module inner() {
	difference() {
		union() {
			cylinder(d=mid-T, h=inner_h); // Outer Shell
			translate([0, 0, inner_h-1])
				cylinder(d1=mid-T, d2=mid, h=1); // Taper Locker
		}
		translate([0, 0, 1])
			cylinder(d=inner_D, h=inner_h); // Inner Shell
		translate([0, 0, -1])
			cylinder(d=inner_d, h=inner_h); // Pen tip opening
	}
}

module cut() {
	difference() {
		children();
		translate([0, -outer_D, -1])
			cube([outer_D, outer_D*2, outer_h+2]);
	}
}

module tapers() {
	translate([0, 0, -inner_h+1])
		cut()
			inner();

	translate([0, 0, outer_h])
		rotate(180, [1,0,0])
			cut()
				color("white")
					outer();
}

module render() {
	translate([outer_D, 0, 0])
		inner();

	translate([-outer_D, 0, 0])
		outer();
}

render();
/*
tapers();
cut() outer();
cut() inner();
*/
