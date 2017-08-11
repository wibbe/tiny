import std.stdio;
import tiny;


void main()
{
	auto r = Rect(0, 0, 100, 100);
	r.tr(10, 10);

	auto bitmap = new Bitmap(64, 64);

	auto v = Vec2(10.0f, 30.0f);
	writeln("Length: ", v.length);
	writeln("Dot: ", dot(Vec2(1f, 0f), Vec2(0.5f, 1f)));

	writeln("It runs! ", r.top);
}
