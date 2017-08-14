import std.stdio;
import tiny;


extern (C) bool setup(Config* config) {
	config.title = "Test App";
	writeln("Setup!");
	return true;
}

extern (C) bool step() {
   return true;
}

extern (C) void paint(IPainter painter) {
	painter.clear(COLOR_WHITE);
	painter.pixel(10, 10, COLOR_BLACK);
	painter.pixel(painter.width - 10, painter.height - 10, COLOR_BLACK);
}
