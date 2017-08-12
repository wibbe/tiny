import std.stdio;
import tiny;


class TestApp : IApplication {
	static IApplication create(Context ctx) {
		return new TestApp();
	}

	bool step(Context ctx) {
		return true;
	}

	void paint(IPainter painter) {

	}
}

void main()
{
	auto r = Rect(0, 0, 100, 100);
	r.tr(10, 10);

	auto bitmap = new Bitmap(64, 64);

	auto v = Vec2(10.0f, 30.0f);
	writeln("Length: ", v.length);
	writeln("Dot: ", dot(Vec2(1f, 0f), Vec2(0.5f, 1f)));

	writeln("It runs! ", r.top);

	run!TestApp("Test App", 320, 240, 2);
}
