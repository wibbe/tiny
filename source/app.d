import std.stdio;
import tiny;


class TestApp : IApplication {
	bool step() {
		return true;
	}

	void paint(IPainter painter) {
	}
}

void main() {
	run!TestApp("Test App", 320, 240, 2);
}
