import std.stdio;
import tiny;

void main()
{
	auto r = Rect(0, 0, 100, 100);
	r.tr(10, 10);

	writeln("It runs! ", r.top);
}
