module tiny;

import std.math : sqrt;
import std.stdio : writeln;
import std.datetime.stopwatch : StopWatch, AutoStart;
import core.time : Duration;
import core.thread : Thread, nsecs;


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

enum COLOR_TRANSPARENT = 0;
enum COLOR_BLACK = 1;
enum COLOR_WHITE = 2;


class Bitmap {
    private ubyte[] _pixels;
    private uint _width;
    private uint _height;

    @property int width() const { return _width; }
    @property int height() const { return _height; }
    @property ubyte[] pixels() { return _pixels; }

    this(uint width, uint height) {
        _width = width;
        _height = height;

        _pixels = new ubyte[width * height];
        for (int i = 0; i < (width * height); i++)
            _pixels[i] = 0;
    }
}

class Palette {
   private Color[] _colors;

   @property Color[] colors() { return _colors; }


   this() {
      _colors = [ 
         Color(0, 0, 0, 0),
         Color(0, 0, 0, 255),
         Color(255, 255, 255, 255)
      ];
   }

   ubyte add_color(Color color) {
      foreach (int i, Color c; _colors) {
         if (c.rgba == color.rgba)
            return cast(ubyte)i;
      } 

      _colors ~= color;
      return cast(ubyte)(_colors.length - 1);
   }
}

class BitmapPainter : IPainter {
   private Bitmap _target = null;
   private Rect _clip = NULL_RECT;

   @property int width() { return _target.width; }
   @property int height() { return _target.height; }


   this(Bitmap target) {
      _target = target;
   }

   void clipReset() {

   }

   void clipSet(Rect rect) {

   }

   void clear(ubyte color) {
      int len = _target.width * _target.height;
      ubyte[] pixels = _target.pixels;

      for (int i = 0; i < len; ++i) {
         pixels[i] = color;
      }
   }

   void pixel(int x, int y, ubyte color) {
      _target.pixels[y * _target.width + x] = color;
   }

   void line(int x1, int y1, int x2, int y2, ubyte color) {

   }

   void rectStroke(Rect rect, ubyte color) {

   }

   void rectFill(Rect rect, ubyte color) {

   }

   void blit(int x, int y, Bitmap source, Rect sourceRect, uint flags = 0, ubyte color = 0) {

   }
}


enum : uint {
    DRAW_FLIP_H = (1 << 1),
    DRAW_MASK   = (1 << 2),
}

interface IPainter {
   @property int width();
   @property int height();

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
    bool step();
    void paint(IPainter painter);
}

interface IWindow {
   void show();
   void hide();

   bool pump();
   void paint(Bitmap image, Color[] palette);
}


private __gshared IWindow _window = null;
private __gshared Palette _palette = null;

private __gshared double _frameTime = 0.0;
private __gshared double _stepTime = 0.0;
private __gshared double _paintTime = 0.0;
private __gshared double _blitTime = 0.0;

@property IWindow window() { return _window; }
@property Palette palette() { return _palette; }
@property double frameTime() { return _frameTime; }
@property double stepTime() { return _stepTime; }
@property double paintTime() { return _paintTime; }


bool run(T)(string title, int width, int height, int scaleFactor) {
   version (Windows) {
      _window = Win32Window.create(title, width, height, scaleFactor);
   }

   if (_window is null)
      return false;

   Bitmap canvas = new Bitmap(width, height);
   BitmapPainter canvasPainter = new BitmapPainter(canvas);

   _palette = new Palette();

   auto app = new T();
   _window.show();

   auto frameWatch = new StopWatch(AutoStart.yes);
   enum TARGET_FRAME_TIME = nsecs(33333333);


   while (true) {
      frameWatch.reset();

      if (!_window.pump())
         break;

      if (!app.step())
         break;

      auto stepNow = frameWatch.peek();
      _stepTime = cast(double)stepNow.split!("nsecs").nsecs / 1_000_000_000.0;

      app.paint(canvasPainter);

      auto paintNow = frameWatch.peek();
      _paintTime = (cast(double)paintNow.split!("nsecs").nsecs / 1_000_000_000.0) - _stepTime;

      _window.paint(canvas, _palette.colors);
      auto blitNow = frameWatch.peek();

      auto frameDuration = frameWatch.peek();
      _frameTime = cast(double)frameDuration.split!("nsecs").nsecs / 1_000_000_000.0;

      if (frameDuration < TARGET_FRAME_TIME) {
         auto sleepTime = TARGET_FRAME_TIME - frameDuration;
         Thread.sleep(sleepTime);
      }
   }

   return true;
}

