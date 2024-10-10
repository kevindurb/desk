include <BOSL2/std.scad>

angle = 0;

work_area_size = [
  40 * INCH,
  24 * INCH,
  1.5 * INCH
];
work_area_offset = 4 * INCH;

box_size = [
  work_area_size.x - (work_area_offset * 2),
  6 * INCH,
  work_area_size.y - (work_area_offset * 2),
];

monitor_size = [
  28 * INCH,
  4 * INCH,
  20 * INCH,
];

module wall_box() {
  color_this("tan")
    diff()
    cube(box_size) {
      tag("remove")
      color_this("tan")
        back(box_size.y - (0.75 * INCH) - 1)
        attach(FRONT, BACK)
        cube(box_size - [(1.5 * INCH), (0.75 * INCH), (1.5 * INCH)]);
      children();
    }
}

module work_area() {
  color_this("white")
    cuboid(work_area_size, chamfer = 0.75 * INCH, edges = [TOP+FRONT, TOP+LEFT, TOP+RIGHT, TOP+BACK])
      children();
}

wall_box()
  attach(BOT, TOP, align=BACK)
    fwd(2 * INCH)
    work_area();
