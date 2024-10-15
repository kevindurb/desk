include <BOSL2/std.scad>

$fa = 0.01;

open = 0; // [0:0.01:1]
open_door = 0; // [0:0.01:1]

work_area_size = [
  48*INCH,
  32*INCH,
  1.5*INCH
];
work_area_offset = 5 * INCH;

box_size = [
  work_area_size.x - (4*INCH),
  6 * INCH,
  work_area_size.y - (work_area_offset + 2*INCH),
];

monitor_size = [
  28 * INCH,
  3 * INCH,
  20 * INCH,
];

monitor_curve = 1500;

module electronics_door() {
  tag_scope("electronics_door")
  color("darkgrey")
    right(0.75*INCH)
    up(0.75*INCH)
    align(FRONT, LEFT+BOTTOM, inside = true)
    zrot(open_door*-90)
    diff()
    cube([6*INCH, 0.5*INCH, 11.5*INCH]) {
      tag_this("remove")
      align(CENTER, CENTER)
      xrot(90)
      cylinder(h=1*INCH, d=3*INCH);

      tag_this("remove")
      position(CENTER)
      xrot(90)
      cylinder(h=0.25*INCH + 1, r1=1.75*INCH, r2=2*INCH);
    }
}

module wall_box() {
  tag_scope("wall_box")
  color_this("tan")
    diff()
    cube(box_size) {
      // cut out
      tag_this("remove")
      color_this("tan")
        fwd(1)
        align(FRONT, inside=true)
        cube(box_size - [(1.5 * INCH), (0.5 * INCH), (1.5 * INCH)]);

      // double thick bottom
      tag_this("keep")
      color_this("tan")
        attach(BOTTOM, TOP)
        cube([box_size.x, box_size.y, 0.75*INCH]);

      // right vertical divider
      tag_this("keep")
      color_this("darkgrey")
        right((box_size.x / 2) - (7*INCH))
        attach(FRONT, BACK, inside = true)
        cube([0.5*INCH, box_size.y, box_size.z - (1.5*INCH)]);

      // left vertical divider
      tag_this("keep")
      color_this("darkgrey")
        left((box_size.x / 2) - (7*INCH))
        attach(FRONT, BACK, inside = true)
        cube([0.5*INCH, box_size.y, box_size.z - (1.5*INCH)]);

      // right horizontal divider
      tag_this("keep")
      color_this("darkgrey")
        left(0.75*INCH)
        align(FRONT, RIGHT, inside = true)
        cube([6*INCH, box_size.y, 0.5*INCH]);

      // left horizontal divider
      tag_this("keep")
      color_this("darkgrey")
        right(0.75*INCH)
        align(FRONT, LEFT, inside = true)
        cube([6*INCH, box_size.y, 0.5*INCH]);

      // left door
      tag_this("keep")
      electronics_door();

      tag_this("keep") children();
    }
}

module work_area() {
  tag_scope("work_area")
  color_this("white")
    cuboid(work_area_size, chamfer = 0.75 * INCH, edges = [TOP+FRONT, TOP+LEFT, TOP+RIGHT, TOP+BACK])
      children();
}

module monitor() {
  tag_scope("monitor")
  recolor("black")
    intersect()
    cube(monitor_size)
    attach(FRONT, BACK)
      down(monitor_size.y)
      tag_this("intersect") diff()
        cylinder(h=monitor_size.z + 2, r=monitor_curve)
        attach(CENTER, CENTER)
        tag_this("remove") cylinder(h=monitor_size.z + 4, r=monitor_curve - (0.5*INCH));
}

wall_box() {
  attach(BOT, TOP, align=BACK)
    fwd(box_size.y - work_area_offset)
    up(0.75*INCH)
    xrot(90 - (open * 90), cp=[0, -work_area_offset, 0])
    work_area();

  align(FRONT, TOP, inside = true)
    fwd(1*INCH)
    down(1*INCH)
    monitor();
}
