// Replacement sleeve for HDX wire shelving storage unit, e.g. model 21656CPS

$fn=75;

shrink_from_outer = .3;
top = 39.4; // the actual height of the sleeve
height = 20; // set arbitrarily to make final part
leg_diameter = 25.40;
enlarge_from_inner = .4;
ring_radius_bottom = 30.6;
ring_radius_top = 29.1;
thickness_at_bottom = (ring_radius_bottom - leg_diameter) / 2;
thickness_at_top = (ring_radius_top - leg_diameter) / 2;
thickness_at_height = thickness_at_bottom + (thickness_at_top - thickness_at_bottom) / top * height;

module outline()
{
    polygon(points=[[0, 0], [thickness_at_bottom - shrink_from_outer,0], [thickness_at_height - shrink_from_outer, height],[0, height]]);
}

module snapring()
{
    rotate_extrude(convexity = 10)
    translate([(leg_diameter + enlarge_from_inner) / 2 /* + (5.1/2 + 3.6/2) / 2 - shrink_from_outer */, height/2, 0])
    circle(r = .4, $fn = 100);
}

module sleeve()
{   
    $fa=1;
    rotate_extrude(convexity=1)
    translate([(leg_diameter + enlarge_from_inner) / 2,0,0])
    // rotate(90, [1, 0, 0])
    outline();
    snapring();
}

clip_over = 5;
clip_height = 5;

module clippythings()
{
    translate([15,0, height / 2 - clip_height / 2]) cube([10, clip_over, clip_height], center=true);
    translate([-15,0, height / 2 + clip_height / 2]) cube([10, clip_over, clip_height], center=true);
}

module smoothed_clippythings()
{
    minkowski() {
        clippythings();
        sphere(r=.1);
    }
}

module one_half_sleeve()
{
    difference() {
        intersection() {
            sleeve();
            union() {
                translate([-25,0,0]) cube([50, 50, 50]);
                rotate(180,[0,0,1]) clippythings();
            };
        };
        smoothed_clippythings();
    }
}

translate([0,10,0]) one_half_sleeve();
translate([0,-10,0]) rotate(180,[0,0,1]) one_half_sleeve();
