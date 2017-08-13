module bitmap;

import math;


enum : uint {
    DRAW_FLIP_H = (1 << 1),
    DRAW_MASK   = (1 << 2),
}

interface IPainter {
   @property int width();
   @property int height();

   void clipReset();
   void clipSet(Rect rect);

   void clear(Color color);

   void pixel(int x, int y, Color color);
   void line(int x1, int y1, int x2, int y2, Color color);

   void rectStroke(Rect rect, Color color);
   void rectFill(Rect rect, Color color);

   void blit(int x, int y, Bitmap source, Rect sourceRect, uint flags = 0, Color color = Color(0, 0, 0));
}


class Bitmap {
    private uint[] _pixels;
    private uint _width;
    private uint _height;

    @property int width() const { return _width; }
    @property int height() const { return _height; }
    @property uint[] pixels() { return _pixels; }

    this(uint width, uint height) {
        _width = width;
        _height = height;

        _pixels = new uint[width * height];
        for (int i = 0; i < (width * height); i++)
            _pixels[i] = 0;
    }
}


class BitmapPainter : IPainter {
   private Bitmap _target = null;
   private Rect _clip = NULL_RECT;

   @property int width() { return _target.width; }
   @property int height() { return _target.height; }


   this(Bitmap target) {
      _target = target;
      _clip = Rect(0, target.width - 1, 0, target.height - 1);
   }

   void clipReset() {
      _clip = Rect(0, _target.width - 1, 0, _target.height - 1);
   }

   void clipSet(Rect rect) {

   }

   void clear(Color color) {
      int len = _target.width * _target.height;
      uint[] pixels = _target.pixels;

      for (int i = 0; i < len; ++i) {
         pixels[i] = color.rgba;
      }
   }

   void pixel(int x, int y, Color color) {
      if (_clip.inside(x, y))
         _target.pixels[y * _target.width + x] = color.rgba;
   }

   void line(int x1, int y1, int x2, int y2, Color color) {

   }

   void rectStroke(Rect rect, Color color) {

   }

   void rectFill(Rect rect, Color color) {

   }

   void blit(int x, int y, Bitmap source, Rect sourceRect, uint flags = 0, Color color = Color(0, 0, 0, 0)) {

   }
}