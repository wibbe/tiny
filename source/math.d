module math;

import std.math : sqrt;


struct Vector2(T) {
    T x;
    T y;

    this(T x, T y) {
        this.x = x;
        this.y = y;
    }

    Vector2!T opBinary(string op)(Vector2!T v) const if (op == "+") {
        return Vector2!T(x + v.x, y + v.y);
    }
    
    Vector2!T opBinary(string op)(Vector2!T v) const if (op == "-") {
        return Vector2!T(x - v.x, y - v.y);
    }

    Vector2!T opUnary(string op : "-")() const {
        Vector2!T ret = this;
        ret.x = -x;
        ret.y = -y;
        return ret;
    }
}

alias Vector2!int Point;
alias Vector2!float Vec2;


float length(Vec2 v) {
    return sqrt(v.x * v.x + v.y * v.y);
}

float dot(Vec2 lfs, Vec2 rhs) {
    return lfs.x * rhs.x + lfs.y * rhs.y;
}


struct Rect {
	int left;
	int right;
	int top;
	int bottom;

	@property int width() const { return right - left; }
	@property int height() const { return bottom - top; }

    @property Point topLeft() const { return Point(left, top); }
    @property Point bottomRight() const { return Point(right, bottom); }


	this(int left, int right, int top, int bottom) {
		this.left = left;
		this.right = right;
		this.top = top;
		this.bottom = bottom;
	}

	static Rect fromSize(int x, int y, int w, int h) {
		return Rect(x, x + w, y, y + h);
	}

	bool inside(int x, int y) {
		return left <= x && x <= right && top <= y && y <= bottom;
	}
    
    bool inside(Point p) {
        return left <= p.x && p.x <= right && top <= p.y && p.y <= bottom;
    }
    
    Rect tr(int x, int y) {
		left += x;
		right += x;
		top += y;
		bottom += y;
		return this;
	}
}

enum NULL_RECT = Rect(int.min, int.min, int.min, int.min);

struct Color {
    uint rgba;

    @property ubyte r() const { return (rgba >> 16) & 0xff; }
    @property ubyte g() const { return (rgba >> 8) & 0xff; }
    @property ubyte b() const { return rgba & 0xff; }
    @property ubyte a() const { return (rgba >> 24) & 0xff; }

    this(ubyte r, ubyte g, ubyte b, ubyte a = 255) {
        rgba = (cast(uint)a << 24) | (cast(uint)r << 16) | (cast(uint)g << 8) | cast(uint)b;
    }
}