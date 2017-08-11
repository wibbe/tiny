module bitmap;

import tiny;


class Bitmap {
    package ubyte[] _pixels;
    package uint _width;
    package uint _height;

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

class BitmapPainter : IPainter {
    private Bitmap _target = null;
    private Rect _clip = NULL_RECT;


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