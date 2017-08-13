import std.stdio;
import tiny;


class TestApp : IApplication {

	this() {
	}

	bool step() {
		return true;
	}

	void paint(IPainter painter) {
		painter.clear(COLOR_WHITE);
		painter.pixel(10, 10, COLOR_BLACK);
		painter.pixel(painter.width - 10, painter.height - 10, COLOR_BLACK);
	}
}

void main() {
	run!TestApp("Test App", 320, 240, 2);
}
