module tiny;

import std.math : sqrt;

enum Key {
	Left = 37,
    Right = 39,
    Up = 38,
    Down = 40,
    Space = 32,
    Escape = 27,
    Ctrl = 17,
    Shift = 16,
    Enter = 13,
    Backspace = 8,
    Period = 188,
    Point = 190,
    Minus = 189,
    Num0 = 48,
    Num1 = 49,
    Num2 = 50,
    Num3 = 51,
    Num4 = 52,
    Num5 = 53,
    Num6 = 54,
    Num7 = 55,
    Num8 = 56,
    Num9 = 57,
    A = 65,
    B = 66,
    C = 67,
    D = 68,
    E = 69,
    F = 70,
    G = 71,
    H = 72,
    I = 73,
    J = 74,
    K = 75,
    L = 76,
    M = 77,
    N = 78,
    O = 79,
    P = 80,
    Q = 81,
    R = 82,
    S = 83,
    T = 84,
    U = 85,
    V = 86,
    W = 87,
    X = 88,
    Y = 89,
    Z = 90
}

struct Vector2(T) {
    T x;
    T y;

    this(T x, T y) {
        this.x = x;
        this.y = y;
    }
}

alias Vector2!int Point;
alias Vector2!float Vec2;

float length(Vec2 v) {
    return sqrt(v.x * v.x + v.y * v.y);
}

T dot(T) (Vector2!T lfs, Vector2!T rhs) {
    return lfs.x * rhs.x + lfs.y * rhs.y;
}


struct Rect {
	int left;
	int right;
	int top;
	int bottom;

	@property int width() { return right - left; }
	@property int height() { return bottom - top; }

    @property Point topLeft() { return Point(left, top); }
    @property Point bottomRight() { return Point(right, bottom); }


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

	Rect tr(int x, int y) {
		left += x;
		right += x;
		top += y;
		bottom += y;
		return this;
	}
}

enum NULL_RECT = Rect(int.min, int.min, int.min, int.min);