// -- Windows Implementation --------------------------------------------------
version (Windows) {
   import core.sys.windows.windows;
   import std.utf : toUTF16z;

   pragma(lib, "gdi32.lib");
   pragma(lib, "user32.lib");

   private enum WND_CLASS_NAME = "TinyWindowClass";
   private enum WND_STYLE = WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX;


   private class Win32Window : IWindow {
      private HWND _handle;
      private BITMAPINFO _windowBmi;
      private uint[] _windowBuffer;

      private int _canvasWidth;
      private int _canvasHeight;
      private int _windowWidth;
      private int _windowHeight;


      static IWindow create(string title, int width, int height, int scaleFactor) {
         if (_window !is null)
            return null;

         if (!registerClass())
            return null;

         auto screenWidth = GetSystemMetrics(SM_CXSCREEN);
         auto screenHeight = GetSystemMetrics(SM_CYSCREEN);

         int windowWidth = width * scaleFactor;
         int windowHeight = height * scaleFactor;
         int windowLeft = (screenWidth - width) / 2;
         int windowTop = (screenHeight - height) / 2;

         RECT rc;
         rc.left = windowLeft;
         rc.right = windowLeft + windowWidth;
         rc.top = windowTop;
         rc.bottom = windowTop + windowHeight;

         AdjustWindowRect(&rc, WND_STYLE, FALSE);

         auto handle = CreateWindowExW(0,
                                       toUTF16z(WND_CLASS_NAME),
                                       toUTF16z(title),
                                       WND_STYLE,
                                       rc.left, rc.top,
                                       rc.right - rc.left, rc.bottom - rc.top,
                                       null, null,
                                       GetModuleHandleW(null),
                                       null);

         return new Win32Window(handle, width, height, windowWidth, windowHeight);
      }


      this(HWND handle, int canvasWidth, int canvasHeight, int windowWidth, int windowHeight) {
         _handle = handle;
         _canvasWidth = canvasWidth;
         _canvasHeight = canvasHeight;
         _windowWidth = windowWidth;
         _windowHeight = windowHeight;

         _windowBmi.bmiHeader.biSize = BITMAPINFOHEADER.sizeof;
         _windowBmi.bmiHeader.biWidth = canvasWidth;
         _windowBmi.bmiHeader.biHeight = canvasHeight;
         _windowBmi.bmiHeader.biPlanes = 1;
         _windowBmi.bmiHeader.biBitCount = 32;
         _windowBmi.bmiHeader.biCompression = BI_RGB;
         _windowBmi.bmiHeader.biSizeImage = 0;
         _windowBmi.bmiHeader.biXPelsPerMeter = 0;
         _windowBmi.bmiHeader.biYPelsPerMeter = 0;
         _windowBmi.bmiHeader.biClrUsed = 0;
         _windowBmi.bmiHeader.biClrImportant = 0;

         _windowBuffer = new uint[canvasWidth * canvasHeight];
      }

      void show() {
         ShowWindow(_handle, SW_SHOW);
      }

      void hide() {
         ShowWindow(_handle, SW_HIDE);
      }

      bool pump() {
         MSG msg;

         while (PeekMessageW(&msg, null, 0, 0, PM_REMOVE) != FALSE) {
            if (msg.message == WM_QUIT)
               return false;

            TranslateMessage(&msg);
            DispatchMessageW(&msg);
         }

         return true;
      }

      void paint(Bitmap image, Color[] palette) {
         auto pixels = image.pixels;

         int i = 0;
         for (int y = 0; y < _canvasHeight; y++) {
            for (int x = 0; x < _canvasWidth; x++) {
               _windowBuffer[i] = palette[pixels[x + (_canvasHeight - y - 1) * image.width]].rgba;
               i += 1;
            }
         }

         auto dc = GetDC(_handle);

         StretchDIBits(dc,
                       0, 0, _windowWidth, _windowHeight,
                       0, 0, _canvasWidth, _canvasHeight,
                       cast(VOID*)_windowBuffer.ptr,
                       &_windowBmi,
                       DIB_RGB_COLORS,
                       SRCCOPY);

         ReleaseDC(_handle, dc);
      }

      private static bool registerClass() {
         WNDCLASSEX def;
         def.cbSize = WNDCLASSEXW.sizeof;
         def.style = CS_HREDRAW | CS_VREDRAW | CS_OWNDC;
         def.lpfnWndProc = cast(WNDPROC)&wndProc;
         def.cbClsExtra = 0;
         def.cbWndExtra = 0;
         def.hInstance = GetModuleHandleW(null);
         def.hIcon = LoadIconW(null, IDI_APPLICATION);
         def.hCursor = LoadCursorW(null, IDC_ARROW);
         def.hbrBackground = cast(HBRUSH)GetStockObject(WHITE_BRUSH);
         def.lpszMenuName = null;
         def.lpszClassName = toUTF16z(WND_CLASS_NAME);
         def.hIconSm = null;

         if (!RegisterClassExW(&def))
            return false;

         return true;
      }
   }

   extern (Windows) LRESULT wndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam) {

      switch (message) {
         case WM_DESTROY:
            PostQuitMessage(0);
            break;

         default:
            break;
      }

      return DefWindowProcW(hwnd, message, wParam, lParam);
   }
}