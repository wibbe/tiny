module platform;

import bitmap;

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

interface IWindow {
   void show();
   void hide();

   bool pump();
   void paint(Bitmap image);
}


IWindow createWindow(string title, int width, int height) {
    version (Windows) {
        return Win32Window.create(title, width, height);
    }
}



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


      static IWindow create(string title, int width, int height) {
         if (!registerClass())
            return null;

         auto screenWidth = GetSystemMetrics(SM_CXSCREEN);
         auto screenHeight = GetSystemMetrics(SM_CYSCREEN);

         int windowWidth = width;
         int windowHeight = height;
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

         return new Win32Window(handle, windowWidth, windowHeight);
      }


      this(HWND handle, int windowWidth, int windowHeight) {
         _handle = handle;
         _windowWidth = windowWidth;
         _windowHeight = windowHeight;

         _windowBmi.bmiHeader.biSize = BITMAPINFOHEADER.sizeof;
         _windowBmi.bmiHeader.biWidth = windowWidth;
         _windowBmi.bmiHeader.biHeight = windowHeight;
         _windowBmi.bmiHeader.biPlanes = 1;
         _windowBmi.bmiHeader.biBitCount = 32;
         _windowBmi.bmiHeader.biCompression = BI_RGB;
         _windowBmi.bmiHeader.biSizeImage = 0;
         _windowBmi.bmiHeader.biXPelsPerMeter = 0;
         _windowBmi.bmiHeader.biYPelsPerMeter = 0;
         _windowBmi.bmiHeader.biClrUsed = 0;
         _windowBmi.bmiHeader.biClrImportant = 0;
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

      void paint(Bitmap image) {
         auto dc = GetDC(_handle);

         _windowBmi.bmiHeader.biWidth = image.width;
         _windowBmi.bmiHeader.biHeight = image.height;

         StretchDIBits(dc,
                       0, 0, _windowWidth, _windowHeight,
                       0, 0, image.width, image.height,
                       cast(VOID*)image.pixels.ptr,
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
      //Win32Window window = cast(Win32Window)_window;

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