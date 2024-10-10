include <BOSL2/std.scad>

$fa = 0.01;

angle = 0;

work_area_size = [
  44 * INCH,
  32 * INCH,
  1.5 * INCH
];
work_area_offset = 3 * INCH;

box_size = [
  work_area_size.x - (work_area_offset * 2),
  6 * INCH,
  work_area_size.y - (work_area_offset * 2),
];

monitor_size = [
  28 * INCH,
  3 * INCH,
  20 * INCH,
];

module wall_box() {
  color_this("tan")
    diff()
    cube(box_size) {
      tag_this("remove")
      color_this("tan")
        back(box_size.y - (0.75 * INCH) - 1)
        attach(FRONT, BACK)
        cube(box_size - [(1.5 * INCH), (0.75 * INCH), (1.5 * INCH)]);
      tag_this("keep") tag_scope() children();
    }
}

module work_area() {
  color_this("white")
    cuboid(work_area_size, chamfer = 0.75 * INCH, edges = [TOP+FRONT, TOP+LEFT, TOP+RIGHT, TOP+BACK])
      children();
}

module monitor() {
  recolor("darkgrey")
    intersect()
    cube(monitor_size)
    attach(FRONT, BACK)
      down(monitor_size.y)
      tag_this("intersect") diff()
        cylinder(h=monitor_size.z + 2, r=1500)
        attach(CENTER, CENTER)
        tag_this("remove") cylinder(h=monitor_size.z + 4, r=1500 - (0.5*INCH));
}

wall_box() {
  attach(BOT, TOP, align=BACK)
    fwd(box_size.y - work_area_offset)
    work_area();

  attach(FRONT, BACK, align=TOP)
    fwd(1*INCH)
    down(2*INCH)
    monitor();
}
