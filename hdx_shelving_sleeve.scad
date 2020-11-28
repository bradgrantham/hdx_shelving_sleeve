// Replacement sleeve for HDX wire shelving storage unit, e.g. model 21656CPS

$fn=100;

tolerance_against_shelf = .2;
tolerance_against_leg = .4;
top = 39.4; // the actual height of the sleeve
height = 35; // set arbitrarily to make final part
leg_diameter = 25.40;
ring_radius_bottom = 30.6;
ring_radius_top = 29.1;
thickness_at_bottom = (ring_radius_bottom - leg_diameter) / 2;
thickness_at_top = (ring_radius_top - leg_diameter) / 2;
thickness_at_height = thickness_at_bottom + (thickness_at_top - thickness_at_bottom) / top * height;
top_angle_drop = 2;

module outline()
{
    polygon(points=[[0, 0], [thickness_at_bottom - tolerance_against_shelf,0], [thickness_at_height - tolerance_against_shelf, height - top_angle_drop],[0, height]]);
    translate([0, height/2]) circle(r = .4, $fn = 100);
}

module snapring()
{
    rotate_extrude(convexity = 10)
    translate([(leg_diameter + tolerance_against_leg) / 2 /* + (5.1/2 + 3.6/2) / 2 - tolerance_against_shelf */, height/2, 0])
    circle(r = .4, $fn = 100);
}

module sleeve()
{   
    $fa=1;
    rotate_extrude(convexity=1)
    translate([(leg_diameter + tolerance_against_leg) / 2,0,0])
    // rotate(90, [1, 0, 0])
    outline();
    // snapring();
}

clip_over = 5;
clip_height = 5;
clip_move = 0; // clip_over/2

module clipthing()
{
    translate([0,-clip_move,0]) {
        cube([10, clip_over, clip_height], center=true);
        translate([0,0,2.5])
            rotate(-90, [0,0,1])
            rotate(90, [1,0,0])
            linear_extrude(height=10, center=true)
            polygon(points=[[clip_over/2,0],[-clip_over/2,0],[-clip_over/2,clip_over/2]]);
        translate([0,0,-2.5])
            rotate(-90, [0,0,1])
            rotate(-90, [1,0,0])
            linear_extrude(height=10, center=true)
            polygon(points=[[clip_over/2,0],[-clip_over/2,0],[-clip_over/2,clip_over/2]]);
    }
}

module smoothed_clipthing()
{
    minkowski() {
        clipthing();
        sphere(r=.3);
    }
}

module one_half_sleeve()
{
    difference() {
        intersection() {
            sleeve();
            union() {
                translate([-25,0,0]) cube([50, 50, 50]);
                translate([15,-2, height / 2]) clipthing();
            };
        };
        rotate(180,[0,0,1]) translate([15,-2, height / 2]) smoothed_clipthing();
    }

}

one_half_sleeve();