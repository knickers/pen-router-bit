$fn = 32;

T = 0.1;

outer_D = 6.35;
outer_h = 50;

inner_D = 3;
inner_d = 2;
inner_h = 30;

spring_retainer = 10;

mid = inner_D + (outer_D - inner_D)/2.7;

module outer() {
	difference() {
		cylinder(d=outer_D, h=outer_h); // Outer Shell
		union() {
			translate([0, 0, spring_retainer])
				cylinder(d=mid+T, h=outer_h-spring_retainer-1); // Inner Shell
			translate([0, 0, outer_h-1])
				cylinder(d1=mid+T, d2=mid, h=1); // Taper Locker
		}
		translate([0, 0, 1])
			cylinder(d=inner_D+T*2, h=spring_retainer); // Spring retainer
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
