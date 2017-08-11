module tiny;

import std.math : sqrt;
public import bitmap;
public import context;

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

    Vector2!T opBinary(string op)(Vector2!T v) if (op == "+") {
        return Vector2!T(x + v.x, y + v.y);
    }
    
    Vector2!T opBinary(string op)(Vector2!T v) if (op == "-") {
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

T dot(T) (Vector2!T lfs, Vector2!T rhs) {
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

enum COLOR_TRANSPARENT = 0;
enum COLOR_BLACK = 1;
enum COLOR_WHITE = 2;


enum : uint {
    DRAW_FLIP_H = (1 << 1),
    DRAW_MASK   = (1 << 2),
}

interface IPainter {
    void clipReset();
    void clipSet(Rect rect);

    void clear(ubyte color);

    void pixel(int x, int y, ubyte color);
    void line(int x1, int y1, int x2, int y2, ubyte color);

    void rectStroke(Rect rect, ubyte color);
    void rectFill(Rect rect, ubyte color);

    void blit(int x, int y, Bitmap source, Rect sourceRect, uint flags = 0, ubyte color = 0);
}

interface IApplication {
    static IApplication create();
    
    void init(Context ctx);

    bool step(Context ctx);
    void paint(IPainter painter);
}

interface IWindow {
}

bool run(T)() {
    return false;
}
